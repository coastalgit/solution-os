#!/usr/bin/env node

import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
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
  '.claude/commands/sos/context-export.md',
  '.claude/commands/sos/context-import.md',
  '.claude/commands/sos/session-close.md',
  '.claude/sos/sos.json',
  '.claude/sos/VERSION.md',
  '.claude/sos/COMMANDS.md',
  '.claude/sos/SCHEMA.md',
  '.claude/sos/TOOLKITS.md',
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
  '.claude/commands/sos'
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
      installCommand(options);
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
    } else if (arg === '--json') {
      options.json = true;
    } else {
      throw new Error(`unknown option "${arg}"`);
    }
  }

  if (!validNodeKinds.has(options.nodeKind)) {
    throw new Error(`invalid --node-kind "${options.nodeKind}"`);
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
  sos install [--target .] [--node-kind project] [--dry-run] [--force]
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

function installCommand(options) {
  if (!fs.existsSync(templateRoot)) {
    throw new Error(`template root not found: ${templateRoot}`);
  }

  if (!options.dryRun) {
    fs.mkdirSync(options.target, { recursive: true });
  }

  const created = [];
  const overwritten = [];
  const skipped = [];
  const planned = [];

  for (const sourcePath of listFiles(templateRoot)) {
    const relativePath = toPosix(path.relative(templateRoot, sourcePath));
    const destination = path.join(options.target, relativePath);

    if (fs.existsSync(destination)) {
      if (options.force) {
        if (!options.dryRun) {
          fs.mkdirSync(path.dirname(destination), { recursive: true });
          fs.copyFileSync(sourcePath, destination);
        }
        overwritten.push(relativePath);
      } else {
        skipped.push(relativePath);
      }
      continue;
    }

    if (options.dryRun) {
      planned.push(relativePath);
    } else {
      fs.mkdirSync(path.dirname(destination), { recursive: true });
      fs.copyFileSync(sourcePath, destination);
      created.push(relativePath);
    }
  }

  const sosJsonRelative = '.claude/sos/sos.json';
  const sosJsonPath = path.join(options.target, sosJsonRelative);
  let metadataUpdated = false;

  if (!options.dryRun && fs.existsSync(sosJsonPath) && (created.includes(sosJsonRelative) || options.force)) {
    const metadata = JSON.parse(fs.readFileSync(sosJsonPath, 'utf8'));
    metadata.node = metadata.node || {};
    metadata.node.name = options.nodeName;
    metadata.node.kind = options.nodeKind;
    fs.writeFileSync(sosJsonPath, `${JSON.stringify(metadata, null, 2)}\n`, 'utf8');
    metadataUpdated = true;
  }

  const result = {
    Mode: options.dryRun ? 'preview' : 'apply',
    TargetPath: options.target,
    TemplateRoot: templateRoot,
    NodeName: options.nodeName,
    NodeKind: options.nodeKind,
    Force: options.force,
    PlannedCreateCount: planned.length,
    CreatedCount: created.length,
    OverwrittenCount: overwritten.length,
    SkippedExistingCount: skipped.length,
    MetadataUpdated: metadataUpdated
  };

  printResult(result, options.json);
  printList('Would create', planned, options.json);
  printList('Created', created, options.json);
  printList('Overwritten', overwritten, options.json);
  printList('Skipped existing', skipped, options.json);

  if (options.dryRun && !options.json) {
    console.log('\nPreview only. Re-run without --dry-run to write files.');
  }
}

function auditCommand(options) {
  const result = auditTarget(options.target);
  printResult(result.summary, options.json);
  printList('Missing files', result.missingFiles, options.json);
  printList('Missing directories', result.missingDirs, options.json);
  printList('Missing frontmatter', result.missingMetadata, options.json);
  printList('Missing PM references', result.missingPmReferences, options.json);
  printList('Missing adapter delegation', result.missingAdapterDelegation, options.json);
  printList('Unreachable SOS surface paths', result.unreachableSurfacePaths, options.json);

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
    SosVersion: metadata?.sos_version || '',
    TemplateVersion: metadata?.template_version || '',
    NodeName: metadata?.node?.name || '',
    NodeKind: metadata?.node?.kind || '',
    TriageItemCount: countNodeFiles(path.join(options.target, 'vault/triage')),
    WikiNoteCount: countNodeFiles(path.join(options.target, 'vault/wiki')),
    OutboxItemCount: countNodeFiles(path.join(options.target, 'vault/outbox')),
    MissingFileCount: audit.summary.MissingFileCount,
    MissingDirCount: audit.summary.MissingDirCount,
    MissingPmReferenceCount: audit.summary.MissingPmReferenceCount,
    MissingAdapterDelegationCount: audit.summary.MissingAdapterDelegationCount,
    UnreachableSurfacePathCount: audit.summary.UnreachableSurfacePathCount
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
  const status = (
    missingFiles.length === 0 &&
    missingDirs.length === 0 &&
    missingMetadata.length === 0 &&
    missingPmReferences.length === 0 &&
    missingAdapterDelegation.length === 0 &&
    uniqueUnreachable.length === 0
  ) ? 'healthy' : 'attention';

  return {
    summary: {
      Status: status,
      TargetPath: target,
      MissingFileCount: missingFiles.length,
      MissingDirCount: missingDirs.length,
      MetadataFileCount: metadataFiles.length,
      MissingMetadataCount: missingMetadata.length,
      MissingPmReferenceCount: missingPmReferences.length,
      MissingAdapterDelegationCount: missingAdapterDelegation.length,
      UnreachableSurfacePathCount: uniqueUnreachable.length
    },
    missingFiles,
    missingDirs,
    missingMetadata,
    missingPmReferences,
    missingAdapterDelegation,
    unreachableSurfacePaths: uniqueUnreachable
  };
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
    return JSON.parse(readText(filePath));
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
  const content = readText(filePath);
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
