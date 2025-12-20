#Import-Module "$PSScriptRoot\Modules\*"
#while ($true) {


function Test-PathSafe {
    param([string]$Path)
    if (!$path) { return $false }
    return Test-Path $Path
}

function Import-Path {
    Set-Content -Path "$PSScriptRoot\path.txt" -Value $Path
}

function ask-for-properties {    

    $like = read-host "would you like to use all properties? (y/n)"
    if ($like -match '^(y|yes)$') { 
        return $all_properties  
    }
    elseif($like -match "^(n|no)"){
        $selected_properties = @()
     while(!($selected_properties -contains "Finished")){
         $sel = $all_properties | Out-GridView -PassThru -Title "Select a property (click Finished when done)"
            if ($sel -contains "Finished") { break }
            $selected_properties += $sel
        }
        return $selected_properties
        }

    }


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

$users = Get-ADUser -filter * -properties *
$selected_properties = ask-for-properties
$exported_properties = @("Name") + $selected_properties
$all_users| Select-Object $exported_properties | Export-Csv -Path $csvPath -NoTypeInformation #returns error, but there is no issue this is just due to duplicate of "name" property.

#elseif ($choice -eq 2) {

#}

