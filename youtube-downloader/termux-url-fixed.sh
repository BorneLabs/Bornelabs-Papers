#!/data/data/com.termux/files/usr/bin/bash
#
# —————————————————————————
#  Termux-YTD (fixed format selectors)
# —————————————————————————

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

# If yt-dlp isn’t installed, exit immediately
if ! command -v yt-dlp >/dev/null 2>&1; then
  printf "${RED_B}Error:${RESET} yt-dlp not found. Please run the installer or 'pip install yt-dlp'.\n"
  exit 1
fi

OUTPUT_PATH="/storage/emulated/0/Youtube"
mkdir -p "${OUTPUT_PATH}" 2>/dev/null

clear

# — New ASCII Art Banner (in RED) —
cat <<EOF
${RED}
                                999999999999999999999999999999999999    
                              9999999999999999999999999999999999999999  
 0000  0000                   999         99999999   499999999999999999 
 0000  0000                  9999         99999999   499999999999999999 
  00000000  0000    000 000  999999    99646994499   46 3999995 1999999 
   000000 00000000 0000 000  999999    99   99   9        99       9999 
    00000 000  000 0000 000  999999    99   99   9   49   53   93   999 
    0000  000  000 0000 000  999999    99   99   9   49   51        999 
    0000  000  000 0000 000  999999    99   99   9   49   51   99999999 
    0000  000  000 0000 000  999999    99   99   9   49   53   93   999 
    0000   0000000 00000000  999999    99        9        99       9999 
     00      000     00  00   99999966999955996699966995499999625999999 
                              9999999999999999999999999999999999999999  
                                999999999999999999999999999999999999   

                           Youtube Downloader
                           @Bornelabs Papers
${RESET}
EOF

# Menu & Info
echo -e "${CYAN}╔════════════════════════════════════════╗"
echo -e "${RED}║ ♚ Paper   : Youtube Downloader         ║"
echo -e "${GREEN}║ ♚ Author  : @BrianxBorne               ║"
echo -e "${CYAN}╠════════════════════════════════════════╝"
echo -e "${CYAN}╠═▶ [𝗦𝗲𝗹𝗲𝗰𝘁 𝗔 𝗙𝗼𝗿𝗺𝗮𝘁]  ➳"
echo -e "${GREEN}╠═▶ 1. Music (mp3)"
echo -e "${GREEN}╠═▶ 2. Video 360p"
echo -e "${GREEN}╠═▶ 3. Video 480p"
echo -e "${GREEN}╠═▶ 4. Video 720p"
echo -e "${GREEN}╠═▶ 5. Video 1080p"
echo -e "${GREEN}╠═▶ 6. Video 2160p (4K)"
echo -e "${GREEN}╠═▶ 7. Exit Termux-YTD"
printf "${GREEN} ╚═:➤  ${RESET}"
read -r option

if [[ -z "$option" ]]; then
  clear
  printf "${RED_B}Please choose an option!\n${RESET}"
  exit 1
fi

# Make sure a URL was provided as $1
if [[ -z "$1" ]]; then
  printf "${RED_B}Error:${RESET} You must pass a YouTube URL as the first argument.\nUsage: %s <youtube-url>\n" "$0"
  exit 1
fi

URL="$1"

case "$option" in
  1)
    #  — Extract audio, convert to MP3
    yt-dlp \
      --no-warnings \
      -x \
      --audio-format mp3 \
      --audio-quality 0 \
      -o "${OUTPUT_PATH}/%(title)s.%(ext)s" \
      "$URL"
    ;;
  2)
    #  — Best video ≤360p, plus best audio (fallback to best[height<=360] if mux not possible)
    yt-dlp \
      --no-warnings \
      -f "bestvideo[height<=360]+bestaudio/best[height<=360]" \
      -o "${OUTPUT_PATH}/%(title)s.%(ext)s" \
      "$URL"
    ;;
  3)
    #  — Best video ≤480p
    yt-dlp \
      --no-warnings \
      -f "bestvideo[height<=480]+bestaudio/best[height<=480]" \
      -o "${OUTPUT_PATH}/%(title)s.%(ext)s" \
      "$URL"
    ;;
  4)
    #  — Best video ≤720p
    yt-dlp \
      --no-warnings \
      -f "bestvideo[height<=720]+bestaudio/best[height<=720]" \
      -o "${OUTPUT_PATH}/%(title)s.%(ext)s" \
      "$URL"
    ;;
  5)
    #  — Best video ≤1080p
    yt-dlp \
      --no-warnings \
      -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" \
      -o "${OUTPUT_PATH}/%(title)s.%(ext)s" \
      "$URL"
    ;;
  6)
    #  — Best video ≤2160p (4K)
    yt-dlp \
      --no-warnings \
      -f "bestvideo[height<=2160]+bestaudio/best[height<=2160]" \
      -o "${OUTPUT_PATH}/%(title)s.%(ext)s" \
      "$URL"
    ;;
  7)
    exit 0
    ;;
  *)
    printf "${RED_B}Invalid option! Exiting.${RESET}\n"
    exit 1
    ;;
esac

# Check exit code
if [ $? -eq 0 ]; then
  printf "${GREEN_B}Files correctly downloaded at ${OUTPUT_PATH}!${RESET}\n"
else
  printf "${RED_B}An error occurred when downloading the files!${RESET}\n"
  exit 1
fi

# If running inside Termux with TERMUX_API_VERSION set, scan media
if [ -n "$TERMUX_API_VERSION" ]; then
  printf "${YELLOW_B}Scanning ${OUTPUT_PATH}…${RESET}\n"
  termux-media-scan -v -r "${OUTPUT_PATH}"
  if [ $? -eq 0 ]; then
    printf "${GREEN_B}${OUTPUT_PATH} correctly scanned${RESET}\n"
  else
    printf "${RED_B}An error occurred during ${OUTPUT_PATH} scanning${RESET}\n"
  fi
fi

printf "${MAGENTA_B}Program completed. Press any key to exit.${RESET}\n"
read -r x

