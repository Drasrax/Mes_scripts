#!/usr/bin/env bash

#########################
#
# NAME Definitive fail2ban check the logs and ban all
#
#
# CREATING DATE 07/06/2021
#
# LAST RELEASE 07/06/2021
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
banlist=$( awk '($(NF-1) = /Ban/){print $NF,""}' /var/log/fail2ban.log* | sort |uniq)
i=0
temp_file=$(mktemp)
#########################
# FUNCTION              #
#########################

function usage()
{
    printf "Script options :\n"
    printf "\t-c                   : Start the script for automated lock ip ;\n"
    printf "\t-l                   : List all ip locked by iptables ;\n"
    printf "\t-s                   : Search ip in iptables ;\n"
    printf "\t-u                   : Unlock ip in iptables ;\n"
    printf "\t-h                   : Show this message.\n"
}

check_retour()
{
    if [ $? -eq "0" ]
    then
      command echo -e "[\e[92mOk\e[39m]"
    else
      command echo -e "[\e[91mFailed\e[39m]"
      command exit 1
    fi

}

list_ip()
    {
    iptables -L INPUT -v -n | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' | sed -e "s/^0.0.0.0//" >> ${temp_file}
    while IFS= read -r line;
      do
          if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
              echo $line >> $1
              i=$((i+1))
          fi
      done < ${temp_file}
      echo -n "$i ips writed in $1 "
      check_retour
}

search_ip()
{
     if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
       checkexist=$(iptables -L INPUT -v -n|grep $1)
       if [[ -z "$checkexist" ]]; then
         echo -e "[\e[93m$1\e[39m] has not listed in iptables"
       else
         echo -e "[\e[91m$1\e[39m] is listed in iptables"
       fi
    else
      echo "\e[91m$1 is not an valid ip address !\e[39m"
    fi
}

unlock_ip()
{
  if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    checkexist=$(iptables -L INPUT -v -n|grep $1)
    if [[ -z "$checkexist" ]]; then
      echo -e "[\e[93m$1\e[39m] has not locked in iptables"
    else
      iptables -D INPUT -s $1 -j DROP
      echo -n "Unlock ip [$1]"
      check_retour
    fi
  else
   echo "\e[91m$1 is not an valid ip address !\e[39m"
  fi
}


check_and_lock()
{
    echo "Creating Deny list"
      for ip in $banlist
      do
          echo -n "Deny $ip "
          checkip=$(iptables -L INPUT -v -n | grep "$ip")
          if [[ -z "$checkip" ]]; then
            iptables -A INPUT -s $ip -j DROP
            check_retour
            i=$((i+1))
          else
            echo -e "[\e[93mAlready lock\e[39m]"
          fi
      done
    echo "$i hosts added in my deny list"
}

#########################
# SCRIPT                #
#########################
if [ $# -eq 0 ]
  then
    usage
  fi

while getopts "chl:s:u:" OPTION; do
case $OPTION in
   c)
     check_and_lock
              ;;
  h)
    usage
        ;;
  l)
    shift;
    list_ip $1
    ;;
  s)
    shift;
    search_ip $1
    ;;
  u)
    shift;
    unlock_ip $1
    ;;
  *)
    echo "Incorrect options provided"
    exit 1
    ;;
esac
done
