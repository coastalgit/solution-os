[CmdletBinding()]
param(
    [string]$TargetPath = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$targetFullPath = [System.IO.Path]::GetFullPath($TargetPath)

if (!(Test-Path -LiteralPath $targetFullPath)) {
    throw "Target path not found: $targetFullPath"
}

function Test-RelativePath {
    param([string]$RelativePath)
    Test-Path -LiteralPath (Join-Path $targetFullPath $RelativePath)
}

function Get-RelativePath {
    param([string]$FullName)
    $FullName.Substring($targetFullPath.Length).TrimStart('\', '/')
}

function Test-Frontmatter {
    param([string]$Path)

    $firstLine = Get-Content -LiteralPath $Path -TotalCount 1 -ErrorAction Stop
    return $firstLine -eq '---'
}

$requiredFiles = @(
    'CLAUDE.md',
    'AGENTS.md',
    '.claude\PM.md',
    '.claude\STONE.md',
    '.claude\ACTORS.md',
    '.claude\TOOLS.md',
    '.claude\WORKFLOW.md',
    '.claude\skills\sos\SKILL.md',
    '.claude\sos\sos.json',
    '.claude\sos\VERSION.md',
    '.claude\sos\COMMANDS.md',
    '.claude\sos\SCHEMA.md',
    '.claude\sos\TOOLKITS.md',
    '.claude\sos\export\SOS-BUILDER.md',
    '.claude\sos\export\SOS-INSTALL.md',
    'vault\triage\_manifest.md',
    'vault\wiki\_manifest.md',
    'vault\archive\_manifest.md',
    'vault\outbox\_manifest.md'
)

$requiredDirs = @(
    'vault\triage',
    'vault\wiki',
    'vault\archive',
    'vault\outbox',
    '.claude\sos',
    '.claude\sos\export'
)

$missingFiles = @($requiredFiles | Where-Object { !(Test-RelativePath $_) })
$missingDirs = @($requiredDirs | Where-Object { !(Test-RelativePath $_) })

$metadataFiles = New-Object System.Collections.Generic.List[string]

foreach ($relativePath in @('AGENTS.md', 'CLAUDE.md')) {
    $path = Join-Path $targetFullPath $relativePath
    if (Test-Path -LiteralPath $path) {
        $metadataFiles.Add($path)
    }
}

foreach ($relativeDir in @('docs\design', 'vault\wiki', 'templates\core')) {
    $dir = Join-Path $targetFullPath $relativeDir
    if (Test-Path -LiteralPath $dir) {
        Get-ChildItem -LiteralPath $dir -Recurse -Force -File -Filter '*.md' |
            ForEach-Object { $metadataFiles.Add($_.FullName) }
    }
}

foreach ($relativePath in @(
    '.claude\PM.md',
    '.claude\STONE.md',
    '.claude\ACTORS.md',
    '.claude\TOOLS.md',
    '.claude\WORKFLOW.md',
    '.claude\skills\sos\SKILL.md'
)) {
    $path = Join-Path $targetFullPath $relativePath
    if (Test-Path -LiteralPath $path) {
        $metadataFiles.Add($path)
    }
}

$sosDir = Join-Path $targetFullPath '.claude\sos'
if (Test-Path -LiteralPath $sosDir) {
    Get-ChildItem -LiteralPath $sosDir -Recurse -Force -File -Filter '*.md' |
        ForEach-Object { $metadataFiles.Add($_.FullName) }
}

foreach ($relativePath in @(
    'vault\triage\README.md',
    'vault\triage\_manifest.md',
    'vault\wiki\_manifest.md',
    'vault\archive\README.md',
    'vault\archive\_manifest.md',
    'vault\outbox\README.md',
    'vault\outbox\_manifest.md'
)) {
    $path = Join-Path $targetFullPath $relativePath
    if (Test-Path -LiteralPath $path) {
        $metadataFiles.Add($path)
    }
}

$uniqueMetadataFiles = @($metadataFiles | Sort-Object -Unique)
$missingMetadata = @(
    $uniqueMetadataFiles |
        Where-Object { !(Test-Frontmatter $_) } |
        ForEach-Object { Get-RelativePath $_ }
)

$status = if ($missingFiles.Count -eq 0 -and $missingDirs.Count -eq 0 -and $missingMetadata.Count -eq 0) {
    'healthy'
}
else {
    'attention'
}

[pscustomobject]@{
    Status = $status
    TargetPath = $targetFullPath
    MissingFileCount = $missingFiles.Count
    MissingDirCount = $missingDirs.Count
    MetadataFileCount = $uniqueMetadataFiles.Count
    MissingMetadataCount = $missingMetadata.Count
}

if ($missingFiles.Count -gt 0) {
    "`nMissing files:"
    $missingFiles | Sort-Object
}

if ($missingDirs.Count -gt 0) {
    "`nMissing directories:"
    $missingDirs | Sort-Object
}

if ($missingMetadata.Count -gt 0) {
    "`nMissing frontmatter:"
    $missingMetadata | Sort-Object
}
