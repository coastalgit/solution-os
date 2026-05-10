import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const cliPath = path.join(repoRoot, 'bin', 'sos.js');

function makeFixture() {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'sos-cli-test-'));
  return {
    root,
    project: path.join(root, 'project'),
    sosHome: path.join(root, '.sos-home'),
    sosUserHome: path.join(root, '.sos-user')
  };
}

function runSos(args, fixture, options = {}) {
  const result = spawnSync(process.execPath, [cliPath, ...args], {
    cwd: options.cwd || repoRoot,
    env: {
      ...process.env,
      SOS_HOME: fixture.sosHome,
      SOS_USER_HOME: fixture.sosUserHome
    },
    encoding: 'utf8'
  });

  if (options.allowFailure !== true && result.status !== 0) {
    assert.fail(`sos ${args.join(' ')} failed\nstdout:\n${result.stdout}\nstderr:\n${result.stderr}`);
  }

  return result;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

test('fresh install creates project core and fake user home', () => {
  const fixture = makeFixture();
  try {
    runSos(['install', '--target', fixture.project, '--yes'], fixture);

    assert.ok(fs.existsSync(path.join(fixture.project, '.sos', 'sos.json')));
    assert.ok(fs.existsSync(path.join(fixture.project, '.sos', 'context', 'PM.md')));
    assert.ok(fs.existsSync(path.join(fixture.project, '.sos', 'templates', 'adr.md')));
    assert.ok(fs.existsSync(path.join(fixture.project, 'vault', 'wiki', 'agentic-sdlc-loop.md')));
    assert.ok(fs.existsSync(path.join(fixture.project, 'vault', 'wiki', 'decisions', '_manifest.md')));
    assert.ok(fs.existsSync(path.join(fixture.project, '.claude', 'PM.md')));
    assert.ok(fs.existsSync(path.join(fixture.project, 'AGENTS.md')));
    assert.ok(fs.existsSync(path.join(fixture.project, 'CLAUDE.md')));
    assert.ok(fs.existsSync(path.join(fixture.project, '.sos', 'sos-change.log')));
    assert.ok(fs.existsSync(path.join(fixture.sosUserHome, 'sos-user.json')));

    const status = runSos(['status', '--target', fixture.project, '--json'], fixture);
    const parsed = JSON.parse(status.stdout);
    assert.equal(parsed.SosUserHome, fixture.sosUserHome);
    assert.equal(parsed.SosHome, fixture.sosHome);
    assert.equal(parsed.Status, 'healthy');
  } finally {
    fs.rmSync(fixture.root, { recursive: true, force: true });
  }
});

test('install preserves existing adapter content and appends shim blocks', () => {
  const fixture = makeFixture();
  try {
    fs.mkdirSync(path.join(fixture.project, '.claude'), { recursive: true });
    fs.writeFileSync(path.join(fixture.project, 'AGENTS.md'), '# Existing Agents\n\nKeep this Codex note.\n', 'utf8');
    fs.writeFileSync(path.join(fixture.project, 'CLAUDE.md'), '# Existing Claude\n\nKeep this Claude note.\n', 'utf8');
    fs.writeFileSync(path.join(fixture.project, '.claude', 'PM.md'), '# Existing PM\n\nKeep this routing note.\n', 'utf8');

    runSos(['install', '--target', fixture.project, '--yes'], fixture);

    const agents = fs.readFileSync(path.join(fixture.project, 'AGENTS.md'), 'utf8');
    const claude = fs.readFileSync(path.join(fixture.project, 'CLAUDE.md'), 'utf8');
    const pm = fs.readFileSync(path.join(fixture.project, '.claude', 'PM.md'), 'utf8');

    assert.match(agents, /Keep this Codex note/);
    assert.match(claude, /Keep this Claude note/);
    assert.match(pm, /Keep this routing note/);
    assert.match(agents, /SOS:BEGIN adapter-shim/);
    assert.match(claude, /SOS:BEGIN adapter-shim/);
    assert.match(pm, /SOS:BEGIN adapter-shim/);
  } finally {
    fs.rmSync(fixture.root, { recursive: true, force: true });
  }
});

test('legacy claude sos metadata is detected before current core exists', () => {
  const fixture = makeFixture();
  try {
    fs.mkdirSync(path.join(fixture.project, '.claude', 'sos'), { recursive: true });
    fs.writeFileSync(path.join(fixture.project, '.claude', 'sos', 'sos.json'), `${JSON.stringify({
      sos_version: '0.1.19',
      template_version: '0.1.19',
      node: { name: 'legacy-node', kind: 'project' }
    }, null, 2)}\n`, 'utf8');

    const status = runSos(['status', '--target', fixture.project, '--json'], fixture, { allowFailure: true });
    const parsed = JSON.parse(status.stdout);

    assert.equal(parsed.LegacyClaudeSosInstalled, true);
    assert.equal(parsed.SosVersion, '0.1.19');
    assert.equal(parsed.NodeName, 'legacy-node');
  } finally {
    fs.rmSync(fixture.root, { recursive: true, force: true });
  }
});

test('task adapter detection does not initialize Backlog.md', () => {
  const fixture = makeFixture();
  try {
    fs.mkdirSync(path.join(fixture.project, '.superpowers'), { recursive: true });
    runSos(['install', '--target', fixture.project, '--yes'], fixture);

    const status = runSos(['status', '--target', fixture.project, '--json'], fixture);
    const parsed = JSON.parse(status.stdout);

    assert.equal(parsed.TaskAdapterDetectionCount, 1);
    assert.equal(fs.existsSync(path.join(fixture.project, '.backlog')), false);
    assert.equal(fs.existsSync(path.join(fixture.project, 'Backlog.md')), false);
  } finally {
    fs.rmSync(fixture.root, { recursive: true, force: true });
  }
});

test('skills-list includes fake global user skills', () => {
  const fixture = makeFixture();
  try {
    const skillDir = path.join(fixture.sosUserHome, 'skills', 'global-demo');
    fs.mkdirSync(skillDir, { recursive: true });
    fs.writeFileSync(path.join(skillDir, 'SKILL.md'), '# Global Demo\n', 'utf8');

    runSos(['install', '--target', fixture.project, '--yes'], fixture);
    const result = runSos(['skills-list', '--target', fixture.project, '--json'], fixture);
    const parsed = JSON.parse(result.stdout);
    const skill = parsed.Skills.find((item) => item.Name === 'global-demo');

    assert.ok(skill);
    assert.equal(skill.Scope, 'global-user');
    assert.equal(skill.Installed, false);
  } finally {
    fs.rmSync(fixture.root, { recursive: true, force: true });
  }
});
