#!/usr/bin/env node

import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { createInterface } from 'node:readline/promises';
import { fileURLToPath } from 'node:url';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const templateRoot = path.join(repoRoot, 'templates', 'core');
const validNodeKinds = new Set(['solution', 'project', 'module', 'workshop', 'research', 'learning', 'other']);

const requiredFiles = [
  'CLAUDE.md',
  'AGENTS.md',
  '.claude/PM.md',
  '.claude/STONE.md',
  '.claude/ACTORS.md',
  '.claude/TOOLS.md',
  '.claude/WORKFLOW.md',
  '.claude/skills/sos/SKILL.md',
  '.claude/commands/sos/assistant.md',
  '.claude/commands/sos/help.md',
  '.claude/commands/sos/about.md',
  '.claude/commands/sos/init.md',
  '.claude/commands/sos/summary.md',
  '.claude/commands/sos/audit.md',
  '.claude/commands/sos/tools.md',
  '.claude/commands/sos/ingest.md',
  '.claude/commands/sos/migrate.md',
  '.claude/commands/sos/vault-process.md',
  '.claude/commands/sos/vault-summary.md',
  '.claude/commands/sos/archive.md',
  '.claude/commands/sos/unarchive.md',
  '.claude/commands/sos/context-export.md',
  '.claude/commands/sos/context-import.md',
  '.claude/commands/sos/session-close.md',
  '.claude/commands/sos/presentation-generate.md',
  '.claude/sos/sos.json',
  '.claude/sos/VERSION.md',
  '.claude/sos/COMMANDS.md',
  '.claude/sos/ASSISTANT.md',
  '.claude/sos/SOS-VISUAL.html',
  '.claude/sos/SCHEMA.md',
  '.claude/sos/TOOLKITS.md',
  '.claude/sos/template/concept-binding.md',
  '.claude/sos/produce/presentation/README.md',
  '.claude/sos/produce/presentation/house-style.md',
  '.claude/sos/produce/presentation/output-styles.md',
  '.claude/sos/produce/presentation/manifest-template.md',
  '.claude/sos/scripts/README.md',
  '.claude/sos/scripts/sos-summary.ps1',
  '.claude/sos/scripts/sos-audit.ps1',
  '.claude/sos/scripts/sos-migrate-assess.ps1',
  '.claude/sos/export/SOS-BUILDER.md',
  '.claude/sos/export/SOS-INSTALL.md',
  'vault/triage/_manifest.md',
  'vault/wiki/_manifest.md',
  'vault/archive/_manifest.md',
  'vault/outbox/_manifest.md'
];

const requiredDirs = [
  'vault/triage',
  'vault/wiki',
  'vault/archive',
  'vault/outbox',
  '.claude/sos',
  '.claude/sos/scripts',
  '.claude/sos/export',
  '.claude/sos/produce',
  '.claude/sos/produce/presentation',
  '.claude/commands/sos'
];

const rootContextFileCandidates = [
  'README.md',
  'PRD.md',
  'CONTEXT.md',
  'BRIEF.md',
  'REQUIREMENTS.md',
  'SPEC.md'
];

const gitignoreSosBlock = `\n# SolutionOS — private input lane (Git-ignored)\n# Material here is for ingestion into wiki summaries only.\n# Source files in /resources/ never enter vault as raw bytes.\n/resources/\n`;

const gitignoreResourcePatterns = [
  /^\s*\/?resources\/?\s*$/m,
  /^\s*\*\*\/resources\/?\s*$/m,
  /^\s*\/?resources\/\*+\s*$/m
];

const pmRequiredReferences = [
  '.claude/STONE.md',
  '.claude/ACTORS.md',
  '.claude/TOOLS.md',
  '.claude/WORKFLOW.md',
  '.claude/sos',
  '.claude/skills/sos',
  '.claude/commands/sos',
  'vault/triage',
  'vault/wiki',
  'vault/archive',
  'vault/outbox'
];

const adapterRequiredReferences = {
  'CLAUDE.md': ['.claude/PM.md'],
  'AGENTS.md': ['.claude/PM.md', '.claude/sos/COMMANDS.md']
};

const reservedVaultRegistryNames = new Set([
  'actor',
  'actors',
  'people',
  'person',
  'persons',
  'roster',
  'team',
  'teams',
  'stakeholder',
  'stakeholders',
  'stakeholder-register',
  'stakeholder-registry'
]);

const semanticCandidateStoplist = new Set([
  'ACTORS',
  'AGENTS',
  'API',
  'CLI',
  'CLAUDE',
  'COMMANDS',
  'Claude Code',
  'Codex',
  'Current SOS Version',
  'Git',
  'GitHub',
  'JSON',
  'KB',
  'MCP',
  'Node',
  'PM',
  'PowerShell',
  'README',
  'Read-only SOS',
  'SCHEMA',
  'SOS',
  'SOS CLI',
  'STONE',
  'SolutionOS',
  'TOOLS',
  'WORKFLOW',
  'YAML'
].map((term) => term.toLowerCase()));

const archiveManifestColumns = ['Path', 'Kind', 'Period', 'Status', 'Processed Into', 'Hash', 'Notes'];

