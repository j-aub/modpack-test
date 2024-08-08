#!/bin/sh
set -eu

# $1 is the version/commit
VERSION="$1"
# root url for where pack.toml is hosted
URL="https://raw.githubusercontent.com/j-aub/modpack-test/main"
# name of modpack to use in filenames
NAME="modpack-test"
NAME_PRETTY="Modpack Test"
# path of installer bootstrap jar file within the prismlauncher instance
# zip
BOOTSRAP_JAR='packwiz-installer-bootstrap.jar'
# packwiz-installer-bootstrap version
BOOTSTRAP_VERSION='v0.0.3'
# packwiz-installer-bootstrap.jar sha256sum
BOOTSTRAP_SHA256SUM='a8fbb24dc604278e97f4688e82d3d91a318b98efc08d5dbfcbcbcab6443d116c'
# even this isn't strictly necessary but it's nicer to specify so that the
# updater doesn't show any warnings
MC_VERSION='1.20.1'
NEOFORGE_VERSION='47.1.106'

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
# inspired by https://gist.github.com/copygirl/ec93c25628b083d4f25bd48259b6d505
mkdir temp
cd temp

mkdir .minecraft
curl -L \
	"https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/${BOOTSTRAP_VERSION}/packwiz-installer-bootstrap.jar" \
	-o ".minecraft/$BOOTSRAP_JAR"
# paranoid
echo "${BOOTSTRAP_SHA256SUM} .minecraft/${BOOTSRAP_JAR}" | sha256sum --check --status

# only create most basic instance.cfg since PrismLauncher will fill it out
# on the first run
cat > instance.cfg << EOF
[General]
name=${NAME_PRETTY}
OverrideCommands=true
PreLaunchCommand="\$INST_JAVA" -jar "${BOOTSRAP_JAR}" "${URL}/pack.toml"
EOF

# Create a minimal mmc-pack.json file.
# Other dependencies should be auto-filled on first launch.
cat > mmc-pack.json << EOF
{
  "formatVersion": 1,
  "components": [
    { "uid": "net.minecraft", "version": "${MC_VERSION}", "important": true },
    { "uid": "net.neoforged", "version": "${NEOFORGE_VERSION}" }
  ]
}
EOF

# create the artifact
zip -qr "instance.zip" .
# go back to root dir
cd ..
# move the artifact into position
# prismlauncher gets the instance name from the zip file name unfortunately
mv "temp/instance.zip" "./dist/${NAME_PRETTY}.zip"
