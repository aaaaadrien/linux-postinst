#! /usr/bin/env bash

#QUEST_NONFREE_FR="Voulez-vous les composants non libre ?"
#QUEST_NONFREE_EN="Do you want non-free components ?"
#SYSLANG=${LANG:0:2}

# Detect distrib
DISTN="$(source /etc/os-release; echo $ID)"
DISTV="$(source /etc/os-release; echo $VERSION_ID)"

# Actions distrib
case "$DISTN" in
	debian)
		echo "DEB"
	;;
	fedora)
		echo "FED"
	;;

	*)
		echo "Distribution non supportée"
		exit 1
        ;;
esac

