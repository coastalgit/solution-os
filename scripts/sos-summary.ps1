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

$requiredFiles = @(
    'CLAUDE.md',
    'AGENTS.md',
    '.claude\PM.md',
    '.claude\STONE.md',
    '.claude\ACTORS.md',
    '.claude\TOOLS.md',
    '.claude\WORKFLOW.md',
    '.claude\skills\sos\SKILL.md',
    '.claude\commands\sos\help.md',
    '.claude\commands\sos\init.md',
    '.claude\commands\sos\summary.md',
    '.claude\commands\sos\audit.md',
    '.claude\commands\sos\tools.md',
    '.claude\commands\sos\ingest.md',
    '.claude\commands\sos\migrate.md',
    '.claude\commands\sos\vault-process.md',
    '.claude\commands\sos\vault-summary.md',
    '.claude\commands\sos\context-export.md',
    '.claude\commands\sos\context-import.md',
    '.claude\commands\sos\session-close.md',
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
    '.claude\sos\export',
    '.claude\commands\sos'
)

$missingFiles = @($requiredFiles | Where-Object { !(Test-RelativePath $_) })
$missingDirs = @($requiredDirs | Where-Object { !(Test-RelativePath $_) })

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
}

$status = if ($missingFiles.Count -eq 0 -and $missingDirs.Count -eq 0 -and [string]::IsNullOrWhiteSpace($metadataError)) {
    'healthy'
}
else {
    'attention'
}

[pscustomobject]@{
    Status = $status
    TargetPath = $targetFullPath
    SosInstalled = Test-RelativePath '.claude\sos\sos.json'
    SosVersion = $sosVersion
    TemplateVersion = $templateVersion
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
    MetadataError = $metadataError
}

if ($missingFiles.Count -gt 0) {
    "`nMissing files:"
    $missingFiles | Sort-Object
}

if ($missingDirs.Count -gt 0) {
    "`nMissing directories:"
    $missingDirs | Sort-Object
}
