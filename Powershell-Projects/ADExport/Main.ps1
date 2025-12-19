#Import-Module "$PSScriptRoot\Modules\*"
#while ($true) {
#disclosure: I did use AI to help me in parts, however these parts are explicitly labelled.
function Test-PathSafe {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    return Test-Path $Path
}

function Import-Path {
    param([string]$Path)
    Set-Content -Path "$PSScriptRoot\path.txt" -Value $Path
}

# Prompt for path
$path = Read-Host "Enter folder path for CSV (or press Enter to use saved path)"
$path_reference = Get-Content "$PSScriptRoot\path.txt"

# Validate path
if (Test-PathSafe $path) {
    $check = Read-Host "Valid path detected ($path). Replace saved path? (y/n)"
    if ($check -match '^(y|yes)$') { Import-Path $path }
}

# Ensure we have a valid path
while (-not (Test-PathSafe $path_reference)) {
    $path = Read-Host "Saved path invalid. Please enter a valid folder path:"
    if (Test-PathSafe $path) { Import-Path $path }
    $path_reference = Get-Content "$PSScriptRoot\path.txt"
}

# Menu
$choice = Read-Host "Choose option: 1 = All users, 2 = Filtered users"

# Export
if ($choice -eq 1) {
    $all_users = Get-ADUser -Filter * -Properties *
    $csvPath = Join-Path $path_reference "all_users.csv"
    $all_users | Export-Csv -Path $csvPath -NoTypeInformation
}
elseif ($choice -eq 2) {
    $filtered_users = Get-ADUser -Filter {Enabled -eq $true} -Properties *
    $csvPath = Join-Path $path_reference "filtered_users.csv"
    $filtered_users | Export-Csv -Path $csvPath -NoTypeInformation
}
