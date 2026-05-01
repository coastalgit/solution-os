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

function Count-Files {
    param([string]$RelativePath)

    $path = Join-Path $targetFullPath $RelativePath
    if (!(Test-Path -LiteralPath $path)) {
        return 0
    }

    return @(Get-ChildItem -LiteralPath $path -Recurse -Force -File).Count
}

function Add-DetectedPath {
    param(
        [string]$RelativePath,
        [string]$Kind,
        [string]$SuggestedAction
    )

    if (Test-RelativePath $RelativePath) {
        return [pscustomobject]@{
            Path = $RelativePath
            Kind = $Kind
            FileCount = Count-Files $RelativePath
            SuggestedAction = $SuggestedAction
        }
    }
}

function Add-ProjectSkillsDetection {
    $skillsPath = Join-Path $targetFullPath '.claude\skills'
    if (!(Test-Path -LiteralPath $skillsPath)) {
        return
    }

    $projectSkillFiles = @(
        Get-ChildItem -LiteralPath $skillsPath -Recurse -Force -File -Filter 'SKILL.md' |
            Where-Object {
                $relativePath = $_.FullName.Substring($targetFullPath.Length).TrimStart('\', '/')
                $relativePath -ne '.claude\skills\sos\SKILL.md'
            }
    )

    if ($projectSkillFiles.Count -gt 0) {
        return [pscustomobject]@{
            Path = '.claude\skills'
            Kind = 'project-skills'
            FileCount = $projectSkillFiles.Count
            SuggestedAction = 'Review, test, and adopt/park/delete through a capability-pack decision.'
        }
    }
}

$detected = @()

$detected += @(Add-DetectedPath 'vault\inbox' 'legacy-vault-intake' 'Assess, then migrate useful items to vault/triage or archive processed evidence.')
$detected += @(Add-DetectedPath 'kb' 'legacy-knowledge-base' 'Map durable notes to vault/wiki and raw material to vault/triage or vault/archive.')
$detected += @(Add-DetectedPath 'knowledge-base' 'legacy-knowledge-base' 'Map durable notes to vault/wiki and raw material to vault/triage or vault/archive.')
$detected += @(Add-DetectedPath '.ai' 'legacy-ai-control' 'Inspect for reusable context; migrate durable rules into adapters, .claude/*.md, or vault/wiki.')
$detected += @(Add-DetectedPath '.spine' 'legacy-spine' 'Compare against SOS node files; migrate decisions/facts with source traceability.')
$detected += @(Add-DetectedPath 'docs\spine' 'legacy-spine' 'Compare against SOS node files; migrate decisions/facts with source traceability.')
$detected += @(Add-DetectedPath '.claude\seshmem' 'session-memory' 'Summarize only durable facts into current-state or archive; do not bulk-load.')
$detected += @(Add-DetectedPath '.claude\commands' 'legacy-commands' 'Prefer project skills or SOS command vocabulary; keep only proven commands.')
$detected += @(Add-ProjectSkillsDetection)
$detected += @(Add-DetectedPath 'backlog' 'task-system' 'Do not assume adoption; ask whether Backlog.md should be used.')
$detected += @(Add-DetectedPath '.backlog' 'task-system' 'Do not assume adoption; ask whether Backlog.md should be used.')

$missingManifests = @(
    'vault\triage\_manifest.md',
    'vault\wiki\_manifest.md',
    'vault\archive\_manifest.md',
    'vault\outbox\_manifest.md'
)
$missingManifests = @($missingManifests | Where-Object { !(Test-RelativePath $_) })

$questions = @(
    'Should SOS migrate legacy intake items into vault/triage, archive them as processed evidence, or leave them untouched for now?',
    'Should existing project-local skills be tested and adopted, parked as references, or ignored?',
    'Should Backlog.md or another task layer be adopted for this node, deferred, or explicitly rejected?',
    'Should old AI/session notes be summarized into current-state/decisions, archived as evidence, or left outside SOS?',
    'Should migration apply changes now, create a proposed plan only, or produce an outbox report for review?'
)

[pscustomobject]@{
    Status = if ($detected.Count -gt 0 -or $missingManifests.Count -gt 0) { 'migration-review-needed' } else { 'no-obvious-legacy-sources' }
    TargetPath = $targetFullPath
    SosInstalled = Test-RelativePath '.claude\sos\sos.json'
    DetectedSourceCount = $detected.Count
    DetectedSources = @($detected)
    MissingVaultManifestCount = $missingManifests.Count
    MissingVaultManifests = @($missingManifests)
    SuggestedQuestions = $questions
}