const archiveCandidateNamePattern = /(^|[-_. ])(?:19\d{2}|20\d{2}|q[1-4]|emails?|correspondence|meetings?|minutes|archive|archived|history|historical|temp|tmp|old|legacy)([-_. ]|$)/i;

const archiveCandidateExcludedRoots = new Set([
  '.git',
  '.backlog',
  '.claude',
  'node_modules',
  'templates',
  'vault',
  'coverage',
  'dist',
  'build'
]);

main().catch((error) => {
  console.error(`sos: ${error.message}`);
  process.exit(1);
});

async function main() {
  const [command = 'help', ...argv] = process.argv.slice(2);
  const options = parseOptions(argv);

  switch (command) {
    case 'help':
    case '--help':
    case '-h':
      printHelp();
      return;
    case 'version':
    case '--version':
    case '-v':
      console.log(getPackageVersion());
      return;
    case 'install':
      await installCommand(options);
      return;
    case 'audit':
      auditCommand(options);
      return;
    case 'status':
    case 'summary':
      statusCommand(options);
      return;
    case 'migrate':
    case 'migrate-assess':
      migrateAssessCommand(options);
      return;
    default:
      throw new Error(`unknown command "${command}". Run "sos help".`);
  }
}

function parseOptions(argv) {
  const options = {
    target: process.cwd(),
    nodeKind: 'project',
    nodeName: '',
    force: false,
    dryRun: false,
    apply: false,
    json: false
  };

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];

    if (arg === '--target' || arg === '-t') {
      options.target = requireValue(argv, ++i, arg);
    } else if (arg === '--node-kind') {
      options.nodeKind = requireValue(argv, ++i, arg);
    } else if (arg === '--node-name') {
      options.nodeName = requireValue(argv, ++i, arg);
    } else if (arg === '--force') {
      options.force = true;
    } else if (arg === '--dry-run' || arg === '--preview') {
      options.dryRun = true;
    } else if (arg === '--yes' || arg === '--apply') {
      options.apply = true;
    } else if (arg === '--json') {
      options.json = true;
    } else {
      throw new Error(`unknown option "${arg}"`);
    }
  }

  if (!validNodeKinds.has(options.nodeKind)) {
    throw new Error(`invalid --node-kind "${options.nodeKind}"`);
  }

  if (options.dryRun && options.apply) {
    throw new Error('--dry-run/--preview cannot be combined with --yes/--apply');
  }

  options.target = path.resolve(options.target);
  if (!options.nodeName) {
    options.nodeName = path.basename(options.target) || 'SOS Node';
  }

  return options;
}

function requireValue(argv, index, flag) {
  const value = argv[index];
  if (!value || value.startsWith('-')) {
    throw new Error(`${flag} requires a value`);
  }
  return value;
}

function printHelp() {
  console.log(`SolutionOS CLI

Usage:
  sos install [--target .] [--node-kind project] [--dry-run] [--yes]
  sos audit [--target .] [--json]
  sos status [--target .] [--json]
  sos migrate [--target .] [--json]
  sos version

Recommended flow:
  cd <project>
  sos install
  sos audit

The SOS tool is installed globally. The project receives its own local SOS node files.`);
}

