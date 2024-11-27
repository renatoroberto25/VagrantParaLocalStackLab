#!/bin/bash

# Adiciona a chave oficial do Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Adiciona o repositório do Docker (ajustando para Ubuntu)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instala Docker e outras ferramentas necessárias
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

# Instala o Terraform
sudo apt install gnupg software-properties-common -y;
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg;
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list;
sudo apt update;
sudo apt install terraform -y

# Configurações de AWS LocalStack
mkdir -p /home/renato/.aws
cat > /home/renato/.aws/config <<EOL
[profile localstack]
region = us-east-1
output = json
endpoint_url = http://localhost:4566
EOL
cat > /home/renato/.aws/credentials <<EOL
[profile localstack]
aws_access_key_id = gordao
aws_secret_access_key = gordao
EOL
sudo chown -R renato:renato /home/renato/.aws

# Criar diretório e ambiente virtual Python
mkdir -p /home/renato/TERRAFORM
cd /home/renato/TERRAFORM
python3.12 -m venv TerraNova
python3.12 -m ensurepip --upgrade
#No env TerraNova eu instalo o tf: pip install terraform-local
# Permissões
sudo chown -R renato:renato /home/renato/TERRAFORM

# Adiciona o usuário 'renato' ao grupo Docker
sudo groupadd docker
sudo usermod -aG docker renato
sudo chmod 666 /var/run/docker.sock

# Configurações de idioma pt-BR
sudo apt-get install -y language-pack-pt language-pack-gnome-pt
sudo apt-get remove -y language-pack-en language-pack-gnome-en

# Configurações de teclado
sudo bash -c 'cat > /etc/default/keyboard <<EOL
XKBMODEL="abnt2"
XKBLAYOUT="br"
XKBVARIANT=""
XKBOPTIONS=""
EOL'
sudo setxkbmap -model abnt2 -layout br
sudo dpkg-reconfigure locales
sudo localectl set-keymap br-abnt2

# Configuração de timezone
sudo timedatectl set-timezone America/Sao_Paulo

# Configuração de alguns aliases que eu uso
sudo bash -c 'cat >> /etc/bash.bashrc <<EOL

# Aliases customizados
alias ll="ls -l"
#abaixo o que eu costumo usar para localstack
alias aws="aws --endpoint-url=http://\$LOCALSTACK_HOST:4566"
EOL'

echo "Configuração concluída com sucesso!"
