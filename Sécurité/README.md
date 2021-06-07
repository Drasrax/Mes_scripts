# Scripts et programmes de sécurité



Ces scripts et programmes ont pour la plupart étés réalisés sur Centos 7, 8, Fedora 29, 30, 31 .


### Les différents scripts :

#### Definitive lock with fail2ban:
   

### Les programmes :


#### SecLocker :

##### Présentation :

SecLocker est un petit programme fait pour bloquer de façon réversible un périphérique USB , Bluetooth ou même wifi. Il est perfectible et nécessite des droits étendus (sudoers, wheel).

Il va agir sur le noyaux et déchargé ou chargé certains modules (selon l'opération faite, blocage ou déblocage).



Un reboot est obligatoire lors de chaque opération de blocage de périphérique !



##### Installation :



Pour l'installation vous devez disposer d'un compilateur (celui que j'utilise pour ce programme est tout simplement gcc ).

Si vous n'avez pas gcc et que vous souhaitez l'installer :

```bash
yum install gcc, cmake
```

Pour la compilation vous avez deux choix exécuté la commande suivante :

```bash
gcc -o seclocker seclocker.c
```



Ou via le fichier cmake :

```bash
make secLocker
```


#### Trackfic :

##### Présentation :
Trackfic est un outil de capture d'entrée et sortie des interfaces réseau d'une machine les données sont stockées dans le répertoire ../data/ il permet une analyse textuelle par la suite avec la possibilité de le parsé de façon simple afin de rechercher un éventuel trafic indésirable.

##### Installation :



Pour l'installation vous devez disposer d'un compilateur (celui que j'utilise pour ce programme est tout simplement gcc ).

Si vous n'avez pas gcc et que vous souhaitez l'installer :

```bash
yum install gcc, cmake
```

Pour la compilation vous avez deux choix exécuté la commande suivante :

```bash
gcc -o trackfic trackfic.c && mkdir ../data
```


Ou via le fichier cmake :

```bash
make trackfic
```