async function installCommand(options) {
  if (!fs.existsSync(templateRoot)) {
    throw new Error(`template root not found: ${templateRoot}`);
  }

  if (options.force) {
    throw new Error('sos install never overwrites existing files. --force is disabled; use a separate approved upgrade or repair flow for existing-file changes.');
  }

  const versionInfo = getVersionInfo(options.target);
  if (['project-newer-than-cli', 'metadata-unreadable', 'unknown', 'project-version-missing'].includes(versionInfo.ProjectVersionRelation)) {
    throw new Error(`refusing to install: project version state is "${versionInfo.ProjectVersionRelation}" (project: ${versionInfo.ProjectSosVersion || 'unknown'}, running CLI: ${versionInfo.RunningCliVersion}). Run sos audit/status and update the CLI if needed. No files were changed.`);
  }

  const created = [];
  const overwritten = [];
  const skipped = [];
  const planned = [];

  for (const sourcePath of listFiles(templateRoot)) {
    const relativePath = toPosix(path.relative(templateRoot, sourcePath));
    const destination = path.join(options.target, relativePath);

    if (fs.existsSync(destination)) {
      skipped.push(relativePath);
      continue;
    }

    planned.push(relativePath);
  }

  const proposalMode = options.dryRun ? 'preview' : options.apply ? 'apply' : 'proposal';
  const requiresApproval = !options.dryRun && !options.apply && planned.length > 0;

  const proposal = {
    Mode: proposalMode,
    TargetPath: options.target,
    TemplateRoot: templateRoot,
    ExistingSosInstalled: versionInfo.SosInstalled,
    ProjectSosVersion: versionInfo.ProjectSosVersion,
    RunningCliVersion: versionInfo.RunningCliVersion,
    ProjectVersionRelation: versionInfo.ProjectVersionRelation,
    ProjectAlreadyAtRunningVersion: versionInfo.ProjectVersionRelation === 'same',
    NodeName: options.nodeName,
    NodeKind: options.nodeKind,
    OverwritePolicy: 'never-overwrite-existing-files',
    ApprovalPolicy: 'prompt-or---yes-before-writing',
    RequiresApproval: requiresApproval,
    PlannedCreateCount: planned.length,
    CreatedCount: 0,
    OverwrittenCount: 0,
    SkippedExistingCount: skipped.length,
    MetadataUpdated: false
  };

  if (options.dryRun || requiresApproval || planned.length === 0) {
    printResult(proposal, options.json);
    printList('Would create', planned, options.json);
    printList('Skipped existing', skipped, options.json);
  }

  if (options.dryRun) {
    const gitignoreCheck = checkGitignoreState(options.target);
    const rootHints = scanRootContextFiles(options.target);
    if (!options.json) {
      if (gitignoreCheck.action === 'would-append') {
        console.log(`\nWould append /resources/ entry to existing .gitignore (it is missing). Re-run without --dry-run and approve.`);
      }
      printRootContextHints(rootHints, true);
      console.log('\nPreview only. Re-run without --dry-run and approve the prompt, or use --yes after reviewing the plan.');
    }
    return;
  }

  if (planned.length === 0) {
    const postInstall = await runPostInstallHooks(options);
    if (!options.json) {
      console.log('\nNo missing SOS baseline files detected. No files were changed.');
      printPostInstallSummary(postInstall);
    }
    return;
  }

  if (requiresApproval) {
    const approved = await getInstallApproval(planned.length, options);
    if (!approved) {
      if (!options.json) {
        console.log('\nNo files were changed. Re-run with --yes only after approving this missing-file install plan.');
      }
      return;
    }
  }

  fs.mkdirSync(options.target, { recursive: true });

  for (const relativePath of planned) {
    const sourcePath = path.join(templateRoot, ...relativePath.split('/'));
    const destination = path.join(options.target, ...relativePath.split('/'));
    fs.mkdirSync(path.dirname(destination), { recursive: true });
    fs.copyFileSync(sourcePath, destination);
    created.push(relativePath);
  }

  const sosJsonRelative = '.claude/sos/sos.json';
  const sosJsonPath = path.join(options.target, ...sosJsonRelative.split('/'));
  let metadataUpdated = false;

  if (fs.existsSync(sosJsonPath) && created.includes(sosJsonRelative)) {
    const metadata = JSON.parse(fs.readFileSync(sosJsonPath, 'utf8'));
    metadata.node = metadata.node || {};
    metadata.node.name = options.nodeName;
    metadata.node.kind = options.nodeKind;
    fs.writeFileSync(sosJsonPath, `${JSON.stringify(metadata, null, 2)}\n`, 'utf8');
    metadataUpdated = true;
  }

  const postInstall = await runPostInstallHooks(options);

  const result = {
    ...proposal,
    Mode: 'apply',
    RequiresApproval: false,
    CreatedCount: created.length,
    OverwrittenCount: overwritten.length,
    MetadataUpdated: metadataUpdated,
    GitignoreAction: postInstall.gitignore.action,
    GitignoreReason: postInstall.gitignore.reason,
    RootContextFilesDetected: postInstall.rootContextFiles
  };

  printResult(result, options.json);
  printList('Created', created, options.json);
  printList('Overwritten', overwritten, options.json);
  printList('Skipped existing', skipped, options.json);
  if (!options.json) {
    printPostInstallSummary(postInstall);
  }
}

async function runPostInstallHooks(options) {
  const gitignore = await ensureResourcesInGitignore(options);
  const rootContextFiles = scanRootContextFiles(options.target);
  return { gitignore, rootContextFiles };
}

function checkGitignoreState(targetPath) {
  const gitignorePath = path.join(targetPath, '.gitignore');
  if (!fs.existsSync(gitignorePath)) {
    return { action: 'absent', reason: 'no .gitignore at project root' };
  }
  const content = fs.readFileSync(gitignorePath, 'utf8');
  for (const pattern of gitignoreResourcePatterns) {
    if (pattern.test(content)) {
      return { action: 'already-present', reason: '/resources/ already ignored' };
    }
  }
  return { action: 'would-append', reason: '/resources/ entry missing from .gitignore' };
}

async function ensureResourcesInGitignore(options) {
  const state = checkGitignoreState(options.target);

  if (state.action !== 'would-append') {
    return state;
  }

  const gitignorePath = path.join(options.target, '.gitignore');

  if (!options.apply) {
    const approved = await getGitignoreApproval(options);
    if (!approved) {
      return { action: 'skipped', reason: 'append not approved' };
    }
  }

  let content = fs.readFileSync(gitignorePath, 'utf8');
  if (!content.endsWith('\n')) {
    content += '\n';
  }
  fs.writeFileSync(gitignorePath, content + gitignoreSosBlock, 'utf8');
  return { action: 'appended', reason: '/resources/ block appended to existing .gitignore' };
}

async function getGitignoreApproval(options) {
  if (options.json || !process.stdin.isTTY || !process.stdout.isTTY) {
    return false;
  }

  const rl = createInterface({
    input: process.stdin,
    output: process.stdout
  });

  try {
    const answer = await rl.question(`\nExisting .gitignore is missing the /resources/ entry needed for the SOS private input lane.\nAppend a labelled SOS section now (existing entries are preserved)? Choose (Y)ES or (N)O: `);
    return /^y(?:es)?$/i.test(answer.trim());
  } finally {
    rl.close();
  }
}

