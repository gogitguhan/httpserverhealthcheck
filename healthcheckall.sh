#!/bin/bash
# Guhan Sivaji - 27/Sep/2018
# To check the health of http servers step by step (host level, app server level & application level)

result=
geturl=
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
printf '%s\n' ----------------------------------
printf "|   IP Address    | Host | C360 |\n"
printf '%s\n' ----------------------------------
while IFS=$' \t\n\r' read -r ipaddrs;
do 
printf "|%-14s   " $ipaddrs
ping -c 1 -t 5 "$ipaddrs" >/dev/null
if [ $? -eq 0 ]; then
    printf "| ${GREEN} UP${NC}  |" 
    geturl=http://admin:admin@$ipaddrs/cmx/cs/orcl-TCR_HUB_NEW/CustomerOrg.json?fq=fullNm=Disney
    result=$(curl --write-out %{http_code} --silent --output /dev/null -L "{$geturl}")
    if [ $result -eq 200 ];
then
   printf "${GREEN} $result${NC}  |"
else
   printf "${RED} $result${NC}  |"
fi
    else
    printf "| ${RED}DOWN${NC} |"  
    geturl=http://admin:admin@$ipaddrs/cmx/cs/orcl-TCR_HUB_NEW/CustomerOrg.json?fq=fullNm=Disney
    result=$(curl --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null -L "{$geturl}")
    if [ $result -eq 200 ];
then
   printf "${GREEN} $result${NC}  |"
else
   printf "${RED} $result${NC}  |"
fi

    fi
printf "\n"
done < "$1"
