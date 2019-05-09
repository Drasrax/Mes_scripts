#!/bin/bash

command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"


check_retour()
    {
        if [ $? -eq "0" ]
        then
            command echo -e "[\e[92mOk\e[39m]"
        else
            command echo -e "[\e[91mFailed\e[39m]"
       fi

    }

create_logfiles()
    {
        command mkdir /var/log/install_katello
        command touch /var/log/install_katello/install.log
        command touch /var/log/install_katello/errors.log
        command touch /var/log/install_katello/adm.log
    }

machine_config()
    {
        command echo -n "---- Config du hostname ----       "
        check_retour
        command hostnamectl set-hostname katello.1.local &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        command echo "192.168.1.26 katello.solvetic.local solvetic" >> /etc/hosts &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        command echo -n "---- Configuration du firewall ----       "
        command firewall-cmd --permanent --zone=public --add-port=80/tcp --add-port=443/tcp --add-port=5647/tcp --add-port=9090/tcp &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        command firewall-cmd --permanent --zone=public --add-port=8140/tcp --add-port=8443/tcp --add-port=8000/tcp --add-port=67/udp --add-port=68/udp --add-port=69/udp &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
        command echo -n "---- Reload firewalld ----     " 
        command firewall-cmd –reload &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
        command echo -n "---- Config NTP ----       "
        check_retour
        command yum install -y ntp &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        command systemctl restart ntpd &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        command timedatectl set-timezone Europe/Madrid &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log

    }

yum_config()
    {
        command echo -n "---- Install des yum-utils ----     "
        command yum install -y yum-utils &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
    }

yum_repo_conf()
    {
        command echo -n "---- Repo lastest katello ----     "
        command yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.11/katello/el7/x86_64/katello-repos-latest.rpm &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
        command echo -n "---- Foreman repo ----        "
        command yum -y localinstall https://yum.theforeman.org/releases/1.21/el7/x86_64/foreman-release.rpm &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
        command echo -n "---- Puppet repo ----     "
        command yum -y localinstall https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm  &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
        command echo -n "---- Repo epel ----       "
        command yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
        command echo -n "---- Installation foreman-release-scl ----        "
        command yum -y install foreman-release-scl &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
    }

upgrade_distro()
    {
        command echo -n "---- Upgrade distro ----      "
        command yum -y update &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
    }

install_katello_pack()
    {
        command echo "---- Installation du pack Katello et ses dependances ----"
        command echo "---- Cette operation prend du temps ----"
        command echo "---- Vous pouvez aller boire un café : ----"
        command echo "         ,-\"-."
        command echo "       _r-----i          _"
        command echo "       \      |-.      ,###."
        command echo "        |     | |    ,-------."
        command echo "        |     | |   c|       |                       ,--."
        command echo "        |     |'     |       |      _______________ C|  |"
        command echo "        (=====)      =========      \_____________/  \`=='   cww"
        command echo "(HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH)"
        command echo -n "----- Status -----     "
        command yum -y install katello &> /var/log/install_katello/install.log 2> /var/log/install_katello/errors.log
        check_retour
    }

Katello_config()
    {
        command echo -n "---- Configuration de Katello (scenario basique) ----      "
        command foreman-installer --scenario katello  2> /var/log/install_katello/errors.log
        check_retour
    }

Katello_adm_passwd()
    {
        command echo -n "---- Modification du compte admin ----     "
        foreman_adm=$(foreman-rake permissions:reset 2> /var/log/install_katello/errors.log | grep "password:" | cut -d ':' -f3 | cut -d ' ' -f2 >> /var/log/install_katello/adm.log)
        check_retour
        command echo -e "Utilisateur:   admin \nMot de passe:   $foreman_adm \nCe mot de passe est sauvegrdé dans /var/log/install_katello/adm.log. \nPensez a supprimé le fichier une fois le mot de passe noté."

    }

echo "###### Création des fichiers de logs"
create_logfiles
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"
command echo "###### Configuration de la machine... ######"
command echo "\n \n"
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
machine_config
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"
command echo "###### Configuration du packager ######"
command echo "\n \n"
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
yum_config
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"
command echo "###### Configuration des repositories ######"
command echo "\n \n"
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
yum_repo_conf
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"
command echo "###### Upgrade de la distribution ######"
command echo "\n \n"
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
upgrade_distro
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"
echo "###### Installation du package katello ######"
command echo "\n \n"
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
install_katello_pack
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"
command echo "###### Katello config (scenario de base) ######"
command echo "\n \n"
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
Katello_config
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Katello\e[49m ###############"
command echo "########################################################"
command echo "###### Configuration des users ######"
command echo "\n \n"
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
Katello_adm_passwd