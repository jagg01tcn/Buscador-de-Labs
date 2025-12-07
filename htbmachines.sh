#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Variables
main_url=https://htbmachines.github.io/bundle.js

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo ...${endColour}\n"
  tput cnorm && exit 1
}

#Control C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Uso: ${endColour}" 
  echo -e "\t${purpleColour}m)${endColour} ${grayColour} Buscar por nombre de maquina${endColour}"
  echo -e "\t${purpleColour}u)${endColour} ${grayColour} Actulizar datos del programa${endColour}"
  echo -e "\t${purpleColour}i)${endColour} ${grayColour} Buscar por IP de maquina ${endColour}"
  echo -e "\t${purpleColour}y)${endColour} ${grayColour} Link resolución de la maquina ${endColour}"
  echo -e "\t${purpleColour}n)${endColour} ${grayColour} Filtrar por nivel de dificultad ${endColour}"
  echo -e "\t${purpleColour}o)${endColour} ${grayColour} Filtrar por sistema operativo ${endColour}"
  echo -e "\t${purpleColour}s)${endColour} ${grayColour} Filtrar por skill ${endColour}"
  echo -e "\t${purpleColour}h)${endColour} ${grayColour} Mostrar este panel de ayuda ${endColour}"
}

function updatefiles(){
  if [ ! -f bundle.js ]; then
   tput civis
   echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Comenzamos con las actulizaciones ${endColour}"
   curl -s $main_url | js-beautify >bundle.js  
   echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Todos los archivos han sido actualizados ${endColour}" 
   tput cnorm
  else
   tput civis
   echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Comprobando si hay actulizaciones ${endColour}"
   md5_origianl_value="$(md5sum bundle.js | awk '{print $1}')"
   md5_temp_value="$(curl -s https://htbmachines.github.io/bundle.js | js-beautify | md5sum | awk '{print $1}')"
   if [ "$md5_temp_value" == "$md5_origianl_value" ]; then 
    echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} No hay actulizaciones ${endColour}"
   else
    echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Se han descargado todas las actulizaciones ${endColour}"
    rm -rf bundle.js
    curl -s $main_url | js-beautify >bundle.js  
   fi 
   tput cnorm
  fi
 }

