#! /usr/bin/env bash

#QUEST_NONFREE_FR="Voulez-vous les composants non libre ?"
#QUEST_NONFREE_EN="Do you want non-free components ?"
#SYSLANG=${LANG:0:2}

### THANKS FLASHBIOS ###
function spinner() {
    local pid=$1
    local msg=$2
    local delay=0.1
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local frame_index=0
    local spinner_length=4
    local total_length=$((spinner_length + ${#msg}))
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r[%s] %s" "${frames[frame_index]}" "$msg"
        frame_index=$(( (frame_index + 1) % ${#frames[@]} ))
        sleep $delay
        printf "\b%.0s" $(seq 1 $total_length)
    done
    printf "\r\033[K"
}
function run_with_spinner() {
    local cmd="$1"
    local msg="$2"
    eval "$cmd" &
    local pid=$!
    spinner $pid "$msg"
    wait $pid
    return $?
} 
info() {
    printf '%s\n' "${BOLD}${GREY}>${NC} $*"
}
success() {
    printf '%s\n' "${GREEN}✓ $*${NC}"
}
warn() {
    printf '%s\n' "${YELLOW}! $*${NC}"
}
error() {
    printf '%s\n' "${RED}x $*${NC}"
}
### END THANKS FLASHBIOS ###


# Detect root
if [[ "$EUID" -ne 0 ]]
then
	echo "Erreur : Vous devez lancer en tant que root !"
	exit 1
fi

# Detect distrib
DISTN="$(source /etc/os-release; echo "$ID")"
DISTV="$(source /etc/os-release; echo "$VERSION_ID")"

# Actions distrib
case "$DISTN" in
	debian)
		run_with_spinner "apt update > /dev/null 2>&1" "Update des sources" || { error "Erreur Update des sources"; } && success "Update des sources"
		run_with_spinner "apt -y full-upgrade > /dev/null 2>&1" "Upgrade du système" || { error "Erreur Upgrade du système"; } && success "Upgrade du système"
		# Flatpak + flathub
	;;
	fedora)
		DNFVERSION="$(readlink $(which dnf))"
		run_with_spinner "dnf -y --refresh upgrade > /dev/null 2>&1" "Upgrade du système" || { error "Erreur Upgrade du système"; } && success "Upgrade du système"
		#RPM Fusion
			#GNOME Logiciels/Discover : appstream
			#Codec ?
		# Flatpak + flathub
	;;
	ubuntu)
		run_with_spinner "apt update > /dev/null 2>&1" "Update des sources" || { error "Erreur Update des sources"; } && success "Update des sources"
		run_with_spinner "apt -y full-upgrade > /dev/null 2>&1" "Upgrade du système" || { error "Erreur Upgrade du système"; } && success "Upgrade du système"
		# Flatpak + flathub
	;;
	*)
		echo "Distribution non supportée"
		exit 1
        ;;
esac

