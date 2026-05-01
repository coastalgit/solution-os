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

function Get-MarkdownTableCells {
    param([string]$Line)

    $trimmed = $Line.Trim()
    if (!$trimmed.StartsWith('|')) {
        return @()
    }

    $trimmed = $trimmed.Trim('|')
    return @($trimmed -split '\|' | ForEach-Object { $_.Trim() })
}

function Normalize-SemanticCandidate {
    param([string]$Term)

    $value = (($Term -replace '[`*_#\[\]\(\)]', '') -replace '\s+', ' ').Trim()
    $value = $value -replace '[\.,:;!?]+$', ''

    if ([string]::IsNullOrWhiteSpace($value) -or $value.Contains('.')) {
        return ''
    }

    $words = @($value -split ' ')
    $isAcronym = $value -cmatch '^[A-Z0-9&-]{3,}$'
    if ($words.Count -lt 2 -and !$isAcronym) {
        return ''
    }

    return $value
}

function Split-AliasCell {
    param([string]$Cell)

    return @($Cell -split '[,;]' | ForEach-Object { Normalize-SemanticCandidate $_ } | Where-Object { $_ })
}

function Remove-MarkdownNoise {
    param([string]$Content)

    $withoutFrontmatter = $Content -replace '(?s)^---.*?---', ''
    $withoutCodeBlocks = $withoutFrontmatter -replace '(?s)```.*?```', ''
    return $withoutCodeBlocks -replace '`[^`]*`', ''
}

function Get-RegisteredActorTerms {
    $terms = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $actorsPath = Join-Path $targetFullPath '.claude\ACTORS.md'
    $actorsContent = Get-TextContent $actorsPath

    foreach ($line in ($actorsContent -split '\r?\n')) {
        $cells = @(Get-MarkdownTableCells $line)
        if ($cells.Count -lt 2) {
            continue
        }

        $first = $cells[0].ToLowerInvariant()
        if ($first -eq 'name' -or $first -eq 'role' -or $first.StartsWith('-') -or $first -eq '') {
            continue
        }

        foreach ($cell in @($cells[0], $cells[1])) {
            foreach ($term in (Split-AliasCell $cell)) {
                [void]$terms.Add($term)
            }
        }
    }

    return ,$terms
}

function Get-MissingActorsAliasColumns {
    $findings = New-Object System.Collections.Generic.List[string]
    $actorsPath = Join-Path $targetFullPath '.claude\ACTORS.md'
    $actorsContent = Get-TextContent $actorsPath

    foreach ($line in ($actorsContent -split '\r?\n')) {
        $cells = @(Get-MarkdownTableCells $line)
        if ($cells.Count -lt 2) {
            continue
        }

        $first = $cells[0].ToLowerInvariant()
        $hasActorHeader = $first -eq 'name' -or $first -eq 'role'
        $hasAliases = @($cells | Where-Object { $_.ToLowerInvariant() -eq 'aliases' }).Count -gt 0
        $isSeparator = @($cells | Where-Object { $_ -notmatch '^:?-{3,}:?$' }).Count -eq 0

        if ($hasActorHeader -and !$hasAliases -and !$isSeparator) {
            $findings.Add(".claude\ACTORS.md table ""$($cells -join ' | ')"" lacks Aliases column")
        }
    }

    return @($findings | Sort-Object)
}

function Get-ReservedVaultRegistryPaths {
    $reservedNames = @(
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
    )

    $vaultPath = Join-Path $targetFullPath 'vault'
    if (!(Test-Path -LiteralPath $vaultPath)) {
        return @()
    }

    return @(
        Get-ChildItem -LiteralPath $vaultPath -Recurse -Force -File -Filter '*.md' |
            Where-Object { $reservedNames -contains [System.IO.Path]::GetFileNameWithoutExtension($_.Name).ToLowerInvariant() } |
            ForEach-Object { Get-RelativePath $_.FullName } |
            Sort-Object
    )
}

