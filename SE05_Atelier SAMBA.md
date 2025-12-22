# E06 - Atelier LINUX SAMBA

## Étape 1 : VM Debian 

> Installation de la VM DEBIAN sur vmb3 et ip 172.16.0.62/16

> 1. modification du fichier /etc/network/interfaces

```
alow-hotplug ens18
iface ens18 inet static
  address 172.16.0.62
  netmask 255.255.0.0
  network 172.16.0.0
  broadcast 172.16.255.255
  gateway 172.16.0.1
  dns-nameservers 8.8.8.8
  dns-search OCLOCK.LAN
  ```

> 2. modification du fichier /etc/hosts

  ```
  
172.16.0.62	debianSRV.OCLOCK.LAN
  ```
> 3. modification du fichier /etc/hostname 

  ```
debianSRV.OCLOCK.LAN
  ```

## Étape 2 : Samba





