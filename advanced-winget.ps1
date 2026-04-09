Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- UI Setup ---
# System.Drawing.Size(750, 850)
$form = New-Object System.Windows.Forms.Form
$form.Text = "WinGet Pro Sync Manager"
$form.Size = New-Object System.Drawing.Size(750, 850)
$form.StartPosition = "CenterScreen"

# Font Definitions
$fontBold9 = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$fontBold8 = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$fontStatusHuge = New-Object System.Drawing.Font("Arial Black", 14, [System.Drawing.FontStyle]::Bold)

# Header Labels
$labelId = New-Object System.Windows.Forms.Label
$labelId.Text = "Package ID"; $labelId.Location = "20, 75"; $labelId.Width = 270; $labelId.Font = $fontBold9; $form.Controls.Add($labelId)
$labelAdd = New-Object System.Windows.Forms.Label
$labelAdd.Text = "Add"; $labelAdd.Location = "350, 75"; $labelAdd.Width = 80; $labelAdd.Font = $fontBold8; $form.Controls.Add($labelAdd)
$labelRem = New-Object System.Windows.Forms.Label
$labelRem.Text = "Remove"; $labelRem.Location = "420, 75"; $labelRem.Width = 80; $labelRem.Font = $fontBold8; $form.Controls.Add($labelRem)
$labelIgnore = New-Object System.Windows.Forms.Label
$labelIgnore.Text = "Ignore"; $labelIgnore.Location = "490, 75"; $labelIgnore.Width = 80; $labelIgnore.Font = $fontBold8; $form.Controls.Add($labelIgnore)
$labelStatus = New-Object System.Windows.Forms.Label
$labelStatus.Text = "Installed"; $labelStatus.Location = "560, 75"; $labelStatus.Width = 120; $labelStatus.Font = $fontBold8; $form.Controls.Add($labelStatus)

# --- Container for Rows ---
$panel = New-Object System.Windows.Forms.FlowLayoutPanel
$panel.Location = New-Object System.Drawing.Point(10, 100)
$panel.Size = New-Object System.Drawing.Size(710, 600)
$panel.AutoScroll = $true
$panel.FlowDirection = "TopDown"
$panel.WrapContents = $false
$form.Controls.Add($panel)

$script:packageEntries = New-Object System.Collections.Generic.List[PSCustomObject]

# --- Function: Hard Sort & Display ---
function Sort-And-Display {
    $panel.Visible = $false
    $panel.Controls.Clear()
    $sortedList = $script:packageEntries | Sort-Object @{Expression={$_.Ignore.Checked}; Ascending=$true}, @{Expression={$_.ID}; Ascending=$true}
    foreach ($item in $sortedList) { $panel.Controls.Add($item.Control) }
    $panel.Visible = $true
}

