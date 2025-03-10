# Bovespa

## Criação da Infra

No Ubuntu ou CloudShell:

1) Instalar o Terraform:

	sudo apt update && sudo apt install -y wget unzip
	wget https://releases.hashicorp.com/terraform/1.11.1/terraform_1.11.1_linux_amd64.zip
	unzip terraform_1.11.1_linux_amd64.zip
	sudo mv terraform /usr/local/bin/


2) Criar o arquivo que conterá as credenciais:

	mkdir -p ~/.aws
	vim ~/.aws/credentials


3) Adicionar as credenciais do AWS CLI presentes no AWS Details do AWS Academy Lab e salvar o arquivo
(as credenciais mudam a cada 4 horas)

4) Instalar e configurar o Git

5) Fazer o clone do projeto

6) Entrar em cada subpasta da pasta "./infra" e executar os seguintes comandos para criar os serviços na ordem: S3, Glue, Lambda e EC2 
	terraform init
	terraform plan
	terraform apply


Obs: 
- Alterar o nome do bucket do S3, pois é necessário ser único
- Para acessar a EC2 é necessário configurar um par de chaves pública/privada, o nome deve ser ec2_fiap.pem