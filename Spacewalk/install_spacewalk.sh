#!/usr/bin/env bash

#########################
#
# NAME Spacewalk Installation Base centos 7
#
#
# CREATING DATE 04/06/2020
#
# LAST RELEASE 04/06/2020
#
#########################

#########################
# SETTINGS              #
#                       #
#########################
export LANG=C

#########################
# LIB                   #
#########################

#########################
# CONSTANTE             #
#########################

#########################
# VARIABLE              #
#########################

logfiles="/var/log/install_spacewalk"

logterm="&> $logfiles/install.log 2> $logfiles/error.log"

#########################
# FUNCTION              #
#########################

only_root()
{
    if [ $(id -u) != "0" ]
        then
                command echo "Ce script nécéssite les droits sudoer ou root"

        exit 1
    fi
}

check_retour()
    {
        if [ $? -eq "0" ]
        then
            command echo -e "[\e[92mOk\e[39m]"
        else
            command echo -e "[\e[91mFailed\e[39m]"
            command echo "Installation arrêtée il semble y avoir un problème.\nPour plus d'informations \nconsultez les fichiers $logfiles/error.log et $logfiles/install.log "
            command exit 1
       fi

    }

create_logfiles()
    {

        command mkdir -p $logfiles
        command cd $logfiles
        command touch install.log
        command touch error.log
        command cd -
    }

machine_config()
    {
        command echo -n "---- Config du hostname ----       "
        check_retour
        command hostnamectl set-hostname spacewalk.1.local &> $logfiles/install.log 2> $logfiles/error.log
        command echo -n "---- Configuration du firewall ----       "
        command  firewall-cmd --add-service={http,https} --permanent
        check_retour
        command echo -n "---- Reload firewalld ----     "
        command systemctl restart firewalld &> $logfiles/install.log 2> $logfiles/error.log
        check_retour
        command echo -n "---- Config NTP ----       "
        check_retour
        command yum install -y ntp &> $logfiles/install.log 2> $logfiles/error.log
        command systemctl restart ntpd &> $logfiles/install.log 2> $logfiles/error.log
        command timedatectl set-timezone Europe/Madrid &> $logfiles/install.log 2> $logfiles/error.log

    }

yum_config()
    {
        command echo -n "---- Install des yum-utils ----     "
        command yum install -y yum-utils &> $logfiles/install.log 2> $logfiles/error.log
        check_retour
    }

yum_repo_conf()
    {
        command echo -n "---- Repo lastest Spacewalk ----     "
        command yum -y install https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.8/epel-7-x86_64/00736372-spacewalk-repo/spacewalk-repo-2.8-11.el7.centos.noarch.rpm &> $logfiles/install.log 2> $logfiles/error.log
        check_retour
        command echo -n "---- Repo epel ----       "
        command yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &> $logfiles/install.log 2> $logfiles/error.log
        check_retour
    }

upgrade_distro()
    {
        command echo -n "---- Upgrade distro ----      "
        command yum -y update &> $logfiles/install.log 2> $logfiles/error.log
        check_retour
    }

install_spacewalk_pack()
    {
        command echo "---- Installation du pack Spacewalk et ses dependances ----"
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
        command yum --enablerepo=epel -y install spacewalk-setup-postgresql spacewalk-postgresql perl  &> $logfiles/install.log 2> $logfiles/error.log
        check_retour
        command yum --enablerepo=epel -y install spacewalk-setup-postgresql spacewalk-postgresql perl dojo &> $logfiles/install.log 2> $logfiles/error.log
        check_retour
    }

spacewalk_config()
    {
        command echo -n "---- Configuration de Spacewalk ----      "
        command spacewalk-setup  2> $logfiles/error.log
        check_retour
    }

#########################
# SCRIPT              #
#########################
only_root
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Spacewalk\e[49m #############"
command echo "########################################################"
create_logfiles
command echo -e "----------------- \e[91mTasks:\e[39m -----------------"
machine_config
yum_config
yum_repo_conf
upgrade_distro
install_spacewalk_pack
spacewalk_config
sleep 60
clear
command echo "########################################################"
command echo -e "################ \e[100mInstallation de Spacewalk\e[49m #############"
command echo "########################################################"
command echo "###### Configuration des users ######"
command echo -e "\n \n"
command echo "On patiente 5 minutes le temps que Spacewalk démarre..."
command sleep 300
