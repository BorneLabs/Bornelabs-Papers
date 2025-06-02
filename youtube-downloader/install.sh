#!/data/data/com.termux/files/usr/bin/bash

# @Bornelabs Papers
# Coded by: BrianxBorne (updated 02/06/2025)
# Github:  https://github.com/Bornelabs/Bornelabs-Papers

# ──────────────────────────────────────────────────────────────────────────────
# COLORS
GREEN="\e[32m"
CYAN="\e[36m"
MAGENTA="\e[35m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"

# BOLD COLORS
GREEN_B="\e[01;32m"
CYAN_B="\e[01;36m"
MAGENTA_B="\e[01;35m"
YELLOW_B="\e[01;33m"
BLUE_B="\e[01;34m"
RED_B="\e[01;31m"

# RESET
RESET="\e[0m"
# ──────────────────────────────────────────────────────────────────────────────

TERMUX_HOME="/data/data/com.termux/files/home"
BIN_DIR="${TERMUX_HOME}/bin"
OUTPUT_PATH="${TERMUX_HOME}/storage/shared/Youtube"

printf "${GREEN}=== Retrieving package lists and updating…${RESET}\n"
pkg update -y && pkg upgrade -y

# Ensure storage permission is granted (so ~/storage/shared becomes available).
if [ ! -d "${TERMUX_HOME}/storage" ]; then
  printf "${YELLOW}Requesting access to storage…${RESET}\n"
  sleep 1
  termux-setup-storage
fi

# Install python (if missing)
if ! command -v python >/dev/null 2>&1; then
  printf "${CYAN}Installing python…${RESET}\n"
  sleep 1
  pkg install python -y
else
  printf "${GREEN_B}Python is already installed.${RESET}\n"
fi

# Install pip (if missing)
if ! command -v pip >/dev/null 2>&1; then
  printf "${CYAN}Installing pip…${RESET}\n"
  sleep 1
  pkg install python-pip -y
else
  printf "${GREEN_B}pip is already installed.${RESET}\n"
fi

# Install yt-dlp (via pip) if not present
if ! pip show yt-dlp >/dev/null 2>&1; then
  printf "${CYAN}Installing yt-dlp…${RESET}\n"
  sleep 1
  pip install yt-dlp
else
  printf "${GREEN_B}yt-dlp is already installed via pip.${RESET}\n"
fi

# Install ffmpeg (required to merge audio+video)
if ! command -v ffmpeg >/dev/null 2>&1; then
  printf "${CYAN}Installing ffmpeg…${RESET}\n"
  sleep 1
  pkg install ffmpeg -y
else
  printf "${GREEN_B}ffmpeg is already installed.${RESET}\n"
fi

# Create the shared “Youtube” folder if needed
if [ ! -d "${OUTPUT_PATH}" ]; then
  printf "${CYAN}Creating output directory at \"${OUTPUT_PATH}\"…${RESET}\n"
  sleep 1
  mkdir -p "${OUTPUT_PATH}"
else
  printf "${GREEN_B}Output directory already exists: ${OUTPUT_PATH}${RESET}\n"
fi

# Create ~/bin if it doesn’t exist
mkdir -p "${BIN_DIR}"

# Copy our downloader script into ~/bin/termux-url-opener
#
# Expectation: The user has already placed "termux-ytd-fixed.sh" in the same directory
# as this install.sh. Adjust the filename below if yours is named differently.
#
SCRIPT_SOURCE="termux-ytd-fixed.sh"
SCRIPT_TARGET="${BIN_DIR}/termux-url-opener"

if [ -f "${SCRIPT_SOURCE}" ]; then
  printf "${BLUE}Installing Termux-YTD downloader…${RESET}\n"
  sleep 1
  cp -f "${SCRIPT_SOURCE}" "${SCRIPT_TARGET}"
  chmod +x "${SCRIPT_TARGET}"
  printf "${GREEN_B}Successfully installed: ${SCRIPT_TARGET}${RESET}\n"
else
  printf "${RED_B}Error:${RESET} Could not find \"${SCRIPT_SOURCE}\" in this folder.${RESET}\n"
  printf "${YELLOW}Please make sure you put your fixed downloader script next to install.sh, and name it exactly:\n  ${MAGENTA}\"${SCRIPT_SOURCE}\"${RESET}\n"
  exit 1
fi

# Prompt to install termux-api (so termux-media-scan can work)
printf "\n${RED_B}WARNING!!!${RESET}\n${YELLOW}By default, downloaded videos won't immediately show up in your system gallery.\n"
printf "To enable automatic media scanning, you need to:\n"
printf "  1) Install the Termux:API APK from F-Droid or Play Store\n"
printf "  2) Install the termux-api package inside Termux\n${RESET}\n"

read -rp "Do you want to install \"termux-api\" right now? (Y/n) " RES
USER_ANS="${RES^^}"
USER_ANS="${USER_ANS:0:1}"

if [ "$USER_ANS" = "Y" ] || [ -z "$USER_ANS" ]; then
  printf "\n${CYAN}Installing termux-api package…${RESET}\n"
  sleep 1
  pkg install termux-api -y
  if [ $? -eq 0 ]; then
    printf "${GREEN_B}termux-api installed successfully.${RESET}\n"
    printf "${YELLOW}Reminder: You still need the Termux:API APK to let termux-media-scan work.${RESET}\n"
  else
    printf "${RED_B}An error occurred while installing termux-api.${RESET}\n"
  fi
else
  printf "${YELLOW}Skipped termux-api installation. You can install it later with:\n  pkg install termux-api${RESET}\n"
fi

printf "\n${CYAN_B}Installation Complete!${RESET}\n"
printf "${CYAN}Open a YouTube video → Share → Termux → choose a quality → Download will start automatically.${RESET}\n"
printf "${GREEN}@Bornelabs Papers — Youtube Downloader${RESET}\n"

