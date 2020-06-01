# Scripts et programmes de sécurité



Ces scripts et programmes ont pour la plupart étés réalisés sur Centos 7, 8, Fedora 29, 30, 31 .



[TOC]



### Les différents scripts :

------- A Venir ------

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
make SecLocker && make secinstall
```
