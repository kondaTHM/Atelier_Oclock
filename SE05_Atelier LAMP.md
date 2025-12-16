# E06 - Atelier LINUX LAMP + GLPI

## Étape 1 : VM Debian

> Installation de la VM avec l'ISO : Debian 12.8.0 Net Install


1. Case environnement de bureau Debian décoché !
2. GNOME décoché !
3. Case du serveur SSH coché

![alt text](images/image-81.png)

> Nous n'avons pas besoin d'un environnement de bureau : il n'y a pas d'écran connecté à un serveur ! On s'y connecte en général avec le protocole SSH.

## Étape 2 : sudo

```
root@debian:~# su -
root@debian:~# apt update
root@debian:~# apt install sudo
root@debian:~# usermod -aG sudo konda

```

>L'installation de la commande SUDO et rajout de l'user "konda" est bien dans le groupe SUDO.

![alt text](images/image-82.png)

>L'installation de la commande SUDO et rajout de l'user "konda" est bien dans le groupe SUDO.

```
root@debian:~# sudo -l
```
![alt text](images/image-83.png)


```
root@debian:~# sudo nano /etc/network/interfaces
```

![alt text](images/image-84.png)

> Les tests sont concluants, l'étape SUDO est ok ! et validé ! 

## Étape 3 : Guest Additions

> Installons les Guest Additions de VM ware.

![alt text](images/image-85.png)

> reboot de la VM avec la commande et vérification que la module du noyau est chargé avec la commande 

![alt text](images/image-86.png)

## Étape 4 : Apache

> Installation de apache2, et carte réseau en mode bridge pour être sur le même réseau que l'hôte.

![alt text](images/image-87.png)

## Étape 5 : MariaDB

> installation du serveur de base de donnée MARIADB et création de l'user 'dbuser' dans le shell mysql.

![alt text](images/image-88.png)

-> le service Maria DB est bien lancé automatiquement :

![alt text](images/image-89.png)

## Étape 6 : PHP

> installation de l'interpréteur PHP ainsi que les modules PHP. Le fichier est bien visible depuis mon hôte avec les informations techniques.


![alt text](images/image-90.png)

## Étape 7 : Connexion SSH

> installation de Putty et connection en SSH sur la machine VM LAMP

![alt text](images/image-91.png)

> Connection depuis l'hôte Windows via cmd en connection ssh 

![alt text](images/image-92.png)

## Étape 8 : GLPI

> Téléchargement du repo GLPI et archive décompression dans /var/www/html , glpi accessible.

![alt text](images/image-93.png)

> Problème de permissions dans le dossier /var/www/html ! corrigé avec les commandes 2 et 3

![alt text](images/image-94.png)

1. Initialisation de la base de données
![alt text](images/image-95.png)

2. Creation d'une nouvelle base de données nommée glpi

![alt text](images/image-96.png)

3. Première connexion, utilisez le nom d'utilisateur glpi et le mot de passe glpi 

![alt text](images/image-97.png)

4. GLPI opérationnel 🎉
![alt text](images/image-98.png)

## Bonus : PHPMyAdmin & Adminer

> installation de PHPMyAdmin pour administrer ma base de donnée MySQL et connection : 

![alt text](images/image-99.png)

> installation de Adminer et connection au panel admin

![alt text](images/image-100.png)

## Super-bonus : sécurité

> Resolution des problèmes de sécurité indiqués lors de l'installation.
> les Messages d'erreurs sont présentes dans configuration / système de GLPI : 

![alt text](images/image-101.png)

1.  Première erreur : 
***Web server root directory configuration is not safe as it permits access to non-public files. See installation documentation for more details.Web server root directory configuration is not safe as it permits access to non-public files***

> le problème de sécurité , Dossier files accessible depuis le web !

 ![alt text](images/image-102.png)

 2.  Correction de l'erreur et sécurisation des dossiers : 

```
sudo nano /etc/apache2/sites-available/000-default.conf
```
> rajout du morceau de code dans le fichier pour que apache ne pointe que dans le dossier public 

```
Alias "/glpi" "/var/www/html/glpi/public"

<Directory "/var/www/html/glpi/public">
    Require all granted
    AllowOverride None

    RewriteEngine On
    RewriteBase /glpi
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [QSA,L]
</Directory>
```
```
sudo systemctl restart apache2
```
> la dossier FILES n'est plus accessible ! 

![alt text](images/image-103.png)

> le message d'erreur n'est plus visible dans configuration/générale de GLPI :

![alt text](images/image-104.png)

3.  deuxième erreur : ***directive "session.cookie_httponly" should be set to "on" to prevent client-side script to access cookie values.PHP directive "session.cookie_httponly" should be set to "on" to prevent client-side script to access cookie values.***

4. Correction de l'erreur "session.cookie_httponly" 

> Allez dans le fichier /etc/php/8.2/apache2/php.ini et modifier la valeur par session.cookie_httponly = on et restart le service apache2

![alt text](images/image-105.png)

> l'erreur n'est plus présente dans configuration/générale de GLPI

![alt text](images/image-106.png)


5. Correction de l'erreur Timezone seems not loaded.

> utilisation de la commande présente dans la document de le GLPI ci-dessous 

https://glpi-install.readthedocs.io/en/latest/timezones.html

```
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -p -u root mysql

```

# 🏆Fin du Super-bonus : sécurité !!! 🏆

> Mise en place des régles de sécurité, suppression du fichier install.php et enfin changements de mot de passe ou/et désactivation des nouveaux profils.

![alt text](images/image-107.png)
![alt text](images/image-108.png)

# Hyper-bonus : configuration de GLPI

Adresse IP du serveur LAMP : 192.168.1.29/24
Adresse IP du la machine WINDOWS Client "Win11 : 192.168.1.20/24

> installation de l'agent et configuration sur la machine VM Windows 11 cliente :

![alt text](images/image-111.png)

> VM win10 bien présente sur le tableau de bord de GLPI

![alt text](images/image-110.png)
![alt text](images/image-109.png)