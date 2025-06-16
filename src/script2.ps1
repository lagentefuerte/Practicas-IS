$currentTime = Get-Date
$oneHourAgo = $currentTime.AddHours(-1)


    
    $installedApps = Get-WinEvent -LogName 'Application' | Where-Object {
        $_.Id -eq 11707 -and $_.TimeCreated -ge $oneHourAgo -and $_.TimeCreated -le $currentTime
    }


$outputFilePath = "C:\Users\user\Documents\installed_apps.txt"


$appDetails = $installedApps | ForEach-Object {
    if ($appName = $_.Properties[0].Value -match ':\s*(.*?)\s* --'){
		$nombreApp = $matches[1]
	}
    $appPath = (Get-ItemProperty "HKLM:/Software/Microsoft/Windows/CurrentVersion/Uninstall/*" | Where-Object { $_.DisplayName -eq $appName }).InstallLocation
    if (-not $appPath){
		$appPath="No hay ruta"
	}
    $userId = $_.UserId
    $userName = (Get-LocalUser | Where-Object{$_.SID -eq "$userId"}).Name
    $fecha = $_.TimeCreated
    
    "Nombre APP: $nombreApp, PATH: $appPath, Nombre Usuario: $userName, Fecha: $fecha"
}


$appDetails | Out-File -FilePath $outputFilePath -Append