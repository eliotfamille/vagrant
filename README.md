```markdown
# 🛒 Mada-Vanille — Infrastructure de Développement Reproductible

Ce dépôt contient l'infrastructure automatisée sous **Vagrant / Ubuntu 22.04 LTS** pour le déploiement local du site e-commerce *Mada-Vanille* (propulsé par PrestaShop 8.1.4).

L'objectif de ce projet est la **reproductibilité totale** via l'approche *Infrastructure as Code* (IaC) : n'importe quel développeur peut détruire et reconstruire un serveur Web complet (Nginx, PHP 8.1, MySQL, PrestaShop) pré-configuré, en une seule commande.

---

## 📂 Structure du dépôt

```text
├── README.md       # Le guide que vous êtes en train de lire
├── Vagrantfile     # Recette matérielle (Ubuntu 22.04, 2 Go RAM, 3 vCPUs, Provider : Libvirt)
└── setup.sh        # Recette logicielle Bash (Nginx, PHP-FPM, MySQL, PrestaShop 8.1.4)

```

---

## 📋 Prérequis (Machine Hôte)

Votre machine physique (l'hôte) doit tourner sous un environnement Linux (Debian/Ubuntu). Étant donné que le projet est configuré pour utiliser **Libvirt (KVM)** pour de meilleures performances natives, installez les dépendances nécessaires :

```bash
# 1. Mise à jour des dépôts
sudo apt update

# 2. Installation de Git, Vagrant et des outils de virtualisation QEMU/KVM
sudo apt install -y git vagrant qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils ruby-libvirt

# 3. Installation du plugin Vagrant pour Libvirt
vagrant plugin install vagrant-libvirt

```

*Vérifiez que l'installation a réussi :*

```bash
vagrant --version
virsh --version

```

---

## 🚀 Démarrage rapide (Quickstart)

### 1. Récupérer le projet

```bash
git clone [https://github.com/eliotfamille/vagrant.git](https://github.com/eliotfamille/vagrant.git)
cd vagrant

```

### 2. Lancer l'infrastructure

Lancez simplement la commande suivante. Vagrant va créer la machine virtuelle, configurer le réseau privé et exécuter automatiquement le script `setup.sh` (provisioning) :

```bash
vagrant up

```

*(Le processus prend environ 2 à 3 minutes selon la vitesse de votre connexion internet pour le téléchargement de PrestaShop).*

---

## 🌐 Accéder au site

Grâce à l'automatisation complète du script de provisionnement, la boutique est immédiatement opérationnelle sans aucune action manuelle requise.

* 🛒 **Boutique (Front Office) :** [http://192.168.121.45](http://192.168.121.45)
* ⚙️ **Administration (Back Office) :** L'adresse exacte dépend du dossier secret généré (ex: `http://192.168.121.45/admin123xyz`). Consultez la fin des logs de `vagrant up` pour récupérer l'URL dynamique.

### 🔑 Identifiants par défaut :
* **Utilisateur :** `admin@madavanille.local`
* **Mot de passe :** `password1234`

---

## 🧪 Tester la reproductibilité (Crash Test)

Pour valider l'exigence de résilience et de reproductibilité du projet :

1. **Simulez une panne ou une destruction totale du serveur :**
```bash
vagrant destroy -f

```


*(À ce stade, le site http://192.168.121.45 n'est plus accessible).*
2. **Recréez l'infrastructure à l'identique à partir de zéro :**
```bash
vagrant up

```


*(Rafraîchissez votre page web : le serveur, Nginx, la base de données et PrestaShop sont de retour, configurés exactement de la même manière sans intervention humaine).*

---

## 🛠️ Commandes utiles au quotidien

* **Se connecter au serveur en SSH :**
```bash
vagrant ssh

```


* **Mettre la machine en pause** *(sauvegarde l'état de la RAM)* :
```bash
vagrant suspend

```


* **Réveiller la machine mise en pause :**
```bash
vagrant resume

```


* **Éteindre proprement le serveur virtuel :**
```bash
vagrant halt

```


* **Forcer la réexécution du script d'installation :**
```bash
vagrant provision

```