function scanRootContextFiles(targetPath) {
  const found = [];
  for (const name of rootContextFileCandidates) {
    const candidatePath = path.join(targetPath, name);
    if (fs.existsSync(candidatePath) && fs.statSync(candidatePath).isFile()) {
      found.push(name);
    }
  }
  return found;
}

function printPostInstallSummary(postInstall) {
  const { gitignore, rootContextFiles } = postInstall;

  if (gitignore.action === 'appended') {
    console.log(`\n.gitignore: appended /resources/ block to existing file (existing entries preserved).`);
  } else if (gitignore.action === 'skipped') {
    console.log(`\n.gitignore: append skipped — re-run with --yes after reviewing if you want /resources/ added.`);
  }

  printRootContextHints(rootContextFiles, false);
}

function printRootContextHints(found, prefixedWithWould) {
  if (!found || found.length === 0) {
    return;
  }
  console.log(`\nNoticed root-level context files. SOS does not claim or move them.`);
  for (const name of found) {
    if (name === 'README.md') {
      console.log(`  - ${name}: stays at root (public surface). Wiki may reference it via /sos:ingest.`);
    } else {
      const verb = prefixedWithWould ? 'You could run' : 'Run';
      console.log(`  - ${name}: ${verb} \`/sos:ingest ${name} as <intent>\` to archive + curate-into-wiki.`);
    }
  }
}

async function getInstallApproval(plannedCreateCount, options) {
  if (options.json || !process.stdin.isTTY || !process.stdout.isTTY) {
    return false;
  }

  const rl = createInterface({
    input: process.stdin,
    output: process.stdout
  });

  try {
    const answer = await rl.question(`\nCreate ${plannedCreateCount} missing SOS baseline file(s) now? Existing files will be skipped. Choose (Y)ES or (N)O: `);
    return /^y(?:es)?$/i.test(answer.trim());
  } finally {
    rl.close();
  }
}

function auditCommand(options) {
  const result = auditTarget(options.target);
  printResult(result.summary, options.json);
  printList('Version warnings', result.versionWarnings, options.json);
  printList('Missing files', result.missingFiles, options.json);
  printList('Missing directories', result.missingDirs, options.json);
  printList('Missing frontmatter', result.missingMetadata, options.json);
  printList('Missing PM references', result.missingPmReferences, options.json);
  printList('Missing adapter delegation', result.missingAdapterDelegation, options.json);
  printList('Unreachable SOS surface paths', result.unreachableSurfacePaths, options.json);
  printList('Missing ACTORS alias columns', result.missingActorsAliasColumns, options.json);
  printList('Reserved vault actor registries', result.reservedVaultRegistryPaths, options.json);
  printList('Unregistered actor/concept candidates', result.unregisteredSemanticCandidates, options.json);
  printList('Missing archive manifest columns', result.missingArchiveManifestColumns, options.json);
  printList('Unindexed archive items', result.unindexedArchiveItems, options.json);
  printList('Loose archive candidates', result.looseArchiveCandidates, options.json);

  if (result.summary.Status !== 'healthy') {
    process.exitCode = 1;
  }
}

function statusCommand(options) {
  const audit = auditTarget(options.target);
  const metadata = readJson(path.join(options.target, '.claude/sos/sos.json'));
  const result = {
    Status: audit.summary.Status,
    TargetPath: options.target,
    SosInstalled: fs.existsSync(path.join(options.target, '.claude/sos/sos.json')),
    RunningCliVersion: audit.summary.RunningCliVersion,
    SosVersion: metadata?.sos_version || '',
    TemplateVersion: metadata?.template_version || '',
    ProjectVersionRelation: audit.summary.ProjectVersionRelation,
    VersionWarningCount: audit.summary.VersionWarningCount,
    NodeName: metadata?.node?.name || '',
    NodeKind: metadata?.node?.kind || '',
    TriageItemCount: countNodeFiles(path.join(options.target, 'vault/triage')),
    WikiNoteCount: countNodeFiles(path.join(options.target, 'vault/wiki')),
    OutboxItemCount: countNodeFiles(path.join(options.target, 'vault/outbox')),
    MissingFileCount: audit.summary.MissingFileCount,
    MissingDirCount: audit.summary.MissingDirCount,
    MissingPmReferenceCount: audit.summary.MissingPmReferenceCount,
    MissingAdapterDelegationCount: audit.summary.MissingAdapterDelegationCount,
    UnreachableSurfacePathCount: audit.summary.UnreachableSurfacePathCount,
    MissingActorsAliasColumnCount: audit.summary.MissingActorsAliasColumnCount,
    ReservedVaultRegistryCount: audit.summary.ReservedVaultRegistryCount,
    UnregisteredSemanticCandidateCount: audit.summary.UnregisteredSemanticCandidateCount,
    MissingArchiveManifestColumnCount: audit.summary.MissingArchiveManifestColumnCount,
    UnindexedArchiveItemCount: audit.summary.UnindexedArchiveItemCount,
    LooseArchiveCandidateCount: audit.summary.LooseArchiveCandidateCount
  };

  printResult(result, options.json);
  if (result.Status !== 'healthy') {
    process.exitCode = 1;
  }
}

