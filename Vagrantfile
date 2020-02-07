# -*- mode: ruby -*-
# vi: set ft=ruby :

# read secrets from file
secrets = Hash.new
if File.file?("secrets/digitalocean.env")
  array = File.read("secrets/digitalocean.env").split("\n")
  array.each do |e|
    unless e.start_with?("#")
      var = e.split("=")
      secrets[var[0]] = var[1]
    end
  end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # local box
  config.vm.box = "ubuntu/bionic64"

  config.vm.define secrets["DO_DROPLET_NAME"]
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = secrets["DO_SSH_PRIVATE_KEY"]
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"

    provider.token = secrets["DO_TOKEN"]
    provider.image = 'ubuntu-18-04-x64'
    provider.region = secrets["DO_REGION"]
    provider.size = secrets["DO_SIZE"]
    provider.ssh_key_name = secrets["DO_SSH_KEY_NAME"]
  end

  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: [".git/", "secrets/digitalocean.env"]

  # docker / docker-compose provisioning
  config.vm.provision "shell", inline: <<-SCRIPT
    if ! type docker >/dev/null; then
        echo -e "\n\n========= installing docker..."
        curl -sL https://get.docker.io/ | sh
        echo -e "\n\n========= installing docker bash completion..."
        curl -sL https://github.com/docker/cli/raw/master/contrib/completion/bash/docker > /etc/bash_completion.d/docker
        adduser vagrant docker
    fi
    if ! type pip >/dev/null; then
        echo -e "\n\n========= installing pip..."
        curl -sk https://bootstrap.pypa.io/get-pip.py | python
    fi
    if ! type docker-compose >/dev/null; then
        echo -e "\n\n========= installing docker-compose..."
        curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
	chmod a+x /usr/local/bin/docker-compose
        echo -e "\n\n========= installing docker-compose command completion..."
        curl -sL https://raw.githubusercontent.com/docker/compose/$(docker-compose --version | awk 'NR==1{print $NF}')/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
    fi
  SCRIPT

  # TODO
  # provision the docker-compose automatically
  #config.vm.provision "shell", path: "provision.sh"
  #config.vm.provision "shell", inline: <<-SCRIPT
  #  docker-compose up -d
  #SCRIPT
end
