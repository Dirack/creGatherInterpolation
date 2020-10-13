#!/bin/bash
#
# build_release_message.sh (Shell Script)
# 
# Purpose: Build a release message parsing the history
# generated by git log.
# 
# This script search for the current marks in the commits subject
# and parses it to 'tag.deploy' file:
#
# - [ADD] Added for new features.
# - [CHA] Changed for changes in existing functionality.
# - [DEP] Deprecated for once-stable features removed in upcoming releases.
# - [REM] Removed for deprecated features removed in this release.
# - [FIX] Fixed for any bug fixes.
# - [SEC] Security to invite users to upgrade in case of vulnerabilities.
#
# Site: https://dirack.github.io
# 
# Version 1.0
# 
# Programer: Rodolfo A C Neves (Dirack) 14/10/2020
# 
# Email: rodolfo_profissional@hotmail.com
# 
# License: GPL-3.0 <https://www.gnu.org/licenses/gpl-3.0.txt>.

PREVIOUS_TAG=$(git tag | sort -n -r | head -1)
CURRENT_TAG=$(cat VERSION.md)


# Avoid deploy the same tag twice
if [ "$PREVIOUS_TAG" == "$CURRENT_TAG" ]
then
	echo "Current tag in VERSION.md is equal to the latest tag, do not deploy!"
	exit 1
fi

# TAG HEADER
echo "VERSION $CURRENT_TAG" > tag.deploy

# TAG MESSAGE 
echo "## Added" >> tag.deploy
git log HEAD..."$PREVIOUS_TAG" --grep='^\[ADD\]' --pretty='format:(%h) %s%n%b%n' >> tag.deploy
echo "## Changed" >> tag.deploy
git log HEAD..."$PREVIOUS_TAG" --grep='^\[CHA\]' --pretty='format:(%h) %s%n%b%n' >> tag.deploy
echo "## Deprecated" >> tag.deploy
git log HEAD..."$PREVIOUS_TAG" --grep='^\[DEP\]' --pretty='format:(%h) %s%n%b%n' >> tag.deploy
echo "## Removed" >> tag.deploy
git log HEAD..."$PREVIOUS_TAG" --grep='^\[REM\]' --pretty='format:(%h) %s%n%b%n' >> tag.deploy
echo "## Fixed" >> tag.deploy
git log HEAD..."$PREVIOUS_TAG" --grep='^\[FIX\]' --pretty='format:(%h) %s%n%b%n' >> tag.deploy
echo "## Security" >> tag.deploy
git log HEAD..."$PREVIOUS_TAG" --grep='^\[SEC\]' --pretty='format:(%h) %s%n%b%n' >> tag.deploy

