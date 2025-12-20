Import-Module "$PSScriptRoot\Modules\functions.psm1"

# Prompt for path
$path_reference = Get-Content "$PSScriptRoot\path.txt"
$path = Read-Host "Enter folder path for CSV (or press Enter to use saved path ($path_reference)) the file will be called 'all users'."

# Validate path
if ((Test-PathSafe $path) -and (Test-PathSafe $path_reference)) {
    $check = Read-Host "Valid path detected in path.txt ($path_reference). Replace saved path with new valid path ($path)? (y/n)"
    if ($check -match '^(y|yes)$') { Import-Path}
}

# Ensure we have a valid path
while (!(Test-PathSafe $path_reference)) {
    $path = Read-Host "saved path invalid. Please enter a valid folder path"
    if (Test-PathSafe $path) { Import-Path}
    $path_reference = Get-Content "$PSScriptRoot\path.txt"
}

# Menu
$all_properties = (get-aduser -filter * -properties * -ResultSetSize 1).psobject.properties.name |Where-Object {$_ -ne "Name"}
$all_properties += "Finished"
# Export

$all_users = Get-ADUser -filter * -properties *
$selected_properties = ask-for-properties
$exported_properties = @("Name") + $selected_properties
$csvPath = Join-Path $path_reference "all_users.csv"
$all_users | Select-Object $exported_properties | Export-Csv -Path $csvPath -NoTypeInformation

#elseif ($choice -eq 2) {

#}


