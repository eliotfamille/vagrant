```markdown
# 🛒 Mada-Vanille — Infrastructure de Développement Reproductible

Ce dépôt contient l'infrastructure automatisée sous **Vagrant / Ubuntu** pour le déploiement local du site e-commerce *Mada-Vanille* (propulsé par PrestaShop 8.1).

L'objectif de ce projet est la **reproductibilité totale** : n'importe quel développeur peut détruire et reconstruire un serveur Web complet (Nginx, PHP, MySQL, PrestaShop) pré-configuré, en une seule commande.

---

## 📂 Structure du dépôt

```text
├── README.md       # Le guide que vous êtes en train de lire
├── Vagrantfile     # Recette matérielle (OS, RAM, CPU)
└── setup.sh        # Recette logicielle Bash (Nginx, PHP, MySQL, DL PrestaShop)

```

```
---
## 📋 Prérequis (Machine Hôte)

Votre machine physique (l'hôte) doit tourner sous une distribution Linux basée sur Debian/Ubuntu. Ouvrez votre terminal et installez les dépendances nécessaires :

```bash
# 1. Mise à jour des dépôts
sudo apt update

# 2. Installation de Git, VirtualBox et Vagrant
sudo apt install -y git virtualbox vagrant

```

*Vérifiez que l'installation a réussi :*

```bash
vagrant --version
virtualbox --help | head -n 1

```

---

## 🚀 Démarrage rapide (Quickstart)

### 1. Récupérer le projet

```bash
git clone [https://github.com/eliotfamille/vagrant.git](https://github.com/eliotfamille/vagrant.git)
cd vagrant

```

### 2. Lancer l'infrastructure

```bash
vagrant up

```
Cree un fichier `setup.sh` et metes y le contenu de du fichier `setup.sh`
Autorisation pour le scipte
```bash
chmod +x setup.sh
```

---

## 🌐 Accéder au site

Une fois la commande `vagrant up` terminée (environ 2 à 3 minutes selon votre connexion internet), ouvrez votre navigateur web sur votre PC hôte :

👉 **http://192.168.121.45**

Vous arriverez directement sur l'assistant d'installation officiel de PrestaShop.

---

## 🧪 Tester la reproductibilité (Crash Test)

Pour vérifier que l'infrastructure est 100% résiliente :

1. **Simulez la destruction totale du serveur :**
```bash
vagrant destroy -f

```


*(Le site http://192.168.121.45 n'est désormais plus accessible).*
2. **Recréez l'infrastructure à l'identique :**
```bash
vagrant up

```


*(Rafraîchissez votre page web : le serveur est de retour).*

---

## 🛠️ Commandes utiles au quotidien

* **Se connecter au serveur en SSH :** ```bash
vagrant ssh
```

```


* **Mettre la machine en pause** *(sauvegarde l'état de la RAM)* :
```bash
vagrant suspend

```


* **Réveiller la machine mise en pause :**
```bash
vagrant resume

```


* **Éteindre proprement le serveur :**
```bash
vagrant halt

```