function searchMachin(){
  machinName="$1"
  check_searchMachin="$(cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ','| sed 's/^ *//')"
  if [ "$check_searchMachin" ]; then 
   echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Listando las propiedades de la máquina ${endColour}${yellowColour}$machinName${endColour}"  
   name="$(cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | tr -d '"' | tr -d ','|  grep name | awk 'NF {print $NF }')"
   ip="$(cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | tr -d '"' | tr -d ','|  grep "ip:"  | awk 'NF {print $NF }')"
   so="$(cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | tr -d '"' | tr -d ','|  grep "so:" | awk 'NF {print $NF }')"
   dificultad="$(cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | tr -d '"' | tr -d ','|  grep dificultad | awk 'NF {print $NF }')"
   skill="$(cat bundle.js | awk "/name: \"Tentacle\"/,/resuelta/" | grep skills | tr -d '"'|sed 's/^[[:space:]]*skills: //')"
   youtube="$(   cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | tr -d '"' | tr -d ','|  grep youtube | awk 'NF {print $NF }')"
   echo -e  "\n ${yellowColour}name:${endColour}${greenColour}$name${endColour}"
   echo -e  "\n ${yellowColour}ip:${endColour}${greenColour}$ip${endColour}"
   echo -e  "\n ${yellowColour}so:${endColour}${greenColour}$so${endColour}"
   echo -e  "\n ${yellowColour}dificultad:${endColour}${greenColour}$dificultad${endColour}"
   echo -e  "\n ${yellowColour}skill:${endColour}${greenColour}$skill${endColour}"
   echo -e  "\n ${blueColour}$youtube${endColour}"
  else
   echo -e "\n\n${redColour}[!]${endColour} ${grayColour} No se han encontrado ninguna máquina con ese nombre" 
   echo -e "\n\n${redColour}[!]${endColour} ${grayColour} Verifica si esta bien escrito ${endColour}"
   echo -e "\n\n${redColour}[!]${endColour}${grayColour}  Verifica si la primera letra empieza por mayuscula  ${endColour}"
  fi 
}
function searchIP(){
 machinIP="$1"
 check_searchIP="$(cat bundle.js | grep "ip: \"$machinIP\"" -B3 | grep name | tr -d '"' | tr -d ','| awk 'NF{print $NF}')" 
 if [ "$check_searchIP" ]; then
  machinName="$(cat bundle.js | grep "ip: \"$machinIP\"" -B3 | grep name | tr -d '"' | tr -d ','| awk 'NF{print $NF}')"
  echo -e "La ip ${blueColour}$machinIP ${endColour} coreesponde a  la maquina ${greenColour} $machinName ${endColour}"
 else
  echo -e "\n\n${redColour}[!]${endColour} ${grayColour} No se han encontrado ninguna máquina con esa IP" 
 fi
}
function getLink(){
  machinName="$1"
  check_getLink="$(cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ','| sed 's/^ *//')"
  #echo "$check_getLink"
  if [ "$check_getLink" ]; then 
   echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Link a la resolución de la maquina en YouYube: ${endColour}${yellowColour}$machinName${endColour}"  
   youtube="$(cat bundle.js | awk "/name: \"$machinName\"/,/resuelta/" | tr -d '"' | tr -d ','|  grep youtube | awk 'NF {print $NF }')"
   echo -e  "\n ${blueColour}$youtube${endColour}"
  else
   echo -e "\n\n${redColour}[!]${endColour} ${grayColour} No se han encontrado ninguna máquina con ese nombre" 
   echo -e "\n\n${redColour}[!]${endColour} ${grayColour} Verifica si esta bien escrito ${endColour}"
   echo -e "\n\n${redColour}[!]${endColour}${grayColour}  Verifica si la primera letra empieza por mayuscula  ${endColour}"
  fi 
}
function searchDifficultyMachin(){
  echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Listando las maquinas de nivel de dificultad ${endColour}${yellowColour}$DifficultyMachin${endColour}\n"  
  DifficultyMachin="$1"
  check_searchDifficultyMachin="$(cat bundle.js | grep "dificultad: \"$DifficultyMachin\"" -B5 | grep name | tr -d '"' | tr -d ',' | awk 'NF{print $NF}')"
  if [ "$check_searchDifficultyMachin" ]; then
   cat bundle.js | grep "dificultad: \"$DifficultyMachin\"" -B5 |grep name | tr -d '"' | tr -d ',' | awk 'NF{print $NF}' | column
  else
   echo -e "\n\n${redColour}[!]${endColour} ${grayColour} No se han encontrado ninguna máquina con el nivel de dificultad ${redColour}${DifficultyMachin}${endColour}" 
   echo -e "\n\n${redColour}[!]${endColour} ${grayColour} Verifica si esta bien escrito ${endColour}"
   echo -e "\n\n${redColour}[!]${endColour}${grayColour}  Verifica si la primera letra empieza por mayuscula  ${endColour}"
  fi
}
function searchOperativeSystem(){
  echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Listando las maquinas con sistema operativo ${endColour}${yellowColour}$OperativeSystem${endColour}\n"  
  cat bundle.js |  grep "so: \"$OperativeSystem\"" -B4 |grep name: |awk 'NF {print$NF}' &>/dev/null
  check_searchOperativeSystem=$?
if [ $check_searchOperativeSystem  -eq 0 ]; then
 cat bundle.js |  grep "so: \"$OperativeSystem\"" -B4 |grep name: |awk 'NF {print$NF}' | tr -d '"' | tr -d ','|column
else
 echo -e "\n\n${redColour}[!]${endColour} ${grayColour} No se han encontrado ninguna máquina con el sistema Operativo $OperativeSystem ${redColour}${DifficultyMachin}${endColour}" 
 echo -e "\n\n${redColour}[!]${endColour} ${grayColour} Verifica si esta bien escrito ${endColour}"
 echo -e "\n\n${redColour}[!]${endColour}${grayColour}  Verifica si la primera letra empieza por mayuscula  ${endColour}"
fi
}
function getOsDifficulty(){
     echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Listando maquinas ${yellowColour} $DifficultyMachin ${endColour} con sistema operativo ${yellowColour}$OperativeSystem${endColour} \n "   
  check_getOsDifficulty="$(cat bundle.js |grep "so: \"$OperativeSystem\"" -C4 |grep "dificultad: \"$DifficultyMachin\"" -B5 | grep name: )" 
  if [ "$check_getOsDifficulty"  ]; then
   cat bundle.js |  grep "so: \"$OperativeSystem\"" -C4 |grep "dificultad: \"$DifficultyMachin\"" -B5 | grep name: | awk 'NF{print $NF}'| tr -d '"'| tr -d ',' | column