function migrateAssessCommand(options) {
  const candidates = [
    ['vault/inbox', 'legacy vault inbox; consider moving durable raw material to vault/triage'],
    ['kb', 'legacy knowledge base; consider mapping durable notes to vault/wiki'],
    ['knowledge-base', 'legacy knowledge base; consider mapping durable notes to vault/wiki'],
    ['.ai', 'legacy AI control folder; inspect for reusable context'],
    ['.claude/kb', 'legacy Claude KB; inspect before merging into vault/wiki'],
    ['.claude/seshmem', 'session memory; summarize durable facts before archiving']
  ];

  const detected = candidates
    .filter(([relativePath]) => fs.existsSync(path.join(options.target, relativePath)))
    .map(([relativePath, note]) => ({ Path: relativePath, Note: note }));

  printResult({
    Status: detected.length === 0 ? 'clear' : 'attention',
    TargetPath: options.target,
    DetectedCount: detected.length
  }, options.json);

  if (options.json) {
    console.log(JSON.stringify({ detected }, null, 2));
  } else if (detected.length > 0) {
    console.log('\nDetected migration candidates:');
    for (const item of detected) {
      console.log(`- ${item.Path}: ${item.Note}`);
    }
  }
}

function auditTarget(targetPath) {
  const target = path.resolve(targetPath);
  const missingFiles = requiredFiles.filter((relativePath) => !exists(target, relativePath));
  const missingDirs = requiredDirs.filter((relativePath) => !exists(target, relativePath));
  const versionInfo = getVersionInfo(target);
  const versionWarnings = getVersionWarnings(versionInfo);

  const pmContent = readText(path.join(target, '.claude/PM.md'));
  const missingPmReferences = pmRequiredReferences.filter((relativePath) => !contentReferences(pmContent, relativePath));

  const missingAdapterDelegation = [];
  const unreachableSurfacePaths = [];

  for (const [adapterPath, references] of Object.entries(adapterRequiredReferences)) {
    const content = readText(path.join(target, adapterPath));

    for (const reference of references) {
      if (!contentReferences(content, reference)) {
        missingAdapterDelegation.push(`${adapterPath} -> ${reference}`);
      }
    }

    if (!contentReferences(content, '.claude/PM.md')) {
      unreachableSurfacePaths.push(`${adapterPath} -> .claude/PM.md`);
    } else {
      for (const missingReference of missingPmReferences) {
        unreachableSurfacePaths.push(`${adapterPath} -> .claude/PM.md -> ${missingReference}`);
      }
    }
  }

  const metadataFiles = getMetadataFiles(target);
  const missingMetadata = metadataFiles
    .filter((filePath) => !hasFrontmatter(filePath))
    .map((filePath) => toPosix(path.relative(target, filePath)))
    .sort();

  const uniqueUnreachable = [...new Set(unreachableSurfacePaths)].sort();
  const missingActorsAliasColumns = getMissingActorsAliasColumns(target);
  const reservedVaultRegistryPaths = getReservedVaultRegistryPaths(target);
  const unregisteredSemanticCandidates = getUnregisteredSemanticCandidates(target);
  const missingArchiveManifestColumns = getMissingArchiveManifestColumns(target);
  const unindexedArchiveItems = getUnindexedArchiveItems(target);
  const looseArchiveCandidates = getLooseArchiveCandidates(target);
  const status = (
    missingFiles.length === 0 &&
    missingDirs.length === 0 &&
    missingMetadata.length === 0 &&
    missingPmReferences.length === 0 &&
    missingAdapterDelegation.length === 0 &&
    uniqueUnreachable.length === 0 &&
    missingActorsAliasColumns.length === 0 &&
    reservedVaultRegistryPaths.length === 0 &&
    missingArchiveManifestColumns.length === 0 &&
    unindexedArchiveItems.length === 0 &&
    versionWarnings.length === 0
  ) ? 'healthy' : 'attention';

  return {
    summary: {
      Status: status,
      TargetPath: target,
      RunningCliVersion: versionInfo.RunningCliVersion,
      ProjectSosVersion: versionInfo.ProjectSosVersion,
      ProjectTemplateVersion: versionInfo.ProjectTemplateVersion,
      ProjectVersionRelation: versionInfo.ProjectVersionRelation,
      VersionWarningCount: versionWarnings.length,
      MissingFileCount: missingFiles.length,
      MissingDirCount: missingDirs.length,
      MetadataFileCount: metadataFiles.length,
      MissingMetadataCount: missingMetadata.length,
      MissingPmReferenceCount: missingPmReferences.length,
      MissingAdapterDelegationCount: missingAdapterDelegation.length,
      UnreachableSurfacePathCount: uniqueUnreachable.length,
      MissingActorsAliasColumnCount: missingActorsAliasColumns.length,
      ReservedVaultRegistryCount: reservedVaultRegistryPaths.length,
      UnregisteredSemanticCandidateCount: unregisteredSemanticCandidates.length,
      MissingArchiveManifestColumnCount: missingArchiveManifestColumns.length,
      UnindexedArchiveItemCount: unindexedArchiveItems.length,
      LooseArchiveCandidateCount: looseArchiveCandidates.length
    },
    missingFiles,
    missingDirs,
    missingMetadata,
    missingPmReferences,
    missingAdapterDelegation,
    unreachableSurfacePaths: uniqueUnreachable,
    versionWarnings,
    missingActorsAliasColumns,
    reservedVaultRegistryPaths,
    unregisteredSemanticCandidates,
    missingArchiveManifestColumns,
    unindexedArchiveItems,
    looseArchiveCandidates
  };
}

