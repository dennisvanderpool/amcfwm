#!/bin/sh
##############################################################################################################
#                                                                                                            #
#         ██████╗███████╗██╗    ██╗    ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗         #
#        ██╔════╝██╔════╝██║    ██║    ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗        #
#        ██║     █████╗  ██║ █╗ ██║    ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝        #
#        ██║     ██╔══╝  ██║███╗██║    ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗        #
#        ╚██████╗██║     ╚███╔███╔╝    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║        #
#         ╚═════╝╚═╝      ╚══╝╚══╝     ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝        #
#                                                                                                            #
#                           AsusWRT-Merlin CFW Manager For Ubuntu 18.04 LTS                                  #
#                            By Adamm - https://github.com/Adamm00/am_cfwm                                   #
#                                         30/03/2020 - v1.0.0                                                #
##############################################################################################################


clear
sed -n '2,16p' "$0"
mkdir -p "$HOME/amcfwm"

### Inspired By RMerlin

sudo true

if [ -f "$HOME/amcfwm/amcfwm.lock" ] && [ -d "/proc/$(cat "$HOME/amcfwm/amcfwm.lock")" ]; then
	echo "[*] Lock File Detected (pid=$(cat "$HOME/amcfwm/amcfwm.lock")) - Exiting"
	exit 1
else
	echo "$$" > "$HOME/amcfwm/amcfwm.lock"
fi

Red() {
	printf -- '\033[1;31m%s\033[0m\n' "$1"
}

Grn() {
	printf -- '\033[1;32m%s\033[0m\n' "$1"
}

Write_Config() {
	{
		printf '%s\n' "################################################"
		printf '%s\n' "## Generated By AMCFWM - Do Not Manually Edit ##"
		printf '%-45s %s\n\n' "## $(date +"%b %d %T")" "##"
		printf '%s\n' "## Locations ##"
		printf '%s="%s"\n' "SRC_LOC" "$SRC_LOC"
		printf '%s="%s"\n' "STAGE_LOC" "$STAGE_LOC"
		printf '%s="%s"\n' "FINAL_LOC" "$FINAL_LOC"
		printf '%s="%s"\n\n' "SSH_PORT" "$SSH_PORT"
		printf '%s\n' "## Misc Options ##"
		printf '%s="%s"\n' "BUILDREV" "$BUILDREV"
		printf '%s="%s"\n' "RSYNC_TREE" "$RSYNC_TREE"
		printf '%s="%s"\n' "CLEANUP_TREE" "$CLEANUP_TREE"
		printf '%s="%s"\n\n' "FORCEBUILD" "$FORCEBUILD"
		printf '%s\n' "## FW Models ##"
		printf '%s="%s"\n' "BAC56" "$BAC56"
		printf '%s="%s"\n' "BAC68" "$BAC68"
		printf '%s="%s"\n' "BAC87" "$BAC87"
		printf '%s="%s"\n' "BAC3200" "$BAC3200"
		printf '%s="%s"\n' "BAC88" "$BAC88"
		printf '%s="%s"\n' "BAC3100" "$BAC3100"
		printf '%s="%s"\n' "BAC5300" "$BAC5300"
		printf '%s="%s"\n' "BAC86" "$BAC86"
		printf '%s="%s"\n' "BAX88" "$BAX88"
		printf '%s="%s"\n' "BAX58" "$BAX58"
		printf '\n%s\n' "################################################"
	} > "$HOME/amcfwm/amcfwm.cfg"
}

Set_Default() {
	SRC_LOC="$HOME/amng"
	STAGE_LOC="$HOME/images"
	FINAL_LOC=admin@router.asus.com:/mnt/sda1/Share
	SSH_PORT="22"
	BUILDREV="y"
	RSYNC_TREE="y"
	CLEANUP_TREE="n"
	FORCEBUILD="n"
	BAC56="n"
	BAC68="n"
	BAC87="n"
	BAC3200="n"
	BAC88="n"
	BAC3100="n"
	BAC5300="n"
	BAC86="n"
	BAX88="n"
	BAX58="n"
	Write_Config
}

Filter_Version() {
	grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})'
}

