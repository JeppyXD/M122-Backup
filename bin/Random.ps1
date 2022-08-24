$Zielpfad = "C:\Ziel"
$AnzDateien = 5
$AnzZeich = 1000
$AnzDirectory= 10

$NameLenth = 10
$char = [char[]] 'abcdefghijklmnopqrstuvwxyz1234567890'

Remove-Item "$Zielpfad\*"

for($k = 1; $k -lt $AnzDirectory+1; $k++){
    New-Item $Zielpfad -Name "Unterverzeichnis-$k" -ItemType "directory"
    for($j = 1; $j -lt $AnzDateien+1; $j++){
        # Inhalt #
        $inhalt = ""
        for($i = 0; $i -lt $AnzZeich; $i++){
            $inhalt+=$char[(Get-Random -Maximum $char.Length -Minimum 0)];
        }

        # Datei erstellen #
        New-Item -Path "$Zielpfad\Unterverzeichnis-$k" -Name "$j.txt" -Value "$inhalt"
    }
}

