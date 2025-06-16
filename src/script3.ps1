$nombreFichero = Read-Host "Introduce el nombre del fichero"

Get-ChildItem -Path C:\ -Recurse -File -Filter $nombreFichero -ErrorAction SilentlyContinue | Select-Object -ExpandProperty DirectoryName