function getVersionInfo(target) {
  const runningVersion = getPackageVersion();
  const metadataPath = path.join(target, '.claude/sos/sos.json');
  const metadata = readJson(metadataPath);
  const installed = fs.existsSync(metadataPath);
  const projectVersion = metadata?.sos_version || '';
  const templateVersion = metadata?.template_version || '';
  const comparison = projectVersion ? compareVersions(projectVersion, runningVersion) : null;

  let relation = 'not-installed';
  if (installed && !metadata) {
    relation = 'metadata-unreadable';
  } else if (projectVersion && comparison === null) {
    relation = 'unknown';
  } else if (comparison === 0) {
    relation = 'same';
  } else if (comparison > 0) {
    relation = 'project-newer-than-cli';
  } else if (comparison < 0) {
    relation = 'project-older-than-cli';
  } else if (installed) {
    relation = 'project-version-missing';
  }

  return {
    SosInstalled: installed,
    RunningCliVersion: runningVersion,
    ProjectSosVersion: projectVersion,
    ProjectTemplateVersion: templateVersion,
    ProjectVersionRelation: relation
  };
}

function getVersionWarnings(versionInfo) {
  if (versionInfo.ProjectVersionRelation === 'project-newer-than-cli') {
    return [`project SOS ${versionInfo.ProjectSosVersion} is newer than running sos CLI ${versionInfo.RunningCliVersion}; write commands must not run`];
  }

  if (versionInfo.ProjectVersionRelation === 'metadata-unreadable') {
    return ['project has .claude/sos/sos.json but it could not be read; write commands must not run'];
  }

  if (versionInfo.ProjectVersionRelation === 'unknown') {
    return [`project SOS version ${versionInfo.ProjectSosVersion} could not be compared with running sos CLI ${versionInfo.RunningCliVersion}`];
  }

  if (versionInfo.ProjectVersionRelation === 'project-version-missing') {
    return ['project has SOS metadata but no sos_version; run migration/status before write commands'];
  }

  return [];
}

function compareVersions(left, right) {
  const leftParts = parseVersion(left);
  const rightParts = parseVersion(right);
  if (!leftParts || !rightParts) {
    return null;
  }

  const length = Math.max(leftParts.length, rightParts.length);
  for (let index = 0; index < length; index += 1) {
    const leftPart = leftParts[index] || 0;
    const rightPart = rightParts[index] || 0;
    if (leftPart > rightPart) {
      return 1;
    }
    if (leftPart < rightPart) {
      return -1;
    }
  }

  return 0;
}

function parseVersion(value) {
  if (!value || !/^\d+(?:\.\d+){0,2}(?:[-+].*)?$/.test(value)) {
    return null;
  }

  return value
    .split(/[+-]/, 1)[0]
    .split('.')
    .map((part) => Number.parseInt(part, 10));
}

function getMissingActorsAliasColumns(target) {
  const actorsPath = path.join(target, '.claude/ACTORS.md');
  const content = readText(actorsPath);
  if (!content.trim()) {
    return [];
  }

  const findings = [];
  const lines = content.split(/\r?\n/);
  for (const line of lines) {
    if (!line.trim().startsWith('|')) {
      continue;
    }

    const cells = parseTableCells(line);
    if (cells.length < 2) {
      continue;
    }

    const first = cells[0].toLowerCase();
    const hasActorHeader = first === 'name' || first === 'role';
    const hasAliases = cells.some((cell) => cell.toLowerCase() === 'aliases');
    const isSeparator = cells.every((cell) => /^:?-{3,}:?$/.test(cell));
    if (hasActorHeader && !hasAliases && !isSeparator) {
      findings.push(`.claude/ACTORS.md table "${cells.join(' | ')}" lacks Aliases column`);
    }
  }

  return findings.sort();
}

function getReservedVaultRegistryPaths(target) {
  const vaultPath = path.join(target, 'vault');
  if (!fs.existsSync(vaultPath)) {
    return [];
  }

  return listFiles(vaultPath)
    .filter((filePath) => filePath.toLowerCase().endsWith('.md'))
    .map((filePath) => toPosix(path.relative(target, filePath)))
    .filter((relativePath) => {
      const name = path.basename(relativePath, path.extname(relativePath)).toLowerCase();
      return reservedVaultRegistryNames.has(name);
    })
    .sort();
}

function getUnregisteredSemanticCandidates(target) {
  const registeredTerms = getRegisteredActorTerms(target);
  const files = getSemanticScanFiles(target);
  const counts = new Map();

  for (const filePath of files) {
    const content = stripFrontmatter(readText(filePath));
    const matches = content.matchAll(/\b(?:[A-Z][A-Za-z0-9&'.-]{2,}|[A-Z]{2,})(?:[ \t]+(?:[A-Z][A-Za-z0-9&'.-]{2,}|[A-Z]{2,})){0,3}\b/g);
    for (const match of matches) {
      const term = normalizeSemanticCandidate(match[0]);
      if (!term) {
        continue;
      }

      const key = term.toLowerCase();
      if (semanticCandidateStoplist.has(key) || registeredTerms.has(key)) {
        continue;
      }

      const current = counts.get(key) || { term, count: 0 };
      current.count += 1;
      counts.set(key, current);
    }
  }

  return [...counts.values()]
    .filter((item) => item.count >= 2)
    .sort((a, b) => b.count - a.count || a.term.localeCompare(b.term))
    .slice(0, 25)
    .map((item) => `${item.term} (${item.count})`);
}

