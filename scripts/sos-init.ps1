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

function Compare-SosVersion {
    param(
        [string]$Left,
        [string]$Right
    )

    if ([string]::IsNullOrWhiteSpace($Left) -or [string]::IsNullOrWhiteSpace($Right)) {
        return $null
    }

    $leftCore = ($Left -split '[+-]', 2)[0]
    $rightCore = ($Right -split '[+-]', 2)[0]
    $leftParts = @($leftCore -split '\.' | ForEach-Object { [int]$_ })
    $rightParts = @($rightCore -split '\.' | ForEach-Object { [int]$_ })
    $max = [Math]::Max($leftParts.Count, $rightParts.Count)

    for ($index = 0; $index -lt $max; $index++) {
        $leftPart = if ($index -lt $leftParts.Count) { $leftParts[$index] } else { 0 }
        $rightPart = if ($index -lt $rightParts.Count) { $rightParts[$index] } else { 0 }

        if ($leftPart -gt $rightPart) {
            return 1
        }

        if ($leftPart -lt $rightPart) {
            return -1
        }
    }

    return 0
}

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

if ($Force) {
    throw "sos-init never overwrites existing files. -Force is disabled; use a separate approved upgrade or repair flow for existing-file changes."
}

$runningVersion = '0.0.0'
$manifestPath = Join-Path $repoRoot 'manifest.json'
if (Test-Path -LiteralPath $manifestPath) {
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if ($manifest.sos_version) {
        $runningVersion = $manifest.sos_version
    }
}

$sosJsonRelative = '.claude\sos\sos.json'
$sosJsonPath = Join-Path $targetFullPath $sosJsonRelative
$existingSosInstalled = Test-Path -LiteralPath $sosJsonPath
$projectSosVersion = ''
$projectVersionRelation = if ($existingSosInstalled) { 'project-version-missing' } else { 'not-installed' }

if ($existingSosInstalled) {
    try {
        $existingMetadata = Get-Content -Raw -LiteralPath $sosJsonPath | ConvertFrom-Json
        if ($existingMetadata.sos_version) {
            $projectSosVersion = $existingMetadata.sos_version
            $comparison = Compare-SosVersion $projectSosVersion $runningVersion
            if ($null -eq $comparison) {
                $projectVersionRelation = 'unknown'
            }
            elseif ($comparison -eq 0) {
                $projectVersionRelation = 'same'
            }
            elseif ($comparison -gt 0) {
                $projectVersionRelation = 'project-newer-than-cli'
            }
            else {
                $projectVersionRelation = 'project-older-than-cli'
            }
        }
    }
    catch {
        $projectVersionRelation = 'metadata-unreadable'
    }
}

$blockedRelations = @('project-newer-than-cli', 'metadata-unreadable', 'unknown', 'project-version-missing')
if ($Apply -and $blockedRelations -contains $projectVersionRelation) {
    throw "Refusing to apply: project version state is '$projectVersionRelation' (project: $projectSosVersion, running helper: $runningVersion). Run audit/status and update the CLI/helper if needed. No files were changed."
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
        $skipped.Add($relativePath)
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

$metadataUpdated = $false

if ($Apply -and (Test-Path -LiteralPath $sosJsonPath) -and $created.Contains($sosJsonRelative)) {
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
    ExistingSosInstalled = $existingSosInstalled
    ProjectSosVersion = $projectSosVersion
    RunningHelperVersion = $runningVersion
    ProjectVersionRelation = $projectVersionRelation
    NodeName = $NodeName
    NodeKind = $NodeKind
    OverwritePolicy = 'never-overwrite-existing-files'
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