else 

 echo -e "\n\n${redColour}[!]${endColour}${grayColour}  No se han encontrado ninguna maquina  ${endColour}"
 echo -e "\n\n${redColour}[!]${endColour} ${grayColour} Verifica si esta bien escrito ${endColour}"
 echo -e "\n\n${redColour}[!]${endColour}${grayColour}  Verifica si la primera letra empieza por mayuscula  ${endColour}"

  fi
}
function searchSkill(){
  echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour} Listando  las máquina  de ${endColour}${yellowColour}$SkillMachin${endColour}\n"  
  check_searchSkill="$(cat bundle.js | grep skills: -B6 | grep "$SkillMachin" -B6 | grep name: | tr -d '"' | tr -d ',' | awk 'NF{print $NF}')"
if [ check_searchSkill ]; then
 cat bundle.js | grep skills: -B6 | grep "SQL Injection" -B6 | grep name: | tr -d '"' | tr -d ',' | awk 'NF{print $NF}' | column
else 
 echo -e "\n\n${redColour}[!]${endColour}${grayColour}  No se han encontrado ninguna maquina esa skill  ${endColour}"
 echo -e "\n\n${redColour}[!]${endColour} ${grayColour} Verifica si esta bien escrito ${endColour}"
 echo -e "\n\n${redColour}[!]${endColour}${grayColour}  Verifica si la primera letra empieza por mayuscula  ${endColour}"
fi
}
#Indicadores
declare -i parameter_counter=0

#Chivato
declare -i chivato_DifficultyMachin=0
declare -i chivato_OperativeSystem=0

while getopts  "m:ui:y:n:o:s:h" args; do
 case $args in 
   m)machinName=$OPTARG; parameter_counter+=1;;
   u)parameter_counter+=2;;
   i)machinIP=$OPTARG; let parameter_counter+=3;;
   y)machinName=$OPTARG; let parameter_counter+=4;;
   n)DifficultyMachin=$OPTARG; chivato_DifficultyMachin+=1; let parameter_counter+=5;;
   o)OperativeSystem=$OPTARG; chivato_OperativeSystem+=1; let parameter_counter+=6;;
   s)SkillMachin=$OPTARG; let parameter_counter+=7;;
   h);;
 esac
done

if [ "$parameter_counter" -eq 1 ] ; then
 searchMachin $machinName
elif [ "$parameter_counter" -eq 2 ]; then 
 updatefiles
elif [ "$parameter_counter" -eq 3 ]; then 
  searchIP $machinIP
elif [ "$parameter_counter" -eq 4 ]; then 
 getLink $machinName
elif [ "$parameter_counter" -eq 5 ]; then 
  searchDifficultyMachin $DifficultyMachin
elif [ "$parameter_counter" -eq 6 ]; then 
  searchOperativeSystem $OperativeSystem
elif [ "$parameter_counter" -eq 7 ]; then 
  searchSkill "$SkillMachin"
elif [ $chivato_OperativeSystem -eq 1 ] && [ $chivato_DifficultyMachin -eq 1 ]; then
  getOsDifficulty $DifficultyMachin $OperativeSystem
else
 helpPanel
fi 

