# E06 - Atelier IPBX Asterisk sur Debian 13

## Étape 1 : installation Debian 13 sur proxmox 

![alt text](images/image-112.png)

## Étape 2 : sudo, IP statique & SSH



![alt text](images/image-113.png)

> Connection via ssh depuis mon hôte.

## Étape 3 : Installation d'Asterisk

![alt text](images/image-114.png)

## Étape 4 : Configuration d'Asterisk


![alt text](images/image-115.png)

###  Test de communication entre 2 users "123" sur pc hôte et "124" sur pc VM Windows proxmox  : 

![alt text](images/image-117.png)

![alt text](images/image-118.png)


##  Bonus :

> messagerie/boîte vocale

Modification du fichier voicemail.conf : 
nano /etc/asterisk/voicemail.conf

![alt text](images/image-119.png)

Modification du fichier extensions.conf : 
sudo nano /etc/asterisk/extensions.conf

![alt text](images/image-120.png)

> test de communication , messagerie ok après 10 seconde ! 

![alt text](images/image-121.png)