#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Usage: subdomained [URL]"
	echo "Exemple: subdomained https://example.com"
	exit 1
fi

site=$1
domain=$(echo $site | awk -F/ '{split($3, a, "."); print a[length(a)-1] "." a[length(a)]}')

assetfinder --subs-only $domain > assetfinder.txt
echo "assetfinder terminé"

subfinder -silent -d $domain > subfinder.txt
echo "subfinder terminé"

curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' > crt.txt
echo "crt.sh terminé"

cat assetfinder.txt subfinder.txt crt.txt | sort -u > ./$domain-subdomains.txt
rm assetfinder.txt subfinder.txt crt.txt

echo "La liste des sous-domaines a été enregistrée dans le fichier $domain-subdomains.txt"