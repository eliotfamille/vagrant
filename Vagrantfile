Vagrant.configure("2") do |config|
  # Image de base
  config.vm.box = "generic/ubuntu2204"
  # Desactive la generation d'une cle unique locale
  config.ssh.insert_key = false
  # Nom du vm
  config.vm.define "MadaVanille_PrestaShop" do |machine|
  # Configuration du vm
    machine.vm.provider :libvirt do |lv|
      lv.default_prefix = "" # Evite le prefixe du nom de dossier
      lv.memory = "2048"  # Ram du vm
      lv.cpus = 3         # Nombre de cpu
    end
    machine.vm.network "private_network",
      ip: "192.168.121.45",
      libvirt__network_name: "network"
  end
end
