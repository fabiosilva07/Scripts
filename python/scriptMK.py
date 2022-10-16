# Script para execução em massa de comandos SSH em hosts
# Para executar esse script é necessario ter o python3 instalado junto da bibliotecas necessarias
# python3 e python-pip, normalmente já estão instalados junto da instalação do python
#
# É preciso instalar as dependencias de import com o pip
# pip install paramiko os getpass
# Após isso ter o arquivo com os IP's dos hosts no mesmo diretorio deste script
# O nome do arquivo deve ter o nome 'mikrotiks.txt'
#
#Com tudo isso é só executar o script

import paramiko # Para conexão SSH
import os # Para realizar o ping
import getpass # Para capturar a senha sem exibir os caracteres

#Função para conectar nos MKs
def connectMK(host,login,senha,porta):
    try:
        client = paramiko.client.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(host, username=login, password=senha, port=porta)
        _stdin, _stdout,_stderr = client.exec_command(comand)
        print(f'{host} Executado com sucesso!!')
        client.close()
    except:
        print('Erro Conexão SSH, verifique dados e sua conexão!')

#Script Python para executar comando nos mikrotiks
print('##############################################################')
print('Bem vindo ao meu Script de execução de comandos em Mikrotiks!!')
print('##############################################################')

#Capturando o comando a ser executado e atribuindo a variavel
print('Por favor, digite o comando que deseja executar em massa.')
comand = input()

#Capturando a Porta de acesso
print('Digite a porta SSH para realizar a conexão')
porta = input()

#Capturando Login e senha de acesso ao Mikrotiks
print('Digite o Login de acesso aos MKs.')
login = input()
print('Digite a senha de acesso aos MKs.')
senha = getpass.getpass()

#Lendo o arquivo e tranformando em uma lista para o FOR
try:
    with open("mikrotiks.txt", "r") as mikrotiks:
        hosts = mikrotiks.read().split()
except:
    print('Erro no arquivo!!')

#Percorrendo a lista de Hosts para executar o comando
for host in hosts:
    #Testando ping para o host
    response = os.system(f'ping -c 1 {host}')

    if response == 0:#Bloco caso o host esteja acessivel
        connectMK(host,login,senha,porta)
    else: # Bloco quando o host está inacessivel
        print(f'{host} inacessivel!')
