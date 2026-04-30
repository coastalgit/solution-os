[CmdletBinding()]
param(
    [string]$TargetPath = (Get-Location).Path,

    [ValidateSet('solution', 'project', 'module', 'workshop', 'research', 'learning', 'other')]
    [string]$NodeKind = 'project',

    [string]$NodeName = '',

    [switch]$Apply,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $scriptRoot '..'))
$templateRoot = [System.IO.Path]::GetFullPath((Join-Path $repoRoot 'templates\core'))

if (!(Test-Path -LiteralPath $templateRoot)) {
    throw "Template root not found: $templateRoot"
}

$targetFullPath = [System.IO.Path]::GetFullPath($TargetPath)

if ([string]::IsNullOrWhiteSpace($NodeName)) {
    $NodeName = Split-Path -Leaf $targetFullPath
    if ([string]::IsNullOrWhiteSpace($NodeName)) {
        $NodeName = 'SOS Node'
    }
}

$created = New-Object System.Collections.Generic.List[string]
$overwritten = New-Object System.Collections.Generic.List[string]
$skipped = New-Object System.Collections.Generic.List[string]
$planned = New-Object System.Collections.Generic.List[string]

if ($Apply -and !(Test-Path -LiteralPath $targetFullPath)) {
    New-Item -ItemType Directory -Path $targetFullPath -Force | Out-Null
}

$templateFiles = Get-ChildItem -LiteralPath $templateRoot -Recurse -Force -File

foreach ($source in $templateFiles) {
    $relativePath = $source.FullName.Substring($templateRoot.Length).TrimStart('\', '/')
    $destination = Join-Path $targetFullPath $relativePath
    $destinationDirectory = Split-Path -Parent $destination

    if (Test-Path -LiteralPath $destination) {
        if ($Force) {
            if ($Apply) {
                Copy-Item -LiteralPath $source.FullName -Destination $destination -Force
            }
            $overwritten.Add($relativePath)
        }
        else {
            $skipped.Add($relativePath)
        }
        continue
    }

    if ($Apply) {
        if (!(Test-Path -LiteralPath $destinationDirectory)) {
            New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
        }
        Copy-Item -LiteralPath $source.FullName -Destination $destination
        $created.Add($relativePath)
    }
    else {
        $planned.Add($relativePath)
    }
}

$sosJsonRelative = '.claude\sos\sos.json'
$sosJsonPath = Join-Path $targetFullPath $sosJsonRelative
$metadataUpdated = $false

if ($Apply -and (Test-Path -LiteralPath $sosJsonPath) -and ($created.Contains($sosJsonRelative) -or $Force)) {
    $metadata = Get-Content -Raw -LiteralPath $sosJsonPath | ConvertFrom-Json
    $metadata.node.name = $NodeName
    $metadata.node.kind = $NodeKind
    $metadata | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $sosJsonPath -Encoding utf8
    $metadataUpdated = $true
}

$result = [pscustomobject]@{
    Mode = if ($Apply) { 'apply' } else { 'preview' }
    TargetPath = $targetFullPath
    TemplateRoot = $templateRoot
    NodeName = $NodeName
    NodeKind = $NodeKind
    Force = [bool]$Force
    PlannedCreateCount = $planned.Count
    CreatedCount = $created.Count
    OverwrittenCount = $overwritten.Count
    SkippedExistingCount = $skipped.Count
    MetadataUpdated = $metadataUpdated
}

$result

if ($planned.Count -gt 0) {
    "`nWould create:"
    $planned | Sort-Object
}

if ($created.Count -gt 0) {
    "`nCreated:"
    $created | Sort-Object
}

if ($overwritten.Count -gt 0) {
    "`nOverwritten:"
    $overwritten | Sort-Object
}

if ($skipped.Count -gt 0) {
    "`nSkipped existing:"
    $skipped | Sort-Object
}

if (!$Apply) {
    "`nPreview only. Re-run with -Apply to write files."
}
