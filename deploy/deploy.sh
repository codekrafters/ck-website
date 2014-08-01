#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# ========================================================
# terminal colors
black='\x1B[30;40m'
red='\x1B[31;40m'
green='\x1B[32;40m'
yellow='\x1B[33;40m'
blue='\x1B[34;40m'
magenta='\x1B[35;40m'
cyan='\x1B[36;40m'
white='\x1B[37;40m'

cecho () {
  # Only use coloring when using an interactive shell of supported
  # flavors.
  if [ -t 0 -o -S /dev/stdin ]; then
    if [ "${TERM}" = "xterm"  \
      -o "${TERM}" = "screen" \
      -o "${TERM}" = "ansi" ]; then
      echo -n -e "${1}"
      echo -n "${2}"
      tput sgr0
      echo
    else
      echo "${2}"
    fi
  else
    echo "${2}"
  fi
  return 0
}

# ========================================================
blue_echo() {
  cecho $blue "$1" >&2
}

# ========================================================
green_echo() {
  cecho $green "$1" >&2
}

# ========================================================
red_echo() {
  cecho $red "$1" >&2
}

# ========================================================
warn() {
  cecho $blue "$TIMESTAMP: $1" >&2
}


# ========================================================
die() {
  cecho $red "$TIMESTAMP: $1" >&2
  exit 1
}

echo ""
echo "********************************"
echo "updating codekrafter.com website"
echo "--> source: https://github.com/codekrafters/ck-website.git"
echo "--> target: ftp://codekrafters@c40.46b.myftpupload.com"
echo "********************************"
echo ""

# check ftp password provided as argument
FTP_PWD="$1"
if [ -z "$FTP_PWD" ]; then
	echo "ftp password must be provided as argument"
	echo "usage: deploy.sh FTP_PASSWORD"
	die "ftp password missing"
fi

# check ncftp available
CHECK=`which ncftp`
if [ -z "$CHECK" ]; then
	echo "ncftp package is required in order to recursively update directories."
	echo "you can install it using the .dmg file inside the deploy folder"
	die "required package not installed: ncftp"
fi

SHORT_DATE=$(date "+%Y-%m-%d")
echo "creating temp directory"
mkdir -v "$SHORT_DATE"
cd "$SHORT_DATE"
echo "pulling latest master branch from github"
echo ""
echo "********************************"
git clone https://github.com/codekrafters/ck-website.git
echo "********************************"
echo ""
cd ck-website
rm -rf .git
rm -rf deploy
cd ..
echo "********************************"
ncftpput -R -v -u 'codekrafters' -p "$FTP_PWD" c40.46b.myftpupload.com / ck-website/
echo "********************************"
echo ""
echo "update completed"
cd ..
echo "cleanup temporary folders"
rm -rf "$SHORT_DATE"
echo ""
echo "********************************"
echo "job done -- go check codekrafters.com"