function Get-UnregisteredSemanticCandidates {
    $stoplist = @(
        'actors',
        'agents',
        'api',
        'cli',
        'claude',
        'claude code',
        'codex',
        'commands',
        'current sos version',
        'git',
        'github',
        'json',
        'kb',
        'mcp',
        'node',
        'pm',
        'powershell',
        'read-only sos',
        'readme',
        'schema',
        'solutionos',
        'sos',
        'sos cli',
        'stone',
        'tools',
        'workflow',
        'yaml'
    )

    $registeredTerms = Get-RegisteredActorTerms
    $counts = @{}
    $candidateRegex = [regex]"\b(?:[A-Z][A-Za-z0-9&'.-]{2,}|[A-Z]{2,})(?:[ \t]+(?:[A-Z][A-Za-z0-9&'.-]{2,}|[A-Z]{2,})){0,3}\b"
    $scanFiles = New-Object System.Collections.Generic.List[System.IO.FileInfo]

    foreach ($relativeDir in @('vault\wiki', '.claude')) {
        $dir = Join-Path $targetFullPath $relativeDir
        if (Test-Path -LiteralPath $dir) {
            Get-ChildItem -LiteralPath $dir -Recurse -Force -File -Filter '*.md' |
                Where-Object {
                    $relative = (Get-RelativePath $_.FullName).Replace('\', '/')
                    !$relative.StartsWith('.claude/sos/') -and
                    !$relative.StartsWith('.claude/commands/') -and
                    $relative -ne '.claude/ACTORS.md'
                } |
                ForEach-Object { $scanFiles.Add($_) }
        }
    }

    foreach ($file in $scanFiles) {
        $content = Remove-MarkdownNoise (Get-TextContent $file.FullName)
        foreach ($match in $candidateRegex.Matches($content)) {
            $term = Normalize-SemanticCandidate $match.Value
            if (!$term) {
                continue
            }

            $key = $term.ToLowerInvariant()
            if ($stoplist -contains $key -or $registeredTerms.Contains($term)) {
                continue
            }

            if (!$counts.ContainsKey($key)) {
                $counts[$key] = [pscustomobject]@{ Term = $term; Count = 0 }
            }

            $counts[$key].Count += 1
        }
    }

    return @(
        $counts.Values |
            Where-Object { $_.Count -ge 2 } |
            Sort-Object @{ Expression = 'Count'; Descending = $true }, Term |
            Select-Object -First 25 |
            ForEach-Object { "$($_.Term) ($($_.Count))" }
    )
}

function Get-FirstTableHeader {
    param([string]$Content)

    foreach ($line in ($Content -split '\r?\n')) {
        $cells = @(Get-MarkdownTableCells $line)
        if ($cells.Count -eq 0) {
            continue
        }

        $isSeparator = @($cells | Where-Object { $_ -notmatch '^:?-{3,}:?$' }).Count -eq 0
        if (!$isSeparator) {
            return @($cells)
        }
    }

    return @()
}

function Get-MissingArchiveManifestColumns {
    $manifestPath = Join-Path $targetFullPath 'vault\archive\_manifest.md'
    if (!(Test-Path -LiteralPath $manifestPath)) {
        return @()
    }

    $requiredColumns = @('Path', 'Kind', 'Period', 'Status', 'Processed Into', 'Hash', 'Notes')
    $header = @(Get-FirstTableHeader (Get-TextContent $manifestPath))

    if ($header.Count -eq 0) {
        return @($requiredColumns | ForEach-Object { "vault\archive\_manifest.md -> $_" })
    }

    return @(
        $requiredColumns |
            Where-Object { $header -notcontains $_ } |
            ForEach-Object { "vault\archive\_manifest.md -> $_" } |
            Sort-Object
    )
}

function Test-ArchiveManifestReference {
    param(
        [string]$Content,
        [string]$RelativePath
    )

    $cleanPath = $RelativePath -replace '[\\/]+$', ''
    $name = [System.IO.Path]::GetFileName($cleanPath)

    return (
        (Test-ContentReference $Content $cleanPath) -or
        (Test-ContentReference $Content "$cleanPath/") -or
        (Test-ContentReference $Content $name)
    )
}

function Get-UnindexedArchiveItems {
    $archivePath = Join-Path $targetFullPath 'vault\archive'
    $manifestPath = Join-Path $targetFullPath 'vault\archive\_manifest.md'
    if (!(Test-Path -LiteralPath $archivePath) -or !(Test-Path -LiteralPath $manifestPath)) {
        return @()
    }

    $manifestContent = Get-TextContent $manifestPath
    $controlNames = @('README.md', '_manifest.md')

    return @(
        Get-ChildItem -LiteralPath $archivePath -Force |
            Where-Object { $controlNames -notcontains $_.Name } |
            ForEach-Object {
                $relative = (Get-RelativePath $_.FullName).Replace('\', '/')
                if ($_.PSIsContainer) {
                    "$relative/"
                }
                else {
                    $relative
                }
            } |
            Where-Object { !(Test-ArchiveManifestReference $manifestContent $_) } |
            Sort-Object
    )
}

function Test-SkipArchiveCandidatePath {
    param([string]$RelativePath)

    if ([string]::IsNullOrWhiteSpace($RelativePath)) {
        return $false
    }

    $excludedRoots = @('.git', '.backlog', '.claude', 'node_modules', 'templates', 'vault', 'coverage', 'dist', 'build')
    $root = @($RelativePath.Replace('\', '/') -split '/')[0]
    return $excludedRoots -contains $root
}

function Test-LooseArchiveCandidateName {
    param([string]$Name)

    $lower = $Name.ToLowerInvariant()
    if ($lower -eq 'readme.md' -or $lower -eq '_manifest.md') {
        return $false
    }

    return $lower -match '(^|[-_. ])(?:19\d{2}|20\d{2}|q[1-4]|emails?|correspondence|meetings?|minutes|archive|archived|history|historical|temp|tmp|old|legacy)([-_. ]|$)'
}

function Get-LooseArchiveCandidates {
    $findings = New-Object System.Collections.Generic.List[string]

    function Search-Candidates {
        param([string]$Path)

        foreach ($entry in Get-ChildItem -LiteralPath $Path -Force) {
            $relative = (Get-RelativePath $entry.FullName).Replace('\', '/')
            if (Test-SkipArchiveCandidatePath $relative) {
                continue
            }

            if ($entry.PSIsContainer) {
                if (Test-LooseArchiveCandidateName $entry.Name) {
                    $findings.Add("$relative/")
                    continue
                }

                Search-Candidates $entry.FullName
            }
            elseif (Test-LooseArchiveCandidateName $entry.Name) {
                $findings.Add($relative)
            }

            if ($findings.Count -ge 25) {
                return
            }
        }
    }

    Search-Candidates $targetFullPath
    return @($findings | Sort-Object -Unique | Select-Object -First 25)
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

$pmPath = Join-Path $targetFullPath '.claude\PM.md'
$pmContent = Get-TextContent $pmPath
$missingPmReferences = @(
    $pmRequiredReferences |
        Where-Object { !(Test-ContentReference $pmContent $_) }
)

$missingAdapterDelegation = New-Object System.Collections.Generic.List[string]

foreach ($adapterPath in $adapterRequiredReferences.Keys) {
    $adapterFullPath = Join-Path $targetFullPath $adapterPath
    $adapterContent = Get-TextContent $adapterFullPath

    foreach ($requiredReference in $adapterRequiredReferences[$adapterPath]) {
        if (!(Test-ContentReference $adapterContent $requiredReference)) {
            $missingAdapterDelegation.Add("$adapterPath -> $requiredReference")
        }
    }
}

$unreachableSurfacePaths = New-Object System.Collections.Generic.List[string]

foreach ($adapterPath in $adapterRequiredReferences.Keys) {
    $adapterFullPath = Join-Path $targetFullPath $adapterPath
    $adapterContent = Get-TextContent $adapterFullPath

    if (!(Test-ContentReference $adapterContent '.claude\PM.md')) {
        $unreachableSurfacePaths.Add("$adapterPath -> .claude\PM.md")
        continue
    }

    foreach ($missingPmReference in $missingPmReferences) {
        $unreachableSurfacePaths.Add("$adapterPath -> .claude\PM.md -> $missingPmReference")
    }
}

$uniqueUnreachableSurfacePaths = @($unreachableSurfacePaths | Sort-Object -Unique)

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

$sosCommandsDir = Join-Path $targetFullPath '.claude\commands\sos'
if (Test-Path -LiteralPath $sosCommandsDir) {
    Get-ChildItem -LiteralPath $sosCommandsDir -Recurse -Force -File -Filter '*.md' |
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

$missingActorsAliasColumns = @(Get-MissingActorsAliasColumns)
$reservedVaultRegistryPaths = @(Get-ReservedVaultRegistryPaths)
$unregisteredSemanticCandidates = @(Get-UnregisteredSemanticCandidates)
$missingArchiveManifestColumns = @(Get-MissingArchiveManifestColumns)
$unindexedArchiveItems = @(Get-UnindexedArchiveItems)
$looseArchiveCandidates = @(Get-LooseArchiveCandidates)

$runningHelperVersion = Get-RunningHelperVersion
$projectSosVersion = ''
$projectTemplateVersion = ''
$projectVersionRelation = if (Test-RelativePath '.claude\sos\sos.json') { 'project-version-missing' } else { 'not-installed' }
$versionWarnings = New-Object System.Collections.Generic.List[string]
$sosJsonPath = Join-Path $targetFullPath '.claude\sos\sos.json'

if (Test-Path -LiteralPath $sosJsonPath) {
    try {
        $metadata = Get-Content -Raw -LiteralPath $sosJsonPath | ConvertFrom-Json
        $projectSosVersion = if ($metadata.sos_version) { $metadata.sos_version } else { '' }
        $projectTemplateVersion = if ($metadata.template_version) { $metadata.template_version } else { '' }

        if ($projectSosVersion) {
            $comparison = Compare-SosVersion $projectSosVersion $runningHelperVersion
            if ($null -eq $comparison) {
                $projectVersionRelation = 'unknown'
            }
            elseif ($comparison -eq 0) {
                $projectVersionRelation = 'same'
            }
            elseif ($comparison -gt 0) {
                $projectVersionRelation = 'project-newer-than-cli'
                $versionWarnings.Add("project SOS $projectSosVersion is newer than running helper $runningHelperVersion; write commands must not run")
            }
            else {
                $projectVersionRelation = 'project-older-than-cli'
            }
        }
        else {
            $versionWarnings.Add('project has SOS metadata but no sos_version; write commands must not run')
        }
    }
    catch {
        $projectVersionRelation = 'metadata-unreadable'
        $versionWarnings.Add('project has .claude/sos/sos.json but it could not be read; write commands must not run')
    }
}

$status = if (
    $missingFiles.Count -eq 0 -and
    $missingDirs.Count -eq 0 -and
    $missingMetadata.Count -eq 0 -and
    $missingPmReferences.Count -eq 0 -and
    $missingAdapterDelegation.Count -eq 0 -and
    $uniqueUnreachableSurfacePaths.Count -eq 0 -and
    $missingActorsAliasColumns.Count -eq 0 -and
    $reservedVaultRegistryPaths.Count -eq 0 -and
    $missingArchiveManifestColumns.Count -eq 0 -and
    $unindexedArchiveItems.Count -eq 0 -and
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
    RunningHelperVersion = $runningHelperVersion
    ProjectSosVersion = $projectSosVersion
    ProjectTemplateVersion = $projectTemplateVersion
    ProjectVersionRelation = $projectVersionRelation
    VersionWarningCount = $versionWarnings.Count
    MissingFileCount = $missingFiles.Count
    MissingDirCount = $missingDirs.Count
    MetadataFileCount = $uniqueMetadataFiles.Count
    MissingMetadataCount = $missingMetadata.Count
    MissingPmReferenceCount = $missingPmReferences.Count
    MissingAdapterDelegationCount = $missingAdapterDelegation.Count
    UnreachableSurfacePathCount = $uniqueUnreachableSurfacePaths.Count
    MissingActorsAliasColumnCount = $missingActorsAliasColumns.Count
    ReservedVaultRegistryCount = $reservedVaultRegistryPaths.Count
    UnregisteredSemanticCandidateCount = $unregisteredSemanticCandidates.Count
    MissingArchiveManifestColumnCount = $missingArchiveManifestColumns.Count
    UnindexedArchiveItemCount = $unindexedArchiveItems.Count
    LooseArchiveCandidateCount = $looseArchiveCandidates.Count
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

if ($missingMetadata.Count -gt 0) {
    "`nMissing frontmatter:"
    $missingMetadata | Sort-Object
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

if ($missingActorsAliasColumns.Count -gt 0) {
    "`nMissing ACTORS alias columns:"
    $missingActorsAliasColumns | Sort-Object
}

if ($reservedVaultRegistryPaths.Count -gt 0) {
    "`nReserved vault actor registries:"
    $reservedVaultRegistryPaths | Sort-Object
}

if ($unregisteredSemanticCandidates.Count -gt 0) {
    "`nUnregistered actor/concept candidates:"
    $unregisteredSemanticCandidates | Sort-Object
}

if ($missingArchiveManifestColumns.Count -gt 0) {
    "`nMissing archive manifest columns:"
    $missingArchiveManifestColumns | Sort-Object
}

if ($unindexedArchiveItems.Count -gt 0) {
    "`nUnindexed archive items:"
    $unindexedArchiveItems | Sort-Object
}

if ($looseArchiveCandidates.Count -gt 0) {
    "`nLoose archive candidates:"
    $looseArchiveCandidates | Sort-Object
}
