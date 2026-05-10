#!/usr/bin/env node

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const blockedTerms = [
  String.fromCharCode(65, 68, 72, 68)
];

const skippedDirs = new Set([
  '.git',
  'node_modules',
  'coverage',
  'dist',
  'build',
  '.cache',
  '.next',
  '.nuxt'
]);

const skippedExtensions = new Set([
  '.png',
  '.jpg',
  '.jpeg',
  '.gif',
  '.webp',
  '.ico',
  '.pdf',
  '.zip',
  '.gz',
  '.7z',
  '.exe',
  '.dll'
]);

const findings = [];

walk(repoRoot);

if (findings.length > 0) {
  console.error('Public language check failed: blocked public wording was found.');
  for (const finding of findings) {
    console.error(`- ${finding}`);
  }
  process.exit(1);
}

function walk(currentPath) {
  for (const entry of fs.readdirSync(currentPath, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (skippedDirs.has(entry.name)) {
        continue;
      }
      walk(path.join(currentPath, entry.name));
      continue;
    }

    if (!entry.isFile()) {
      continue;
    }

    const filePath = path.join(currentPath, entry.name);
    if (skippedExtensions.has(path.extname(entry.name).toLowerCase())) {
      continue;
    }

    let content = '';
    try {
      content = fs.readFileSync(filePath, 'utf8');
    } catch {
      continue;
    }

    const lines = content.split(/\r?\n/);
    for (let index = 0; index < lines.length; index += 1) {
      for (const term of blockedTerms) {
        if (lines[index].toLowerCase().includes(term.toLowerCase())) {
          findings.push(`${path.relative(repoRoot, filePath)}:${index + 1}`);
        }
      }
    }
  }
}