function getMissingArchiveManifestColumns(target) {
  const manifestPath = path.join(target, 'vault/archive/_manifest.md');
  if (!fs.existsSync(manifestPath)) {
    return [];
  }

  const content = readText(manifestPath);
  const header = getFirstTableHeader(content);
  if (header.length === 0) {
    return archiveManifestColumns.map((column) => `vault/archive/_manifest.md -> ${column}`);
  }

  const normalizedHeader = new Set(header.map((cell) => cell.toLowerCase()));
  return archiveManifestColumns
    .filter((column) => !normalizedHeader.has(column.toLowerCase()))
    .map((column) => `vault/archive/_manifest.md -> ${column}`)
    .sort();
}

function getUnindexedArchiveItems(target) {
  const archivePath = path.join(target, 'vault/archive');
  const manifestPath = path.join(target, 'vault/archive/_manifest.md');
  if (!fs.existsSync(archivePath) || !fs.existsSync(manifestPath)) {
    return [];
  }

  const manifestContent = readText(manifestPath);
  const controlNames = new Set(['README.md', '_manifest.md']);

  return fs.readdirSync(archivePath, { withFileTypes: true })
    .filter((entry) => (entry.isFile() || entry.isDirectory()) && !controlNames.has(entry.name))
    .map((entry) => {
      const itemPath = path.join(archivePath, entry.name);
      const relativePath = toPosix(path.relative(target, itemPath));
      return entry.isDirectory() ? `${relativePath}/` : relativePath;
    })
    .filter((relativePath) => !isArchiveManifestReferenced(manifestContent, relativePath))
    .sort();
}

function getLooseArchiveCandidates(target) {
  if (!fs.existsSync(target)) {
    return [];
  }

  const findings = [];

  function walk(currentPath) {
    const relativePath = toPosix(path.relative(target, currentPath));
    if (relativePath && shouldSkipArchiveCandidatePath(relativePath)) {
      return;
    }

    for (const entry of fs.readdirSync(currentPath, { withFileTypes: true })) {
      const fullPath = path.join(currentPath, entry.name);
      const entryRelativePath = toPosix(path.relative(target, fullPath));
      if (shouldSkipArchiveCandidatePath(entryRelativePath)) {
        continue;
      }

      if (entry.isDirectory()) {
        if (isLooseArchiveCandidateName(entry.name)) {
          findings.push(`${entryRelativePath}/`);
          continue;
        }
        walk(fullPath);
      } else if (entry.isFile() && isLooseArchiveCandidateName(entry.name)) {
        findings.push(entryRelativePath);
      }

      if (findings.length >= 25) {
        return;
      }
    }
  }

  walk(target);
  return [...new Set(findings)].sort().slice(0, 25);
}

function getFirstTableHeader(content) {
  for (const line of content.split(/\r?\n/)) {
    if (!line.trim().startsWith('|')) {
      continue;
    }

    const cells = parseTableCells(line);
    const isSeparator = cells.length > 0 && cells.every((cell) => /^:?-{3,}:?$/.test(cell));
    if (!isSeparator) {
      return cells;
    }
  }

  return [];
}

function isArchiveManifestReferenced(content, relativePath) {
  const normalizedPath = relativePath.replace(/\/$/, '');
  const name = path.basename(normalizedPath);
  return (
    contentReferences(content, normalizedPath) ||
    contentReferences(content, `${normalizedPath}/`) ||
    contentReferences(content, name)
  );
}

function shouldSkipArchiveCandidatePath(relativePath) {
  if (!relativePath) {
    return false;
  }

  const parts = relativePath.split('/');
  return archiveCandidateExcludedRoots.has(parts[0]);
}

function isLooseArchiveCandidateName(name) {
  const lower = name.toLowerCase();
  if (lower === 'readme.md' || lower === '_manifest.md') {
    return false;
  }

  return archiveCandidateNamePattern.test(lower);
}

function getRegisteredActorTerms(target) {
  const actorsPath = path.join(target, '.claude/ACTORS.md');
  const content = readText(actorsPath);
  const terms = new Set();

  for (const line of content.split(/\r?\n/)) {
    if (!line.trim().startsWith('|')) {
      continue;
    }

    const cells = parseTableCells(line);
    if (cells.length < 2) {
      continue;
    }

    const first = cells[0].toLowerCase();
    if (first === 'name' || first === 'role' || first.startsWith('-') || first === '') {
      continue;
    }

    for (const cell of cells.slice(0, 2)) {
      for (const term of splitAliasCell(cell)) {
        terms.add(term.toLowerCase());
      }
    }
  }

  return terms;
}

