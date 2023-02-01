# Pegar o Provider no site da Hashicorp - https://registry.terraform.io/browse/providers
# Selecionar o Provider e ir em Documentação
# Colocar o Bloco de Provider, salvar e rodar o comando terraform init, assim sendo inicializado o terraform
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
#variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  # Variavel Token é o token de API criado no provider, para poder acessar e gerenciar os serviços
  token = var.do_token
}

# Todos os blocos necessários para criação de algum objeto do provider, deve ser pego no endereço do registry terraform - https://registry.terraform.io/
# Selecionar o provider e em sua documentação, selecionar os resources que serão utilizados
# exemplo a baixo coletado do registry, criando um Droplet na digital ocean

# Create a new Web Droplet in the nyc1 region
resource "digitalocean_droplet" "jenkins" {
  image  = "ubuntu-22-04-x64"
  name   = "jenkins"
  region = var.region
  size   = "s-2vcpu-2gb"
  # Adiciona a chave SSH já criada e adicionada no provider, para a máquina a ser criada no terraform
  ssh_keys = [data.digitalocean_ssh_key.SSH_JornadaDevops.id]
}

# Bloco de continuação para adição da chave já criada em nuvem, para a máquina
data "digitalocean_ssh_key" "SSH_JornadaDevops" {
  name = var.SSH_key_name
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

## Definindo Variaveis
variable "do_token" {
  default = ""
}

variable "region" {
  default = ""
}

variable "SSH_key_name" {
  default = ""
}

output "jnkins_IP" {
value = digitalocean_droplet.jenkins.ipv4_address 
}

resource "local_file" "CreateLocalFile" {
content = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
filename = "/home/luisbianconi/.kube/config"
}



