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

function Get-TextContent {
    param([string]$Path)

    if (!(Test-Path -LiteralPath $Path)) {
        return ''
    }

    return Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
}

function Test-ContentReference {
    param(
        [string]$Content,
        [string]$RelativePath
    )

    if ([string]::IsNullOrWhiteSpace($Content)) {
        return $false
    }

    $variants = @(
        $RelativePath,
        $RelativePath.Replace('\', '/'),
        $RelativePath.Replace('/', '\')
    ) | Sort-Object -Unique

    foreach ($variant in $variants) {
        if ($Content.IndexOf($variant, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            return $true
        }
    }

    return $false
}

function Count-NodeFiles {
    param([string]$RelativePath)

    $path = Join-Path $targetFullPath $RelativePath
    if (!(Test-Path -LiteralPath $path)) {
        return 0
    }

    return @(
        Get-ChildItem -LiteralPath $path -File -Force |
            Where-Object { $_.Name -ne 'README.md' -and $_.Name -ne '_manifest.md' }
    ).Count
}

function Get-PropertyValue {
    param(
        [object]$Object,
        [string]$Name,
        [object]$Default = ''
    )

    if ($null -eq $Object) {
        return $Default
    }

    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) {
        return $Default
    }

    return $property.Value
}

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

function Get-RunningHelperVersion {
    $scriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $PSCommandPath }
    $candidates = @(
        (Join-Path $scriptRoot '..\sos.json'),
        (Join-Path $scriptRoot '..\manifest.json'),
        (Join-Path $scriptRoot '..\..\..\manifest.json')
    )

    foreach ($candidate in $candidates) {
        $fullPath = [System.IO.Path]::GetFullPath($candidate)
        if (!(Test-Path -LiteralPath $fullPath)) {
            continue
        }

        try {
            $json = Get-Content -Raw -LiteralPath $fullPath | ConvertFrom-Json
            if ($json.sos_version) {
                return $json.sos_version
            }
        }
        catch {
        }
    }

    return '0.0.0'
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
    '.claude\commands\sos\assistant.md',
    '.claude\commands\sos\help.md',
    '.claude\commands\sos\about.md',
    '.claude\commands\sos\init.md',
    '.claude\commands\sos\summary.md',
    '.claude\commands\sos\audit.md',
    '.claude\commands\sos\tools.md',
    '.claude\commands\sos\ingest.md',
    '.claude\commands\sos\migrate.md',
    '.claude\commands\sos\vault-process.md',
    '.claude\commands\sos\vault-summary.md',
    '.claude\commands\sos\archive.md',
    '.claude\commands\sos\unarchive.md',
    '.claude\commands\sos\context-export.md',
    '.claude\commands\sos\context-import.md',
    '.claude\commands\sos\session-close.md',
    '.claude\sos\sos.json',
    '.claude\sos\VERSION.md',
    '.claude\sos\COMMANDS.md',
    '.claude\sos\ASSISTANT.md',
    '.claude\sos\SOS-VISUAL.html',
    '.claude\sos\SCHEMA.md',
    '.claude\sos\TOOLKITS.md',
    '.claude\sos\template\concept-binding.md',
    '.claude\sos\scripts\README.md',
    '.claude\sos\scripts\sos-summary.ps1',
    '.claude\sos\scripts\sos-audit.ps1',
    '.claude\sos\scripts\sos-migrate-assess.ps1',
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
    '.claude\sos\scripts',
    '.claude\sos\export',
    '.claude\commands\sos'
)

$missingFiles = @($requiredFiles | Where-Object { !(Test-RelativePath $_) })
$missingDirs = @($requiredDirs | Where-Object { !(Test-RelativePath $_) })

$pmRequiredReferences = @(
    '.claude\STONE.md',
    '.claude\ACTORS.md',
    '.claude\TOOLS.md',
    '.claude\WORKFLOW.md',
    '.claude\sos',
    '.claude\skills\sos',
    '.claude\commands\sos',
    'vault\triage',
    'vault\wiki',
    'vault\archive',
    'vault\outbox'
)

$adapterRequiredReferences = @{
    'CLAUDE.md' = @('.claude\PM.md')
    'AGENTS.md' = @('.claude\PM.md', '.claude\sos\COMMANDS.md')
}

$pmContent = Get-TextContent (Join-Path $targetFullPath '.claude\PM.md')
$missingPmReferences = @(
    $pmRequiredReferences |
        Where-Object { !(Test-ContentReference $pmContent $_) }
)

$missingAdapterDelegation = New-Object System.Collections.Generic.List[string]

foreach ($adapterPath in $adapterRequiredReferences.Keys) {
    $adapterContent = Get-TextContent (Join-Path $targetFullPath $adapterPath)

    foreach ($requiredReference in $adapterRequiredReferences[$adapterPath]) {
        if (!(Test-ContentReference $adapterContent $requiredReference)) {
            $missingAdapterDelegation.Add("$adapterPath -> $requiredReference")
        }
    }
}

$unreachableSurfacePaths = New-Object System.Collections.Generic.List[string]

foreach ($adapterPath in $adapterRequiredReferences.Keys) {
    $adapterContent = Get-TextContent (Join-Path $targetFullPath $adapterPath)

    if (!(Test-ContentReference $adapterContent '.claude\PM.md')) {
        $unreachableSurfacePaths.Add("$adapterPath -> .claude\PM.md")
        continue
    }

    foreach ($missingPmReference in $missingPmReferences) {
        $unreachableSurfacePaths.Add("$adapterPath -> .claude\PM.md -> $missingPmReference")
    }
}

$uniqueUnreachableSurfacePaths = @($unreachableSurfacePaths | Sort-Object -Unique)

$sosJsonPath = Join-Path $targetFullPath '.claude\sos\sos.json'
$metadata = $null
$metadataError = ''

if (Test-Path -LiteralPath $sosJsonPath) {
    try {
        $metadata = Get-Content -Raw -LiteralPath $sosJsonPath | ConvertFrom-Json
    }
    catch {
        $metadataError = $_.Exception.Message
    }
}

$nodeName = ''
$nodeKind = ''
$sosVersion = ''
$templateVersion = ''
$parentName = ''
$parentReadable = $false
$publishUpward = ''
$remoteRepositoryUrl = ''
$remoteManifestUrl = ''
$remoteDefaultBranch = ''
$runningHelperVersion = Get-RunningHelperVersion
$projectVersionRelation = if (Test-RelativePath '.claude\sos\sos.json') { 'project-version-missing' } else { 'not-installed' }
$versionWarnings = New-Object System.Collections.Generic.List[string]

if ($null -ne $metadata) {
    $nodeName = $metadata.node.name
    $nodeKind = $metadata.node.kind
    $sosVersion = $metadata.sos_version
    $templateVersion = $metadata.template_version
    $parentName = $metadata.parent.name
    $parentReadable = [bool]$metadata.parent.read_upward
    $publishUpward = $metadata.parent.publish_upward
    $remoteRepositoryUrl = Get-PropertyValue $metadata.remote 'repository_url'
    $remoteManifestUrl = Get-PropertyValue $metadata.remote 'manifest_url'
    $remoteDefaultBranch = Get-PropertyValue $metadata.remote 'default_branch'

    if ($sosVersion) {
        $comparison = Compare-SosVersion $sosVersion $runningHelperVersion
        if ($null -eq $comparison) {
            $projectVersionRelation = 'unknown'
            $versionWarnings.Add("project SOS version $sosVersion could not be compared with running helper $runningHelperVersion")
        }
        elseif ($comparison -eq 0) {
            $projectVersionRelation = 'same'
        }
        elseif ($comparison -gt 0) {
            $projectVersionRelation = 'project-newer-than-cli'
            $versionWarnings.Add("project SOS $sosVersion is newer than running helper $runningHelperVersion; write commands must not run")
        }
        else {
            $projectVersionRelation = 'project-older-than-cli'
        }
    }
    else {
        $versionWarnings.Add('project has SOS metadata but no sos_version; write commands must not run')
    }
}
elseif (![string]::IsNullOrWhiteSpace($metadataError)) {
    $projectVersionRelation = 'metadata-unreadable'
    $versionWarnings.Add('project has .claude/sos/sos.json but it could not be read; write commands must not run')
}

$status = if (
    $missingFiles.Count -eq 0 -and
    $missingDirs.Count -eq 0 -and
    $missingPmReferences.Count -eq 0 -and
    $missingAdapterDelegation.Count -eq 0 -and
    $uniqueUnreachableSurfacePaths.Count -eq 0 -and
    [string]::IsNullOrWhiteSpace($metadataError) -and
    $versionWarnings.Count -eq 0
) {
    'healthy'
}
else {
    'attention'
}

[pscustomobject]@{
    Status = $status
    TargetPath = $targetFullPath
    SosInstalled = Test-RelativePath '.claude\sos\sos.json'
    RunningHelperVersion = $runningHelperVersion
    SosVersion = $sosVersion
    TemplateVersion = $templateVersion
    ProjectVersionRelation = $projectVersionRelation
    VersionWarningCount = $versionWarnings.Count
    NodeName = $nodeName
    NodeKind = $nodeKind
    ParentName = $parentName
    ParentReadable = $parentReadable
    PublishUpward = $publishUpward
    RemoteRepositoryUrl = $remoteRepositoryUrl
    RemoteManifestUrl = $remoteManifestUrl
    RemoteDefaultBranch = $remoteDefaultBranch
    TriageItemCount = Count-NodeFiles 'vault\triage'
    WikiNoteCount = Count-NodeFiles 'vault\wiki'
    OutboxItemCount = Count-NodeFiles 'vault\outbox'
    MissingFileCount = $missingFiles.Count
    MissingDirCount = $missingDirs.Count
    MissingPmReferenceCount = $missingPmReferences.Count
    MissingAdapterDelegationCount = $missingAdapterDelegation.Count
    UnreachableSurfacePathCount = $uniqueUnreachableSurfacePaths.Count
    MetadataError = $metadataError
}

if ($versionWarnings.Count -gt 0) {
    "`nVersion warnings:"
    $versionWarnings | Sort-Object
}

if ($missingFiles.Count -gt 0) {
    "`nMissing files:"
    $missingFiles | Sort-Object
}

if ($missingDirs.Count -gt 0) {
    "`nMissing directories:"
    $missingDirs | Sort-Object
}

if ($missingPmReferences.Count -gt 0) {
    "`nMissing PM references:"
    $missingPmReferences | Sort-Object
}

if ($missingAdapterDelegation.Count -gt 0) {
    "`nMissing adapter delegation:"
    $missingAdapterDelegation | Sort-Object
}

if ($uniqueUnreachableSurfacePaths.Count -gt 0) {
    "`nUnreachable SOS surface paths:"
    $uniqueUnreachableSurfacePaths | Sort-Object
}