# --- Function: Create Row Object ---
function New-PackageEntry($id, $isInstalled) {
    if ($id.Length -lt 3 -or $id -notmatch "\.") { return $null }
    foreach ($entry in $script:packageEntries) { if ($entry.ID -eq $id) { return $null } }

    $rowContainer = New-Object System.Windows.Forms.Panel
    $rowContainer.Size = New-Object System.Drawing.Size(680, 40) 
    $rowContainer.BorderStyle = "FixedSingle"

    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = $id; $nameLabel.Location = "5, 12"; $nameLabel.Width = 330
    $rowContainer.Controls.Add($nameLabel)

    $rbAdd = New-Object System.Windows.Forms.RadioButton
    $rbAdd.Location = "360, 10"; $rbAdd.Width = 20; $rbAdd.Checked = $isInstalled 
    $rowContainer.Controls.Add($rbAdd)

    $rbRem = New-Object System.Windows.Forms.RadioButton
    $rbRem.Location = "430, 10"; $rbRem.Width = 20
    $rowContainer.Controls.Add($rbRem)

    $rbIgnore = New-Object System.Windows.Forms.RadioButton
    $rbIgnore.Location = "500, 10"; $rbIgnore.Width = 20; $rbIgnore.Checked = (-not $isInstalled)
    $rowContainer.Controls.Add($rbIgnore)

    $rbIgnore.Add_CheckedChanged({ if ($this.Checked) { Sort-And-Display } })
    $rbAdd.Add_CheckedChanged({ if ($this.Checked) { Sort-And-Display } })
    $rbRem.Add_CheckedChanged({ if ($this.Checked) { Sort-And-Display } })

    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Location = "560, 2"; $statusLabel.Width = 100; $statusLabel.Height = 35
    $statusLabel.Font = $fontStatusHuge
    if ($isInstalled) {
        $statusLabel.Text = "YES"; $statusLabel.ForeColor = [System.Drawing.Color]::ForestGreen
    } else {
        $statusLabel.Text = "no"; $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
    $rowContainer.Controls.Add($statusLabel)

    return [PSCustomObject]@{
        ID      = $id
        Control = $rowContainer
        Add     = $rbAdd
        Remove  = $rbRem
        Ignore  = $rbIgnore
    }
}

# --- Initial Sync ---
function Initial-Sync {
    Write-Host "Calculating Installed..." -ForegroundColor Cyan
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $exportFile = "$PSScriptRoot\Backup_$timestamp.json"
    winget export -o $exportFile --include-versions --accept-source-agreements 2>$null
    
    if (Test-Path $exportFile) {
        $content = Get-Content $exportFile | ConvertFrom-Json
        foreach ($pkg in $content.Sources.Packages) {
            $e = New-PackageEntry -id $pkg.PackageIdentifier -isInstalled $true
            if ($e) { $script:packageEntries.Add($e) }
        }
    }
    
    $list = winget list --accept-source-agreements 2>$null | Select-String -Pattern '(\w+\.\w+[\.\w+]*)'
    foreach ($match in $list) {
        $e = New-PackageEntry -id $match.Matches.Value[0] -isInstalled $true
        if ($e) { $script:packageEntries.Add($e) }
    }
    Sort-And-Display
}

# --- Standard Buttons ---
$btnImport = New-Object System.Windows.Forms.Button
$btnImport.Text = "Import JSON"; $btnImport.Location = "10, 15"; $btnImport.Size = "100, 30"
$btnImport.Add_Click({
    $fd = New-Object System.Windows.Forms.OpenFileDialog
    if ($fd.ShowDialog() -eq "OK") {
        $content = Get-Content $fd.FileName | ConvertFrom-Json
        foreach ($pkg in $content.Sources.Packages) {
            $e = New-PackageEntry -id $pkg.PackageIdentifier -isInstalled $false
            if ($e) { $script:packageEntries.Add($e) }
        }
        Sort-And-Display
    }
})
$form.Controls.Add($btnImport)

$btnSort = New-Object System.Windows.Forms.Button
$btnSort.Text = "Sort A-Z"; $btnSort.Location = "120, 15"; $btnSort.Size = "80, 30"
$btnSort.Add_Click({ Sort-And-Display })
$form.Controls.Add($btnSort)

$btnAllKeep = New-Object System.Windows.Forms.Button
$btnAllKeep.Text = "All Keep"; $btnAllKeep.Location = "350, 15"; $btnAllKeep.Size = "80, 30"
$btnAllKeep.Add_Click({ foreach($e in $script:packageEntries) { $e.Add.Checked = $true }; Sort-And-Display })
$form.Controls.Add($btnAllKeep)

$btnAllIgnore = New-Object System.Windows.Forms.Button
$btnAllIgnore.Text = "All Ignore"; $btnAllIgnore.Location = "440, 15"; $btnAllIgnore.Size = "80, 30"
$btnAllIgnore.Add_Click({ foreach($e in $script:packageEntries) { $e.Ignore.Checked = $true }; Sort-And-Display })
$form.Controls.Add($btnAllIgnore)

# --- NEW EXIT BUTTON ---
$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "EXIT"; $btnExit.Location = "530, 15"; $btnExit.Size = "80, 30"
$btnExit.BackColor = [System.Drawing.Color]::IndianRed
$btnExit.ForeColor = [System.Drawing.Color]::White
$btnExit.Add_Click({ $form.Close() })
$form.Controls.Add($btnExit)

# --- Execute Button ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "UPDATE and Make Changes"; $btnRun.Location = "10, 710"; $btnRun.Size = "710, 60"
$btnRun.BackColor = [System.Drawing.Color]::SteelBlue; $btnRun.ForeColor = [System.Drawing.Color]::White; $btnRun.Font = $fontBold9
$btnRun.Add_Click({
    if ([System.Windows.Forms.MessageBox]::Show("Apply changes?", "Confirm Sync", [System.Windows.Forms.MessageBoxButtons]::YesNo) -eq "Yes") {
        foreach ($item in $script:packageEntries) {
            if ($item.Add.Checked) { 
                Write-Host "Syncing: $($item.ID)" -ForegroundColor Green
                winget install --id $item.ID --silent --accept-package-agreements --accept-source-agreements
            } elseif ($item.Remove.Checked) { 
                Write-Host "Uninstalling: $($item.ID)" -ForegroundColor Red
                winget uninstall --id $item.ID --silent
            }
        }
        [System.Windows.Forms.MessageBox]::Show("Done!"); $form.Close()
    }
})
$form.Controls.Add($btnRun)

Initial-Sync
$form.ShowDialog() | Out-Null
