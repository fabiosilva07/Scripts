# Função para instalar o Winget, caso não esteja instalado
function Install-Winget {
    $wingetInstalled = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wingetInstalled) {
        Write-Host "Winget não está instalado. Iniciando a instalação..."
        # Faz o download do pacote do Winget da PowerShell Gallery
        $wingetPackage = Find-Package winget
        if (-not $wingetPackage) {
            Install-PackageProvider -Name NuGet -Force
            Install-Module -Name PowerShellGet -Force
            Install-Module -Name winget -Force
        } else {
            $progressPreference = 'silentlyContinue'
            Write-Information "Downloading WinGet and its dependencies..."
            Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
            Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
            Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
            Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
            Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
            Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

            Remove-Item –Path .\Microsoft.VCLibs.x64.14.00.Desktop.appx
            Remove-Item –Path .\Microsoft.UI.Xaml.2.7.x64.appx
            Remove-Item –Path .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        }
    } else {
        Write-Host "Winget já está instalado. Procedendo com a instalação dos aplicativos..."
    }
}
# Função para instalar uma lista de programas usando o Winget
function Install-AppsUsingWinget {
    $apps = @(
        "Google Chrome"
        "AdobeAcrobatReader"
        "7zip"
        "Java 8"
        "CutePDF Writer"
        # Adicione mais aplicativos aqui, se necessário
    )

    foreach ($app in $apps) {
        Write-Host "Instalando $app..."
        winget install $app --accept-source-agreements
    }
}

# Verifica e instala o Winget, se necessário
Install-Winget

# Instala a lista de programas usando o Winget
Install-AppsUsingWinget

#Copiar pasta para a raiz do disco C
Copy-Item -Path ".\appgate" -Destination "C:\appgate" -Recurse

#COMANDO DE INSTALAÇÂO DO APPGATE REMOVIDO POR SEGURANÇA

#Instalando outros apps
Start-Process ".\agent_cloud_x64.msi" -Wait

Start-Process ".\E85.20_CheckPointVPN.msi" -Wait

Start-Process ".\Makrolock\MakroClientInstaller.exe" -Wait

Start-Process ".\SM\AgenteSM.exe"

#Pegando o nome da maquina
#$hostname = Get-ChildItem Env:USERDOMAIN
#$realhostname = $hostname.Value

#Criando arquivo com chave de recuperacao BitLocker
#New-Item ".\BITLOCKER - $realhostname.txt"

#Ativando BitLocker
#Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector > ".\BITLOCKER - $realhostname.txt"

Write-Host "Instalação dos aplicativos concluída com sucesso!"
