# Tech Challenge - Pipeline Batch Bovespa

Este projeto tem como objetivo automatizar a coleta, o processamento e a análise de dados do pregão da B3 (Bovespa), utilizando uma arquitetura baseada em serviços da AWS. A solução foi desenvolvida para garantir a ingestão eficiente dos dados e disponibilizá-los para consulta via Amazon Athena

## Arquitetura do Projeto

![Arquitetura do Projeto](https://github.com/polizelr/tech_challenge2_bovespa/blob/main/dados/arquitetura.png?raw=true)


O pipeline segue a seguinte estrutura:

1. **Coleta de Dados**: O script Python `scraping.py` é responsável por obter os dados do site oficial da B3. Para isso, utiliza a biblioteca Selenium e é agendado via `crontab` para execução de segunda a sexta-feira às 18h em uma instância EC2.

   
2. **Armazenamento no Amazon S3**: Os dados brutos são armazenados no formato Parquet, particionados pela data de referência no formato `yyyy-MM-dd`, no caminho `s3://fiap-mle-tc2/raw/dados_bovespa/`.

3. **Disparo de Função AWS Lambda**: A adição de novos arquivos ao S3 aciona automaticamente uma função AWS Lambda, que inicia o processamento do job no AWS Glue.

4. **Processamento com AWS Glue**:
   - O job do Glue executa as seguintes transformações:
     - Agregação de dados numéricos;
     - Renomeação de colunas para maior clareza e padronização;
     - Cálculo de diferenças entre datas para análise temporal.
    
5. **Armazenamento no Amazon S3**: Os dados processados são armazenados em `s3://fiap-mle-tc2/refined/bovespa/`, no formato Parquet, particionados pela data de referência `yyyy-MM-dd` e pelo nome da ação.

6. **Catalogação no AWS Glue**: Os dados refinados são automaticamente catalogados no Glue Catalog. Um crawler foi configurado para ser executado a cada 10 minutos, garantindo que as tabelas estejam sempre atualizadas.

7. **Consulta via Amazon Athena**: Os dados podem ser acessados e analisados diretamente no console do Amazon Athena, utilizando consultas SQL para obtenção de insights e relatórios.


## Como Executar o Projeto

Toda a infraestrutura foi desenvolvida utilizando o **Terraform**. Para executar o projeto, siga os passos abaixo:

### 1. Instalar o Terraform

Execute os seguintes comandos para instalar o Terraform:

```bash
sudo apt update && sudo apt install -y wget unzip
wget https://releases.hashicorp.com/terraform/1.11.1/terraform_1.11.1_linux_amd64.zip
unzip terraform_1.11.1_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### 2. Configurar as Credenciais da AWS

Crie o arquivo que conterá as credenciais da AWS:

```bash
sudo apt update && sudo apt install -y wget unzip
wget https://releases.hashicorp.com/terraform/1.11.1/terraform_1.11.1_linux_amd64.zip
unzip terraform_1.11.1_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

Adicione as credenciais do **AWS CLI** presentes no **AWS Details** do **AWS Academy Lab** e salve o arquivo.

`**Atenção: As credenciais mudam a cada 4 horas.**`

### 3. Instalar e Configurar o Git

Certifique-se de que o Git está instalado e configurado corretamente no seu ambiente.

### 4. Clonar o Projeto

Faça o clone do projeto:

```bash
git clone https://github.com/polizelr/tech_challenge2_bovespa.git
```

### 5. Implantar a Infraestrutura na AWS

Navegue até cada subpasta dentro da pasta `./infra` e execute os seguintes comandos para criar os serviços na AWS:

```bash
terraform init
terraform plan
terraform apply
```

**Observação:**
   - O comando `terraform init` inicializa o diretório do Terraform.
   - O comando `terraform plan` exibe um plano de execução das mudanças que serão aplicadas.
   - O comando `terraform apply` aplica as mudanças e cria os recursos na AWS.

	


