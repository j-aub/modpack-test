#!/bin/sh
set -eu

# name of modpack to use in filenames
NAME="modpack-test"
# $1 is the version/commit
VERSION="$1"

# ensure the packwiz binary is executable
chmod +x packwiz
# ensure output directory exists
mkdir dist

# create the modpacks
# client curseforge
./packwiz curseforge export -o "dist/${NAME}-curseforge-${VERSION}.zip"
# server curseforge
./packwiz curseforge export -o "dist/${NAME}-curseforge-server-${VERSION}.zip" -s server
# modrinth
./packwiz curseforge export -o "dist/${NAME}-modrinth-${VERSION}.mrpack"
# we now create a prismlauncher dummy modpack