function getSemanticScanFiles(target) {
  const files = [];
  for (const relativeDir of ['vault/wiki', '.claude']) {
    const dirPath = path.join(target, relativeDir);
    if (!fs.existsSync(dirPath)) {
      continue;
    }

    files.push(...listFiles(dirPath).filter((filePath) => {
      const relativePath = toPosix(path.relative(target, filePath));
      return (
        filePath.endsWith('.md') &&
        !relativePath.startsWith('.claude/sos/') &&
        !relativePath.startsWith('.claude/commands/') &&
        relativePath !== '.claude/ACTORS.md'
      );
    }));
  }

  return files;
}

function parseTableCells(line) {
  return line
    .trim()
    .replace(/^\|/, '')
    .replace(/\|$/, '')
    .split('|')
    .map((cell) => cell.trim());
}

function splitAliasCell(cell) {
  return cell
    .split(/[,;]|\s+\|\s+/)
    .map((term) => normalizeSemanticCandidate(term))
    .filter(Boolean);
}

function normalizeSemanticCandidate(term) {
  const normalized = term
    .replace(/[`*_#[\]()]/g, '')
    .replace(/\s+/g, ' ')
    .trim()
    .replace(/[.,:;!?]+$/, '');

  if (!normalized || normalized.includes('.')) {
    return '';
  }

  const words = normalized.split(' ');
  const isAcronym = /^[A-Z0-9&-]{3,}$/.test(normalized);
  if (words.length < 2 && !isAcronym) {
    return '';
  }

  return normalized;
}

function stripFrontmatter(content) {
  return content
    .replace(/^\uFEFF?---[\s\S]*?---/, '')
    .replace(/```[\s\S]*?```/g, '')
    .replace(/`[^`]*`/g, '');
}

function getMetadataFiles(target) {
  const files = [];
  const direct = [
    'AGENTS.md',
    'CLAUDE.md',
    '.claude/PM.md',
    '.claude/STONE.md',
    '.claude/ACTORS.md',
    '.claude/TOOLS.md',
    '.claude/WORKFLOW.md',
    '.claude/skills/sos/SKILL.md',
    'vault/triage/README.md',
    'vault/triage/_manifest.md',
    'vault/wiki/_manifest.md',
    'vault/archive/README.md',
    'vault/archive/_manifest.md',
    'vault/outbox/README.md',
    'vault/outbox/_manifest.md'
  ];

  for (const relativePath of direct) {
    const filePath = path.join(target, relativePath);
    if (fs.existsSync(filePath)) {
      files.push(filePath);
    }
  }

  for (const relativeDir of ['docs/design', 'vault/wiki', 'templates/core', '.claude/sos', '.claude/commands/sos']) {
    const dirPath = path.join(target, relativeDir);
    if (fs.existsSync(dirPath)) {
      files.push(...listFiles(dirPath).filter((filePath) => filePath.endsWith('.md')));
    }
  }

  return [...new Set(files)].sort();
}

function listFiles(root) {
  if (!fs.existsSync(root)) {
    return [];
  }

  const entries = fs.readdirSync(root, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    const fullPath = path.join(root, entry.name);
    if (entry.isDirectory()) {
      files.push(...listFiles(fullPath));
    } else if (entry.isFile()) {
      files.push(fullPath);
    }
  }

  return files;
}

function exists(root, relativePath) {
  return fs.existsSync(path.join(root, relativePath));
}

function readText(filePath) {
  if (!fs.existsSync(filePath)) {
    return '';
  }
  return fs.readFileSync(filePath, 'utf8');
}

function readJson(filePath) {
  if (!fs.existsSync(filePath)) {
    return null;
  }
  try {
    return JSON.parse(readText(filePath).replace(/^\uFEFF/, ''));
  } catch {
    return null;
  }
}

function contentReferences(content, relativePath) {
  if (!content.trim()) {
    return false;
  }

  const variants = new Set([
    relativePath,
    relativePath.replaceAll('/', '\\'),
    relativePath.replaceAll('\\', '/')
  ]);

  const lower = content.toLowerCase();
  for (const variant of variants) {
    if (lower.includes(variant.toLowerCase())) {
      return true;
    }
  }
  return false;
}

function hasFrontmatter(filePath) {
  const content = readText(filePath).replace(/^\uFEFF/, '');
  return content.split(/\r?\n/, 1)[0] === '---';
}

function countNodeFiles(dirPath) {
  if (!fs.existsSync(dirPath)) {
    return 0;
  }

  return fs.readdirSync(dirPath, { withFileTypes: true })
    .filter((entry) => entry.isFile() && entry.name !== 'README.md' && entry.name !== '_manifest.md')
    .length;
}

function printResult(result, json) {
  if (json) {
    console.log(JSON.stringify(result, null, 2));
    return;
  }

  for (const [key, value] of Object.entries(result)) {
    console.log(`${key}: ${value}`);
  }
}

function printList(title, items, json) {
  if (json || items.length === 0) {
    return;
  }

  console.log(`\n${title}:`);
  for (const item of [...items].sort()) {
    console.log(`- ${item}`);
  }
}

function getPackageVersion() {
  const packageJson = readJson(path.join(repoRoot, 'package.json'));
  return packageJson?.version || '0.0.0';
}

function toPosix(value) {
  return value.split(path.sep).join('/');
}
