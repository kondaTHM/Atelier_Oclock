SA2 : Atelier Mme Michu


# Consigne Étape 1 : Réparer le démarrage de Windows
Problème rencontré : L’ordinateur de Madame Michu refuse de démarrer correctement, avec des messages tels que « BootMGR est manquant » ET « Winload.exe introuvable », son petit-fils a testé des trucs, donc il n’y a plus les messages mais le problème est le même, donc ne t’en fais pas si tu ne vois pas les mêmes messages !

Si je peux te donner un conseil, fais attention aux partitions et également au lecteur, si tu avances dans ton diagnostic, peut-être que tu vas t’emmêler les pinceaux avec le C: D: E: F: G: etc… donc prends le temps de bien repérer ton lecteur !

Résous ce problème pour permettre à Windows de démarrer normalement.

### SOLUTION ETAPE 1 

J'ai boot dans l'EFI, rien à signaler et vérifier les bootdevis sur VBOX

![alt text](image-16.png)
![alt text](image-18.png)

Je rajoute un périphérique lecteur optique avec l'iso d'un window 10 d'install sur VBOX
J'essaye de lancer l'outil de redémarrage systeme pour une tentative de réparation.

![alt text](image-14.png)

C'est un ECHEC.


je tente une réparation manuelle via CMD : 

lancement de diskpart : 

![alt text](image-15.png)

je note que le disque C est réserve au system 
je selection le volume 1 disque C , et il est active 

tentative de la réinstallation en conservant les données 
![alt text](image-20.png)

![alt text66image-21.png)

![alt text](image-22.png)

![alt text](image-23.png)




réparer le boot mgr via invite de commande , échec ! 
![alt text](image-24.png)

Avec mes talents de googleur PRO j'ai trouvé une astuce 

![alt text](image-25.png)
![alt text](image-26.png)

je refais la manipulation sur l'autre disque , le numéro 1 :

![alt text](image-27.png)

OS device m'indique la letre du lecteur de windows ; ici c'est E: 

![alt text](image-28.png)

![alt text](image-29.png)

# deuxième problème : manque winnload.exe 

![alt text](image-30.png)


1- test avec l'outil de remarrage systeme auto avec windows 10 à plusieurs reprises :
boot OK 
![alt text](image-31.png)

![alt text](image-32.png)


# Consigne Étape 2 : Restaurer les performances normales de la machine
Problème rencontré : Une fois sur le Bureau, Madame Michu constate que son processeur et sa RAM sont utilisés à 100 %, rendant l’ordinateur très lent.

Diagnostique et résous ce problème pour restaurer les performances optimales.

Il y a plusieurs solutions je pense, mais si tu arrives à restaurer les performances de son PC, l’étape est réussie !

### SOLUTION ETAPE 2

![alt text](image-44.png)
![alt text](image-34.png)
![alt text](image-33.png)
![alt text](image-35.png)
![alt text](image-38.png)

je force la fermeture des processs ping.exe
taskkill /F /IM ping.exe

perfomance pc après le kill de ping.exe pour avoir un peu de ressources pour bosser ! 

vérification de startup shell 

C:\Users\Mme Michu\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
shell:startup via Exécuter 

script qui lance des pings en continu , suppression du script et redemarrage de la machine

![alt text](image-45.png)



![alt text](image-40.png)

# Consigne Étape 3 : Vérifier l’état des disques durs
Problème rencontré : Madame Michu s’inquiète de l’état de ses disques durs. Oui, elle a 2 disques d’après ce qu’elle m’a dit, à vérifier donc si tout va bien de ce côté-là.

Vérifie les disques pour détecter d’éventuels problèmes et corrige-les si nécessaire.



### SOLUTION ETAPE 3

Je suis aller dans le gestionnaires de disques et j'ai vérifié de l'état du disque 2 : 
Le disque est hors ligne , je dois le mettre en ligne.

![alt text](image-39.png)

je suis passer par CMD , puis diskPart et ensuite san pour mettre tout les disques en ligne : 

![alt text](image-41.png)

vérification des deux disques pour corriger les erreurs, ok  :  

![alt text](image-42.png)



# Consigne  Étape 4 : Retrouver les fichiers disparus dans le dossier « Images »
Problème rencontré : Des fichiers ont mystérieusement disparu dans le dossier « Images » de Madame Michu.

Retrouve et restaure ces fichiers pour elle.

### SOLUTION ETAPE 4

Je récupère les données sur le second disque dur, et remets le dossier "YORK" dans le dossier image de la machine.

![alt text](image-43.png)