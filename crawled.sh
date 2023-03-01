#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: subdomained [URL]"
  echo "Exemple: subdomained https://example.com"
  exit 1
fi

site=$1
domain=$(echo $site | awk -F/ '{split($3, a, "."); print a[length(a)-1] "." a[length(a)]}')

waybackurls $site > waybackurls.txt
echo "waybackurls terminé"

katana -silent -u $site > katana.txt
echo "katana terminé"

gau $site > gau.txt
echo "gau terminé"

cat waybackurls.txt katana.txt gau.txt | uro | sort -u > ./$domain-crawl.txt
rm waybackurls.txt katana.txt gau.txt

echo "La liste des endpoints crawlé a été enregistrée dans le fichier $domain-crawl.txt"