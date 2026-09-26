$datasets = @(
    @{ Sources = @('SW Item Database - Armor.csv'); Output = 'Armor.js'; Key = 'armor'; Optional = $false },
    @{ Sources = @('SW Item Database - Feats.csv'); Output = 'Feats.js'; Key = 'feats'; Optional = $false },
    @{ Sources = @('SW Item Database - Misc.csv'); Output = 'Misc.js'; Key = 'misc'; Optional = $false },
    @{ Sources = @('SW Item Database - Powers.csv'); Output = 'Powers.js'; Key = 'powers'; Optional = $false },
    @{ Sources = @('SW Item Database - Upgrades.csv'); Output = 'Upgrades.js'; Key = 'upgrades'; Optional = $false },
    @{ Sources = @('SW Item Database - Weapons.csv'); Output = 'Weapons.js'; Key = 'weapons'; Optional = $false },
    @{ Sources = @('Droid Parts.csv', 'SW Item Database - Droid Parts.csv'); Output = 'DroidParts.js'; Key = 'droidParts'; Optional = $true },
    @{ Sources = @('Consumables.csv', 'SW Item Database - Consumables.csv'); Output = 'Consumables.js'; Key = 'consumables'; Optional = $true },
    @{ Sources = @('Implants.csv', 'SW Item Database - Implants.csv'); Output = 'Implants.js'; Key = 'implants'; Optional = $true },
    @{ Sources = @('Class.csv', 'SW Item Database - Class.csv'); Output = 'Class.js'; Key = 'classes'; Optional = $true },
    @{ Sources = @('Species.csv', 'SW Item Database - Species.csv'); Output = 'Species.js'; Key = 'species'; Optional = $true },
    @{ Sources = @('Background.csv', 'SW Item Database - Background.csv'); Output = 'Background.js'; Key = 'backgrounds'; Optional = $true }
)

$utf8WithoutBom = [System.Text.UTF8Encoding]::new($false)

foreach ($dataset in $datasets) {
    $csvPath = $null
    foreach ($source in $dataset.Sources) {
        $candidate = Join-Path $PSScriptRoot $source
        if (Test-Path -LiteralPath $candidate) {
            $csvPath = $candidate
            break
        }
    }

    if (-not $csvPath) {
        if (-not $dataset.Optional) {
            throw "Required spreadsheet export not found: $($dataset.Sources[0])"
        }
        $outputPath = Join-Path $PSScriptRoot $dataset.Output
        if (-not (Test-Path -LiteralPath $outputPath)) {
            $javascript = "window.appData = window.appData || {};`r`nwindow.appData[`"$($dataset.Key)`"] = [];`r`n"
            [System.IO.File]::WriteAllText($outputPath, $javascript, $utf8WithoutBom)
        }
        continue
    }

    $rows = @(Import-Csv -LiteralPath $csvPath)
    $json = ConvertTo-Json -InputObject $rows -Depth 100 -Compress
    $javascript = "window.appData = window.appData || {};`r`nwindow.appData[`"$($dataset.Key)`"] = $json;`r`n"
    $outputPath = Join-Path $PSScriptRoot $dataset.Output
    [System.IO.File]::WriteAllText($outputPath, $javascript, $utf8WithoutBom)
    Write-Host ("Generated {0} from {1} ({2} rows)" -f $dataset.Output, (Split-Path $csvPath -Leaf), $rows.Count)
}
