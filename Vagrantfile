Vagrant.configure("2") do |config|
    config.vm.define "caipirinha" do |drink|
      #box Xubuntu mais recente
      drink.vm.box = "gusztavvargadr/xubuntu-desktop-2404-lts"
      drink.vm.box_version = "2404.0.2409"
      drink.vm.provider "virtualbox" do |vb|
        vb.memory = "6144"  # Define 6GB de memória
      end
      #Configura o ip básico da vm
      drink.vm.network "private_network", ip: "192.168.56.50"
      #Nome da vm
      drink.vm.hostname = "caipirinha"
  
      # Checando se o configura.sh existe localmente
      if File.exist?("configura.sh")
        drink.vm.provision "file", source: "configura.sh", destination: "/home/vagrant/configura.sh"
      else
        abort "configura.sh não encontrado. Verifique se o script está no diretório atual."
      end
  
      # Checando o arquivo de instalação do localstack, nesse caso localstack-cli-4.0.0-linux-amd64-onefile.tar.gz
      if File.exist?("/home/renato/VirtualBox VMs/001-Server/localstack-cli-4.0.0-linux-amd64-onefile.tar.gz")
        drink.vm.provision "file", source: "/home/renato/VirtualBox VMs/001-Server/localstack-cli-4.0.0-linux-amd64-onefile.tar.gz", destination: "/home/vagrant/localstack-cli.tar.gz"
      else
        abort "Arquivo do LocalStack não encontrado. Certifique-se de que está no diretório atual."
      end
  
      # Checando o pacote do VS Code(.deb) existe
      if File.exist?("/home/renato/VirtualBox VMs/001-Server/code_1.95.3-1731513102_amd64.deb")
        drink.vm.provision "file", source: "/home/renato/VirtualBox VMs/001-Server/code_1.95.3-1731513102_amd64.deb", destination: "/home/vagrant/code_1.95.3-1731513102_amd64.deb"
      else
        abort "Arquivo do VS Code .deb não encontrado. Certifique-se de que está no diretório atual."
      end
  
      # Provisionamento da máquina virtual
      drink.vm.provision "shell", inline: <<-SHELL
        # Instalar pacotes essenciais para o ambiente, nesse caso prereqs para rodar docker/localstack e o terraform-local
        sudo apt-get update -y ;
        sudo apt-get install -y ca-certificates curl gnupg lsb-release software-properties-common unzip wget python3.12 python3.12-venv python3-pip gdebi-core aws-cli 
  
        # Criar o usuário renato (somente se não existir)
        if ! id -u renato > /dev/null 2>&1; then
          sudo useradd renato
          sudo usermod -aG sudo renato
          sudo usermod -s /bin/bash renato
          sudo mkdir /home/renato
          sudo chown renato:renato /home/renato
          sudo echo 'renato:renato' | chpasswd renato
        fi
  
        # Tornar o configura.sh executável na vm e executa em seguida
        chmod +x /home/vagrant/configura.sh
        sudo bash /home/vagrant/configura.sh || { echo "Erro ao executar configura.sh"; exit 1; }
  
        # Instalar o VS Code a partir do .deb
        sudo gdebi -n /home/vagrant/code_1.95.3-1731513102_amd64.deb
  
        # Extrair e instalar o LocalStack CLI
        sudo tar -xvzf /home/vagrant/localstack-cli.tar.gz -C /usr/local/bin
        sudo chown root:root /usr/local/bin/localstack
      SHELL
    end
  end
  