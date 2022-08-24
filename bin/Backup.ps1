$SrcPath = "C:\Test\" # Pfad vom Order der kopiert werden soll #
$BckPath = "C:\Ziel\" # Pfad in welchen Ordner die Dateien kopiert werden soll #
$LogPath = $BckPath   # Pfad, wo die Log-Dateien gespeichert werden soll (Verzeichnis wird automatisch erstellt) #

[bool]$IsErfolgreich = 1
[string]$inhalt = ""
$newline = "`r`n"
$tab = "`t"
$FileCount = (Get-ChildItem $SrcPath | Measure-Object).Count

#Alle Dateien im Ziel-Ordner löschen, ausser Backuplog-Ordner#
Remove-Item -Path "$BckPath\*" -Exclude "BackupLog"
for($i = 0;$i -lt ((Get-ChildItem $SrcPath | Measure-Object).Count);$i++){
    Copy-Item ($SrcPath+(Get-ChildItem $SrcPath).BaseName[$i]) -Destination $BckPath -Recurse
}

#Inhalt von der Log-Datei#
$date = Get-Date
$inhalt+= [string]$date+$newline+[string]$FileCount+" wurden von '"+$SrcPath+"' nach '"+$BckPath+"' verschoben:"+$newline+$newline+$SrcPath+":"+$newline

#Dateinamen vom Quell-Ordner#
for($i = 0; $i -lt $FileCount; $i++){
    $inhalt+=$tab+(Get-ChildItem -Path $SrcPath).BaseName[$i] +$newline
}

#Dateinamen vom Ziel-Ordner#
$inhalt+=$newline
$inhalt+=$BckPath+":"+$newline;
for($i = 0; $i -lt ((Get-ChildItem $BckPath | Measure-Object).Count); $i++){
    $inhalt+=$tab+(Get-ChildItem -Path $BckPath).BaseName[$i] +$newline
}
$inhalt+=$newline

#Vergleich, ob alles in ordnung ist#
if(Compare-Object (Get-ChildItem -Path $SrcPath) (Get-ChildItem -Path $BckPath -Exclude "BackupLog") -Property Name, Length){
    $IsErfolgreich=0
}

#"IstErfolgreich" in Log.txt#
$inhalt+="Ist erfolgreich: "
if($IsErfolgreich -eq 1){
    $inhalt+="True"
}else{
    $inhalt+="False"
}

#Log-Ordner erstellen, falls nicht vorhanden#
if(-not (Test-Path -Path "$LogPath\BackupLog")){
    New-item -Path $LogPath -Name "BackupLog" -ItemType "directory"
}

#Log-Datei in Log-Ordner erstellen#
New-Item -Path "$LogPath\BackupLog" -Name ("log-"+$date.Year+"-"+"{0:d2}" -f $date.Month+"-"+"{0:d2}" -f $date.Day+"_"+"{0:d2}" -f $date.Hour+"-"+"{0:d2}" -f $date.Minute+"-"+"{0:d2}" -f $date.Second+".txt") -ItemType "file" -Value $inhalt
Write-Host $inhalt