#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage : $0 <target>"
  exit 1
fi

target=$1

# Premier scan avec l'option -p- pour scanner tous les ports
scan_results=$(nmap -p- $target -Pn --min-rate=5000 | grep 'open')

# Extraction des ports ouverts détectés lors du premier scan
open_ports=$(echo "$scan_results" | cut -d "/" -f1 | tr '\n' ',' | sed 's/,$//')

# Deuxième scan sur les ports ouverts avec les options -sV et -sC
nmap -sV -sC -p$open_ports $target -Pn
