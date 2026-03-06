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