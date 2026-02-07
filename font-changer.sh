#!/bin/bash
set -euo pipefail

# -------------------------- Change dir to current -----------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${SCRIPT_DIR}" >/dev/null
# ------------------------------------------------------------------------

# ---------------------- Dependency checks --------------------------------
for cmd in tput sed fc-cache xdg-open; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ERROR: Required command '$cmd' not found. Please install it." >&2
        exit 1
    fi
done
# ------------------------------------------------------------------------

# -------------------------- Colored tput outputs ------------------------
red=$(tput setaf 9 2>/dev/null || echo '');
yellow=$(tput setaf 11 2>/dev/null || echo '');
green=$(tput setaf 10 2>/dev/null || echo '');
cyan=$(tput setaf 14 2>/dev/null || echo '');
white=$(tput setaf 15 2>/dev/null || echo '');
bold=$(tput bold 2>/dev/null || echo '');
end=$(tput sgr0 2>/dev/null || echo '');

# ------------------------------ Welcome log -----------------------------
printf \
"
${yellow}${bold}Welcome to Sinhala Font Changer Script!!!

${cyan}This Script will add a configuration file for font config library in
\"~/.config/fontconfig/conf.d/50-si-custom.conf\", this will render
any sinhala text in a sinhala font you choose in the next steps. Script
will install fonts if they are not already installed. New fonts will be
installed to \"~/.local/share/fonts/sinhala-font-changer/(font family name)/(font).ttf\"

Since all actions are done in user level, no settings will apply system
wide. If you need settings to apply system wide, either do it manually
or run the script for each user.
\n"
# -------------------------------------------------------------------------

read -p "${green}Press enter to continue> "

# --------------- Change system sinhala font -----------------------------

printf \
"
${cyan}Select the font you want to set as the sinhala font. Type the corresponding 
number of the font you like. Visit the link in the bracket to preview how 
each font will look like. 

${green}Here are your options, 
${yellow}
1 - Noto Sans Sinhala
2 - Noto Serif Sinhala
3 - UN-Gurulugomi
4 - tuxSinhala Bold
n - exit
"

while true
do
  read -p "${green}select the font (type the number)> " selected_font_code
  case $selected_font_code in
       1)
          selected_font="Noto Sans Sinhala"
          break
          ;;
       2)
          selected_font="Noto Serif Sinhala"
          break
          ;;
       3)
          selected_font="UN-Gurulugomi"
          break
          ;;
       4)
          selected_font="tuxSinhala Bold" 
          break
          ;;
       n)
          echo "${end}"
          exit
          break
          ;;
       *)
          echo "${red}ERROR!: only 1,2,3,4 or n is accepted. n to exit the script."
          ;;
  esac
done  

echo -e "\n${cyan}Now installing \"${green}$selected_font${cyan}\" font,"

# Clean up old fonts from previous installations
font_base_dir="${HOME}/.local/share/fonts/sinhala-font-changer"
if [ -d "$font_base_dir" ]; then
    echo "${yellow}Removing previously installed fonts..."
    rm -rf "$font_base_dir"
fi

copy_dest="${font_base_dir}/${selected_font}"
mkdir -p "$copy_dest"
cp ./fonts/"${selected_font}"/* "$copy_dest"

echo "${cyan}Setting up \"${green}$selected_font${cyan}\" as the system-wide sinhala font,"

mkdir -p "${HOME}/.config/fontconfig/conf.d"
temp_conf=$(mktemp)

# First replace FONT_PLACE_HOLDER
sed "s/FONT_PLACE_HOLDER/${selected_font}/g" 50-si-custom.conf > "$temp_conf"

# Build and inject blacklist for other Sinhala fonts
all_fonts=("Noto Sans Sinhala" "Noto Serif Sinhala" "UN-Gurulugomi" "tuxSinhala Bold")
blacklist_file=$(mktemp)

for font in "${all_fonts[@]}"; do
    if [ "$font" != "$selected_font" ]; then
        cat >> "$blacklist_file" << EOF
		<rejectfont>
			<pattern>
				<patelt name="family">
					<string>${font}</string>
				</patelt>
				<patelt name="lang">
					<string>si</string>
				</patelt>
			</pattern>
		</rejectfont>
EOF
    fi
done

# Replace BLACKLIST_PLACE_HOLDER with contents of blacklist file
sed -e "/<!-- BLACKLIST_PLACE_HOLDER -->/r $blacklist_file" -e "/<!-- BLACKLIST_PLACE_HOLDER -->/d" \
    "$temp_conf" > "${HOME}/.config/fontconfig/conf.d/50-si-custom.conf"

rm -f "$temp_conf" "$blacklist_file"

fc-cache -f

echo -e "${cyan}Configuration is now completed!,"
echo -e "${cyan}Current sinhala font is:\n ${yellow}$(LANG=si fc-match)"

echo -e "${green}Done!..${end}"

sed "s/FONT_PLACE_HOLDER/${selected_font}/g" test-current-sinhala-font > current-sinhala-font.txt
xdg-open current-sinhala-font.txt &>/dev/null || true

popd >/dev/null
# ------------------------------------------------------------------------
