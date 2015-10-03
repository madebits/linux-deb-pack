#!/bin/bash

if [[ $(id -u) != "0" ]]; then
	sudo $0 $USER $1
	exit 0
fi

user="$1"
tempFolder="package"
targetFolder="$2"

if [[ ! -d "$targetFolder" ]]; then
	echo "Not found $targetFolder"
	exit 1
fi	

if [[ ! -d "$tempFolder" ]]; then
	mkdir "$tempFolder"
fi	
rm -rf "$tempFolder"/*
cp -r "$targetFolder" "$tempFolder/$targetFolder"
cd "$tempFolder"

chown -R root "$targetFolder"
chgrp -R root "$targetFolder"

dpkg-deb --build "$targetFolder"

rm -rf "$targetFolder"
cd ..
if [[ -n "%1" ]]; then
	chown -R "$user" "$tempFolder"
	chgrp -R "$user" "$tempFolder"
fi

lintian "$tempFolder/$targetFolder.deb"