Load_Menu() {
	. "$HOME/amcfwm/amcfwm.cfg"
	reloadmenu="1"
	while true; do
		echo "Select Menu Option:"
		echo "[1]  --> Build Firmware Images"
		echo "[2]  --> Setup VM"
		echo "[3]  --> Setup Repo / Toolchain"
		echo
		echo "[4]  --> Settings"
		echo "[5]  --> Update AMCFWM"
		echo "[6]  --> Uninstall"
		echo
		echo "[e]  --> Exit Menu"
		echo
		printf "[1-6]: "
		read -r "menu"
		echo
		case "$menu" in
			1)
				option1="build"
				break
			;;
			2)
				option1="install"
				break
			;;
			3)
				option1="repo"
				break
			;;
			4)
				option1="settings"
				while true; do
					echo "Select Setting To Toggle:"
					printf '%-35s | %-40s\n' "[1]  --> Source Location" "$(Grn "$SRC_LOC")"
					printf '%-35s | %-40s\n' "[2]  --> Stage Location" "$(Grn "$STAGE_LOC")"
					printf '%-35s | %-40s\n' "[3]  --> Final Location" "$(Grn "$FINAL_LOC")"
					printf '%-35s | %-40s\n\n' "[4]  --> Remote SSH Port" "$(Grn "$SSH_PORT")"
					printf '%-35s | %-40s\n' "[5]  --> Build Revision" "$(if [ "$BUILDREV" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[6]  --> Rsync Tree" "$(if [ "$RSYNC_TREE" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[7]  --> Cleanup Tree" "$(if [ "$CLEANUP_TREE" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n\n' "[8]  --> Force Image Build" "$(if [ "$FORCEBUILD" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[9] --> AC56U Build" "$(if [ "$BAC56" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[10] --> AC68U Build" "$(if [ "$BAC68" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[11] --> AC87U Build" "$(if [ "$BAC87" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[12] --> AC3200 Build" "$(if [ "$BAC3200" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[13] --> AC88U Build" "$(if [ "$BAC88" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[14] --> AC3100 Build" "$(if [ "$BAC3100" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[15] --> AC5300 Build" "$(if [ "$BAC5300" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[16] --> AC86U Build" "$(if [ "$BAC86" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n' "[17] --> AX88U Build" "$(if [ "$BAX88" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s | %-40s\n\n' "[18] --> AX58U Build" "$(if [ "$BAX58" = "y" ]; then Grn "[Enabled]"; else Red "[Disabled]"; fi)"
					printf '%-35s\n\n' "[19] --> Reset All Settings To Default"
					printf "[1-19]: "
					read -r "menu2"
					echo
					case "$menu2" in
						1)
							option2="srcloc"
							echo "Enter Source Location:"
							echo
							printf "[Location]: "
							read -r "option3"
							echo
							if [ -z "$option3" ]; then echo "[*] Location Field Can't Be Empty - Please Try Again"; echo; unset "option1" "option2" "option3"; continue; fi
							if [ ! -d "$option3" ]; then echo "[*] Location Doesn't Exist - Please Try Again"; echo; unset "option1" "option2" "option3"; continue; fi
							break
						;;
						2)
							option2="stageloc"
							echo "Enter Stage Location:"
							echo
							printf "[Location]: "
							read -r "option3"
							echo
							if [ -z "$option3" ]; then echo "[*] Location Field Can't Be Empty - Please Try Again"; echo; unset "option1" "option2" "option3"; continue; fi
							if [ ! -d "$option3" ]; then echo "[*] Location Doesn't Exist - Please Try Again"; echo; unset "option1" "option2" "option3"; continue; fi
							break
						;;
						3)
							option2="finalloc"
							echo "Enter Final Location:"
							echo
							printf "[Location]: "
							read -r "option3"
							echo
							if [ -z "$option3" ]; then echo "[*] Location Field Can't Be Empty - Please Try Again"; echo; unset "option1" "option2" "option3"; continue; fi
							break
						;;
						4)
							option2="sshport"
							echo "Enter Remote SSH Port:"
							echo
							printf "[Port]: "
							read -r "option3"
							echo
							if [ -z "$option3" ]; then echo "[*] Location Field Can't Be Empty - Please Try Again"; echo; unset "option1" "option2" "option3"; continue; fi
							if ! [ "$option3" -eq "$option3" ] 2>/dev/null; then echo "[*] $option3 Isn't A Valid Port Number!"; echo; unset "option1" "option2" "option3"; continue; fi
							break
						;;
						5)
							option2="buildrev"
							while true; do
								echo "Select Build Revision Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						6)
							option2="rsynctree"
							while true; do
								echo "Select Rsync Tree Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						7)
							option2="cleanuptree"
							while true; do
								echo "Select Cleanup Tree Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						8)
							option2="forcebuild"
							while true; do
								echo "Select Force Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						9)
							option2="bac56"
							while true; do
								echo "Select AC56U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						10)
							option2="bac68"
							while true; do
								echo "Select AC68U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						11)
							option2="bac87"
							while true; do
								echo "Select AC87U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						12)
							option2="bac3200"
							while true; do
								echo "Select AC3200U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						13)
							option2="bac88"
							while true; do
								echo "Select AC88U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						14)
							option2="bac3100"
							while true; do
								echo "Select AC3100U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						15)
							option2="bac5300"
							while true; do
								echo "Select AC5300U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						16)
							option2="bac86"
							while true; do
								echo "Select AC86U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						17)
							option2="bax88"
							while true; do
								echo "Select AX88U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						18)
							option2="bax58"
							while true; do
								echo "Select AX58U Build Option:"
								echo "[1]  --> Enable"
								echo "[2]  --> Disable"
								echo
								printf "[1-2]: "
								read -r "menu3"
								echo
								case "$menu3" in
									1)
										option3="enable"
										break
									;;
									2)
										option3="disable"
										break
									;;
									e|exit|back|menu)
										unset "option1" "option2" "option3"
										clear
										Load_Menu
										break
									;;
									*)
										echo "[*] $menu3 Isn't An Option!"
										echo
									;;
								esac
							done
							break
						;;
						19)
							option2="reset"
							break
						;;
						e|exit|back|menu)
							unset "option1" "option2" "option3"
							clear
							Load_Menu
							break
						;;
						*)
							echo "[*] $menu2 Isn't An Option!"
							echo
						;;
					esac
				done
				break
			;;
			5)
				option1="update"
				break
			;;
			6)
				option1="uninstall"
				break
			;;
			e|exit)
				echo "[*] Exiting!"
				echo; exit 0
			;;
			*)
				echo "[*] $menu Isn't An Option!"
				echo
			;;
		esac
	done
}

if [ -z "$1" ]; then
	Load_Menu
fi

if [ -n "$option1" ]; then
	set "$option1" "$option2" "$option3"
	echo "[$] $0 $*" | tr -s " "
	echo
fi

if [ -f "$HOME/amcfwm/amcfwm.cfg" ]; then
	. "$HOME/amcfwm/amcfwm.cfg"
fi

##############
#- Commands -#
##############

case "$1" in
	build)
		if [ "$BAC56" = "n" ] && [ "$BAC68" = "n" ] && [ "$BAC87" = "n" ] && [ "$BAC3200" = "n" ] && [ "$BAC88" = "n" ] && [ "$BAC3100" = "n" ] && [ "$BAC5300" = "n" ] && [ "$BAC86" = "n" ] && [ "$BAX88" = "n" ] && [ "$BAX58" = "n" ]; then
			echo "[*] No Models Configured For Build - Exiting!"
			echo
			exit 1
		fi
		if [ "$BUILDREV" = "y" ]; then export BUILDREV="1"; fi
		build_fw() {
			BRANCH="$3"
			FWMODEL="$2"
			FWPATH="$1"
			LOCALVER="$(cat "$HOME/amcfwm/$FWMODEL.git" 2>/dev/null)"
			REMOTEVER="$(git ls-remote https://github.com/RMerl/asuswrt-merlin.ng.git "$BRANCH" | awk '{print $1}')"

			if [ "$LOCALVER" != "$REMOTEVER" ] || [ "$FORCEBUILD" = "y" ]; then
				echo "*** $(date +%R) - Starting building $FWMODEL..."
				cd "$HOME/$FWPATH" || exit 1
				if make "$FWMODEL" > "$HOME/amcfwm/$FWMODEL-output.txt" 2>&1; then
					cd image || exit 1
					if [ "$FWMODEL" = "rt-ac86u" ] || [ "$FWMODEL" = "rt-ax88u" ]; then
						FWNAME=$(find -- *_cferom_ubi.w | head -n 1)
						ZIPNAME="$(echo "$FWNAME" | sed 's~_cferom_ubi.w~~g').zip"
					elif [ "$FWMODEL" = "rt-ax58u" ]; then
						FWNAME=$(find -- *_cferom_pureubi.w | head -n 1)
						ZIPNAME="$(echo "$FWNAME" | sed 's~_cferom_pureubi.w~~g').zip"
					else
						FWNAME=$(find -- *.trx | head -n 1)
						ZIPNAME="$(echo "$FWNAME" | sed 's~.trx~~g').zip"
					fi
					cp "$FWNAME" "$STAGE_LOC/"

					sha256sum "$FWNAME" > sha256sum.sha256
					zip -qj "$STAGE_LOC/$ZIPNAME" "$FWNAME" "$STAGE_LOC/README-merlin.txt" "$STAGE_LOC"/Changelog*.txt "sha256sum.sha256" 2>/dev/null
					echo "*** $(date +%R) - Done building $FWMODEL!"
					touch "$HOME/amcfwm/build.success"
				else
					echo "!!! $(date +%R) - $FWMODEL build failed!"
				fi
				git -C "$HOME/$FWPATH" rev-parse HEAD > "$HOME/amcfwm/$FWMODEL.git"
			fi
		}

		clean_tree() {
			FWPATH=$1
			SDKPATH=$2
			FWMODEL=$3
			BRANCH=$4
			LOCALVER="$(cat "$HOME/amcfwm/$FWMODEL.git" 2>/dev/null)"
			REMOTEVER="$(git ls-remote https://github.com/RMerl/asuswrt-merlin.ng.git "$BRANCH" | awk '{print $1}')"

			if [ "$LOCALVER" != "$REMOTEVER" ] || [ "$FORCEBUILD" = "y" ]; then
				echo
				echo "*** $(date +%R) - Cleaning up $FWMODEL..."
				if [ "$RSYNC_TREE" = "y" ]; then
					echo "*** $(date +%R) - Updating $FWMODEL tree..."
					rsync -a --del "$SRC_LOC/" "$HOME/$FWPATH"
				fi
				cd "$HOME/$FWPATH" || exit 1

				CURRENT=$(git branch | grep "\*" | cut -d ' ' -f2)
				if [ "$CURRENT" != "$BRANCH" ] ; then
					git checkout "$BRANCH" >/dev/null 2>&1
					git pull origin "$BRANCH" >/dev/null 2>&1
				fi

				if [ "$CLEANUP_TREE" = "y" ]; then
					cd "$HOME/$FWPATH/$SDKPATH" || exit 1
					make cleankernel clean >/dev/null 2>&1
					rm .config image/*.trx image/*.w >/dev/null 2>&1
				fi

				echo "*** $(date +%R) - $FWMODEL code ready."
			else
				echo "*** $(date +%R) - $FWMODEL Up To Date"
				eval "$(echo "$FWMODEL" | tr -d '-')=n"
			fi
		}

		# Initial cleanup

		echo "--- $(date +%R) - Global cleanup..."
		mkdir -p "$STAGE_LOC/backup"
		mv "$STAGE_LOC"/* "$STAGE_LOC/backup/" 2>/dev/null
		cp "$SRC_LOC/README-merlin.txt" "$STAGE_LOC/"
		cp "$SRC_LOC"/Changelog*.txt "$STAGE_LOC/"


		# Update all model trees

		echo "--- $(date +%R) - Preparing trees"
		if [ "$BAC56" = "y" ]; then
			clean_tree amng.ac56 release/src-rt-6.x.4708 rt-ac56u master
		fi
		if [ "$BAC68" = "y" ]; then
			clean_tree amng.ac68 release/src-rt-6.x.4708 rt-ac68u mainline
		fi
		if [ "$BAC87" = "y" ]; then
			clean_tree amng.ac87 release/src-rt-6.x.4708 rt-ac87u 384.13_x
		fi
		if [ "$BAC3200" = "y" ]; then
			clean_tree amng.ac3200 release/src-rt-7.x.main/src rt-ac3200 384.13_x
		fi
		if [ "$BAC3100" = "y" ]; then
			clean_tree amng.ac3100 release/src-rt-7.14.114.x/src rt-ac3100 mainline
		fi
		if [ "$BAC88" = "y" ]; then
			clean_tree amng.ac88 release/src-rt-7.14.114.x/src rt-ac88u mainline
		fi
		if [ "$BAC5300" = "y" ]; then
			clean_tree amng.ac5300 release/src-rt-7.14.114.x/src rt-ac5300 mainline
		fi
		if [ "$BAC86" = "y" ]; then
			clean_tree amng.ac86 release/src-rt-5.02hnd rt-ac86u mainline
		fi
		if [ "$BAX88" = "y" ]; then
			clean_tree amng.ax88 release/src-rt-5.02axhnd rt-ax88u ax
		fi
		if [ "$BAX58" = "y" ]; then
			clean_tree amng.ax58 release/src-rt-5.02axhnd.675x rt-ax58u ax
		fi
		echo "--- $(date +%R) - All trees ready!"
		echo

		# Launch parallel builds

		echo "--- $(date +%R) - Launching all builds"
		if [ "$BAC56" = "y" ]; then
			build_fw amng.ac56/release/src-rt-6.x.4708 rt-ac56u master &
			sleep 20
		fi
		if [ "$BAC68" = "y" ]; then
			build_fw amng.ac68/release/src-rt-6.x.4708 rt-ac68u mainline &
			sleep 20
		fi
		if [ "$BAC87" = "y" ]; then
			build_fw amng.ac87/release/src-rt-6.x.4708 rt-ac87u 384.13_x &
			sleep 20
		fi
		if [ "$BAC3200" = "y" ]; then
			build_fw amng.ac3200/release/src-rt-7.x.main/src rt-ac3200 384.13_x &
			sleep 20
		fi
		if [ "$BAC3100" = "y" ]; then
			build_fw amng.ac3100/release/src-rt-7.14.114.x/src rt-ac3100 mainline &
			sleep 20
		fi
		if [ "$BAC88" = "y" ]; then
			build_fw amng.ac88/release/src-rt-7.14.114.x/src rt-ac88u mainline &
			sleep 20
		fi
		if [ "$BAC5300" = "y" ]; then
			build_fw amng.ac5300/release/src-rt-7.14.114.x/src rt-ac5300 mainline &
			sleep 10
		fi
		if [ "$BAC86" = "y" ]; then
			build_fw amng.ac86/release/src-rt-5.02hnd rt-ac86u mainline &
			sleep 10
		fi
		if [ "$BAX88" = "y" ]; then
			build_fw amng.ax88/release/src-rt-5.02axhnd rt-ax88u ax &
			sleep 10
		fi
		if [ "$BAX58" = "y" ]; then
			build_fw amng.ax58/release/src-rt-5.02axhnd.675x rt-ax58u ax &
			sleep 10
		fi

		echo "--- $(date +%R) - All builds launched, please wait..."

		wait

		echo
		cd "$STAGE_LOC" || exit 1
		{ sha256sum -- *.trx
		sha256sum -- *.w; } 2>/dev/null | unix2dos > sha256sums-ng.txt

		# Copy everything to the host

		if [ -n "$FINAL_LOC" ] && [ -f "$HOME/amcfwm/build.success" ]; then
			scp -P "$SSH_PORT" -- *.zip *.trx *.txt *.w "$FINAL_LOC/" 2>/dev/null
			rm -rf "$HOME/amcfwm/build.success"
		fi

		echo "=== $(date +%R) - All done!"
	;;

	install)
		sudo apt-get update
		sudo apt-get -y dist-upgrade
		sudo dpkg --add-architecture i386
		sudo apt-get update
		sudo apt-get -y install lib32ncurses5-dev dos2unix libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison bzip2 diffutils file flex m4 g++ gawk groff-base libncurses5-dev libtool libslang2 make patch perl pkg-config shtool subversion tar texinfo zlib1g zlib1g-dev git gettext libexpat1-dev libssl-dev cvs gperf unzip python libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libelf1 libglib2.0-dev xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools libelf-dev:i386 libelf1:i386 libltdl-dev openssh-server curl git build-essential nano
		if [ ! -f "$HOME/Desktop/amcfwm.sh" ]; then curl -fsL --retry 3 "https://raw.githubusercontent.com/Adamm00/am_cfwm/master/amcfwm.sh" -o "$HOME/amcfwm/amcfwm.sh"; fi
		sudo ln -sf "$HOME/amcfwm/amcfwm.sh" /bin/amcfwm
		chmod 755 /bin/amcfwm
		mkdir -p ~/images
		echo
		if [ ! -f ~/.ssh/id_rsa ]; then
			ssh-keygen -b 4096
		fi
		echo "Your SSH Pubkey For Remote Access - [Press Enter To Continue]"
		cat ~/.ssh/id_rsa.pub
		read -r
		echo "Setting Up OpenSSH-Server - Input authorized_keys - [Press Enter To Continue]"
		read -r
		sudo nano -w ~/.ssh/authorized_keys
		echo "Hardening OpenSSH Config"
		echo "Password Authentication Disabled"
		echo "SSH Port Changed To 4216"
		sed -i 's~#Port 22~Port 4216~g' /etc/ssh/sshd_config
		sed -i 's~#ChallengeResponseAuthentication yes~ChallengeResponseAuthentication no~g' /etc/ssh/sshd_config
		sed -i 's~#PasswordAuthentication yes~PasswordAuthentication no~g' /etc/ssh/sshd_config
		echo "Input MOTD - [Press Enter To Continue]"
		read -r
		rm -rf /etc/update-motd.d/80-livepatch /etc/update-motd.d/50-motd-news /etc/update-motd.d/80-esm /etc/update-motd.d/91-release-upgrade /etc/update-motd.d/95-hwe-eol
		true > /etc/update-motd.d/10-help-text
		sudo nano -w /etc/update-motd.d/10-help-text
		Set_Default
		echo "Rebooting To Apply Updates - [Press Enter To Continue]"
		read -r
		sudo rm -f /bin/sh && sudo ln -sf bash /bin/sh && sudo reboot
	;;

	repo)
		sudo rm -rf ~/am-toolchains ~/amng /opt
		sudo mkdir -p /opt

		cd ~ || exit 1
		if [ ! -d ~/am-toolchains ]; then
			echo "Preparing Toolchain Repo"
			git clone https://github.com/RMerl/am-toolchains.git
			sudo ln -s ~/am-toolchains/brcm-arm-hnd /opt/toolchains
		fi
		if [ ! -d ~/amng ]; then
			echo "Preparing Firmware Repo"
			git clone https://github.com/RMerl/asuswrt-merlin.ng amng
		fi

		sed -i '\~AsusWRT-Merlin CFW Manager~d' ~/.profile

		# BCM-SDK
		sudo ln -fs ~/am-toolchains/brcm-arm-sdk/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/brcm-arm
		sudo ln -fs ~/am-toolchains/brcm-arm-sdk  ~/amng/release/src-rt-6.x.4708/toolchains
		echo "PATH=$PATH:/opt/brcm-arm/bin # AsusWRT-Merlin CFW Manager" >> ~/.profile

		# BCM-HND
		sudo ln -fs ~/am-toolchains/brcm-arm-hnd /opt/toolchains
		{ echo "export LD_LIBRARY_PATH=$LD_LIBRARY:/opt/toolchains/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/lib # AsusWRT-Merlin CFW Manager"
		echo "export TOOLCHAIN_BASE=/opt/toolchains # AsusWRT-Merlin CFW Manager"
		echo "PATH=\$PATH:/opt/toolchains/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/bin # AsusWRT-Merlin CFW Manager"
		echo "PATH=\$PATH:/opt/toolchains/crosstools-aarch64-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25/usr/bin # AsusWRT-Merlin CFW Manager"; } >> ~/.profile

		# BCM-HND AX
		{ echo "export LD_LIBRARY_PATH=$LD_LIBRARY:/opt/toolchains/crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1/usr/lib # AsusWRT-Merlin CFW Manager"
		echo "PATH=\$PATH:/opt/toolchains/crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1/usr/bin # AsusWRT-Merlin CFW Manager"
		echo "PATH=\$PATH:/opt/toolchains/crosstools-aarch64-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1/usr/bin # AsusWRT-Merlin CFW Manager"; } >> ~/.profile

		echo
		echo "Repo Setup Complete!"
		echo
	;;

	settings)
		case "$2" in
			srcloc)
				if [ -z "$3" ]; then echo "[*] Source Location Not Specified - Exiting"; echo; exit 1; fi
				if [ -z "$3" ]; then echo "[*] Source Location Doesn't Exist - Exiting"; echo; exit 1; fi
				SRC_LOC="$3"
				echo "[i] Source Location Set To $SRC_LOC"
			;;
			stageloc)
				if [ -z "$3" ]; then echo "[*] Stage Location Not Specified - Exiting"; echo; exit 1; fi
				if [ -z "$3" ]; then echo "[*] Stage Location Doesn't Exist - Exiting"; echo; exit 1; fi
				STAGE_LOC="$3"
				echo "[i] Stage Location Set To $STAGE_LOC"
			;;
			finalloc)
				if [ -z "$3" ]; then echo "[*] Final Location Not Specified - Exiting"; echo; exit 1; fi
				FINAL_LOC="$3"
				echo "[i] Final Location Set To $FINAL_LOC"
			;;
			sshport)
				if [ -z "$3" ]; then echo "[*] Remote SSH Port Not Specified - Exiting"; echo; exit 1; fi
				if ! [ "$3" -eq "$3" ] 2>/dev/null; then echo "[*] $3 Isn't A Valid Port Number!"; echo; exit 1; fi
				SSH_PORT="$3"
				echo "[i] Remote SSH Port Set To $SSH_PORT"
			;;
			buildrev)
				case "$3" in
					enable)
						BUILDREV="y"
						echo "[i] Build Revision String Enabled"
					;;
					disable)
						BUILDREV="n"
						echo "[i] Build Revision String Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			rsynctree)
				case "$3" in
					enable)
						RSYNC_TREE="y"
						echo "[i] Rsync Tree Enabled"
					;;
					disable)
						RSYNC_TREE="n"
						echo "[i] Rsync Tree Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			cleanuptree)
				case "$3" in
					enable)
						CLEANUP_TREE="y"
						echo "[i] Cleanup Tree Enabled"
					;;
					disable)
						CLEANUP_TREE="n"
						echo "[i] Cleanup Tree Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			forcebuild)
				case "$3" in
					enable)
						FORCEBUILD="y"
						echo "[i] Force Image Build Enabled"
					;;
					disable)
						FORCEBUILD="n"
						echo "[i] Force Image Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac56)
				case "$3" in
					enable)
						BAC56="y"
						echo "[i] AC56U Build Enabled"
					;;
					disable)
						BAC56="n"
						echo "[i] AC56U Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac68)
				case "$3" in
					enable)
						BAC68="y"
						echo "[i] AC68U Build Enabled"
					;;
					disable)
						BAC68="n"
						echo "[i] AC68U Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac87)
				case "$3" in
					enable)
						BAC87="y"
						echo "[i] AC87U Build Enabled"
					;;
					disable)
						BAC87="n"
						echo "[i] AC87U Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac3200)
				case "$3" in
					enable)
						BAC3200="y"
						echo "[i] AC3200 Build Enabled"
					;;
					disable)
						BAC3200="n"
						echo "[i] AC3200 Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac88)
				case "$3" in
					enable)
						BAC88="y"
						echo "[i] AC88U Build Enabled"
					;;
					disable)
						BAC88="n"
						echo "[i] AC88U Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac3100)
				case "$3" in
					enable)
						BAC3100="y"
						echo "[i] AC3100 Build Enabled"
					;;
					disable)
						BAC3100="n"
						echo "[i] AC3100 Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac5300)
				case "$3" in
					enable)
						BAC5300="y"
						echo "[i] AC5300 Build Enabled"
					;;
					disable)
						BAC68="n"
						echo "[i] AC5300 Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bac86)
				case "$3" in
					enable)
						BAC86="y"
						echo "[i] AC86U Build Enabled"
					;;
					disable)
						BAC86="n"
						echo "[i] AC86U Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bax88)
				case "$3" in
					enable)
						BAX88="y"
						echo "[i] AX88U Build Enabled"
					;;
					disable)
						BAX88="n"
						echo "[i] AX88U Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			bax58)
				case "$3" in
					enable)
						BAX58="y"
						echo "[i] AX58U Build Enabled"
					;;
					disable)
						BAX58="n"
						echo "[i] AX58U Build Disabled"
					;;
					*)
						echo "Command Not Recognized, Please Try Again"
						echo "For Help Check https://github.com/Adamm00/am_cfwm"
						echo; exit 2
					;;
				esac
			;;
			reset)
				Set_Default
				echo "[i] All Settings Reset"
			;;
		esac
	;;

	update)
		remotedir="https://raw.githubusercontent.com/Adamm00/am_cfwm/master"
		localver="$(Filter_Version < "$0")"
		remotever="$(curl -fsL --retry 3 --connect-timeout 3 "${remotedir}/amcfwm.sh" | Filter_Version)"
		localmd5="$(md5sum "$0" | awk '{print $1}')"
		remotemd5="$(curl -fsL --retry 3 --connect-timeout 3 "${remotedir}/amcfwm.sh" | md5sum | awk '{print $1}')"
		if [ "$localmd5" = "$remotemd5" ] && [ "$2" != "-f" ]; then
			echo "[i] AMCFWM Up To Date - $localver (${localmd5})"
		elif [ "$localmd5" != "$remotemd5" ] && [ "$2" = "check" ]; then
			echo "[i] AMCFWM Update Detected - $remotever (${remotemd5})"
		elif [ "$2" = "-f" ]; then
			echo "[i] Forcing Update"
		fi
		if [ "$localmd5" != "$remotemd5" ] || [ "$2" = "-f" ]; then
			echo "[i] New Version Detected - Updating To $remotever (${remotemd5})"
			curl -fsL --retry 3 --connect-timeout 3 "${remotedir}/amcfwm.sh" -o "$0"
			echo "[i] Update Complete!"
			echo
			exit 0
		fi
	;;

	uninstall)
		echo "If You Were Experiencing Issues, Try Update Or Visit SNBForums/Github For Support"
		echo "https://github.com/Adamm00/am_cfwm"
		echo
		while true; do
			echo "[!] Warning - This Will Delete All Files Related To The Project"
			echo "Are You Sure You Want To Uninstall?"
			echo
			echo "[1]  --> Yes"
			echo "[2]  --> No"
			echo
			echo "Please Select Option"
			printf "[1-2]: "
			read -r "continue"
			echo
			case "$continue" in
				1)
					sudo rm -rf "$HOME/am-toolchains" "$HOME/amng"  "$HOME"/amng.* "/opt"
					sed -i '\~AsusWRT-Merlin CFW Manager~d' ~/.profile
					sudo rm -rf "$HOME/amcfwm" "/bin/setup" "/bin/build"
					sudo rm -rf /etc/update-motd.d/10-help-text
				;;
				2|e|exit)
					echo "[*] Exiting!"
					echo; exit 0
				;;
				*)
					echo "[*] $continue Isn't An Option!"
					echo
				;;
			esac
		done
esac

echo
Write_Config
rm -rf "$HOME/amcfwm/amcfwm.lock"
if [ -n "$reloadmenu" ]; then echo; printf "[i] Press Enter To Continue..."; read -r continue; exec "$0"; fi