#!/bin/bash

if [[ $# -eq 0 ]]; then
  read -p "Dime el archivo: " archivo
  if [[ ! -f $archivo ]]; then
    echo "No existe el archivo"
    exit 1
  fi
  read -p "Dime la IP: " ip
elif [[ $# -eq 1 ]]; then
  archivo=$1
  if [[ ! -f $archivo ]]; then
    echo "No existe el archivo"
    exit 1
  fi
elif [[ $# -eq 2 ]]; then
  archivo=$1
  ip=$2
  if [[ ! -f $archivo ]]; then
    echo "No existe el archivo"
    exit 1
  fi
else
  echo "Uso: $0 [archivo] [IP]"
  exit 1
fi

if [[ -z $ip ]]; then
  ips=()
  bien=()
  mal=()
  total=0
  
  while read -r linea; do
    if [[ $linea =~ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) ]]; then
      ip_encontrada="${BASH_REMATCH[1]}"
      if [[ $linea =~ \"\ ([0-9]{3})\  ]]; then
        codigo="${BASH_REMATCH[1]}"
        encontrado=0

        for ((i=0; i<total; i++)); do
          if [[ ${ips[i]} == "$ip_encontrada" ]]; then
            encontrado=1
            if [[ $codigo -eq 200 ]]; then
              ((bien[i]++))
            else
              ((mal[i]++))
            fi
            break
          fi
        done

        if [[ $encontrado -ne 1 ]]; then
          ips[total]="$ip_encontrada"
          bien[total]=0
          mal[total]=0
          if [[ $codigo -eq 200 ]]; then
            ((bien[total]++))
          else
            ((mal[total]++))
          fi
          ((total++))
        fi
      fi
    fi
  done < "$archivo"

  for ((i=0; i<total; i++)); do
    echo "IP: ${ips[i]} - Bien: ${bien[i]} - Mal: ${mal[i]}"
  done
fi

if [[ -n $ip ]]; then
  while read -r linea; do
    if [[ $linea =~ $ip ]]; then
      if [[ $linea =~ \"(http[^\"]*)\" ]]; then
        url="${BASH_REMATCH[1]}"
      fi
      if [[ $linea =~ ([0-9]{2}/[A-Za-z]{3}/[0-9]{4}:[0-9]{2}:[0-9]{2}:[0-9]{2}) ]]; then
        fecha_hora="${BASH_REMATCH[1]}"
      fi
      if [[ $linea =~ (Windows\ NT|Mac\ OS\ X|Linux|Ubuntu|Android|iPhone) ]]; then
        os="${BASH_REMATCH[1]}"
      fi
      if [[ $linea =~ (Firefox|Chrome|Safari|Opera|Edge|MSIE) ]]; then
        navegador="${BASH_REMATCH[1]}"
      fi
      echo "$url $fecha_hora $os $navegador"
    fi
  done < "$archivo"
fi
