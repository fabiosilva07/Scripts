# Verifica se o Chocolatey já está instalado
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    # Instala o Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Define uma lista de programas para instalar
$programs = @("googlechrome", "adobereader", "anydesk","ultravnc","libreoffice-fresh","7zip","javaruntime")

# Itera através da lista e instala cada programa usando o Chocolatey
foreach ($program in $programs) {
    choco install $program -y
}

#Criando e habilitando firewall para conexão VNC
New-NetFirewallRule -DisplayName "Allow UltraVNC 5900" -Direction Inbound -Protocol TCP -LocalPort 5900 -Action Allow

# Instala o programa .exe
Start-Process ".\ocspackage.exe" -Wait
Start-Process ".\sankhya.exe" -Wait
Start-Process ".\setupdownloader_[aHR0cDovLzEwLjE5LjEwLjMwOjcwNzQvUGFja2FnZXMvQlNUV0lOLzAvM1lzalFTL2luc3RhbGxlci54bWw-bGFuZz1wdC1CUg==].exe" -Wait

#Instalar como Servico
cd 'C:\Program Files\uvnc bvba\UltraVNC'

.\winvnc.exe -install

#Alterar senha de administrador
.\setpasswd.exe 123

#Reiniciar o servico
net stop uvnc_service

net start uvnc_service

#Informações do host
ipconfig

Write-Host "Instalação Finalizada!"

<#
# Altera o nome do host
$newName = Read-Host "Entre com o novo nome do host:"
Rename-Computer -NewName $newName -Force

# Flag para rastrear se as credenciais são válidas
$credenciaisValidas = $false

# Loop até que as credenciais válidas sejam fornecidas
while ($credenciaisValidas -eq $false) {
  # Solicitar ao usuário seu nome de usuário e senha
  $username = Read-Host "Digite seu nome de usuário"
  $password = Read-Host "Digite sua senha" -AsSecureString

  # Criar um objeto PSCredential com o nome de usuário e senha fornecidos
  $credential = New-Object System.Management.Automation.PSCredential($username, $password)

  # Tentar conectar-se ao domínio usando as credenciais fornecidas
  try {
    Add-Computer -DomainName "corp.grupopneubras.com" -Credential $credential -Force
    $credenciaisValidas = $true
  } catch {
    Write-Host "As credenciais fornecidas estão incorretas, por favor tente novamente."
  }
}

#Espera 3 segundos para reiniciar
Start-Sleep -Seconds 3
Restart-Computer
#>