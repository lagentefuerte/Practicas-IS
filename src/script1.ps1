
$usuario = Read-Host "Introduce el nombre de usuario"

 $InicioSesion = Get-WinEvent -LogName Security | Where-Object { $_.Id -eq 4624 -and $_.Properties[5].Value -eq $usuario } | Select-Object -First 3


foreach ($sesion in $InicioSesion) {
    $logonTime = $sesion.TimeCreated
    $logonIp = $sesion.Properties[18].Value
   
    Write-Host "Fecha Inicio de Sesion: $logonTime, Direccion IP: $logonIp"
}