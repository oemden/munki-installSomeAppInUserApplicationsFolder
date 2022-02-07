#!/bin/bash
#
# oem at oemden dot com - verify if  App is Installed in User's app folder
#
## need a preinstall script to check if app exist
version="2.0" ## version checks OK.
#
############ IMPORTANT EDIT ACCORDINGLY for EACH NEW VERSION ###############
APP_VERSION="2.0.19" ## NB = (2.0.19 - X86_64) (2.0.18 - arm64 )
############################### EDIT END ##################################

OLDIFS=$IFS
IFS="." read appvers_major_s appvers_minor_s appvers_dot_s <<< "${APP_VERSION}"
IFS=$OLDIFS
dev=0
DEFAULTS=/usr/bin/defaults

LOGIN="$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')"
LOGINHOMEDIR="$(/usr/bin/dscl . -read /Users/$LOGIN | grep 'NFSHomeDirectory:' | grep -v 'OriginalNFSHomeDirectory:' | awk '{print $2}')"
LOGINAPPDIR="${LOGINHOMEDIR}/Applications"
NOTION_APP="Some App.app"
NOTION_USER_APP="${LOGINAPPDIR}/${NOTION_APP}"

function echodev {
 if [[ "${dev}" == 1 ]] ; then
  echo "${1}"
 fi

}

echodev "appvers_major_s: ${appvers_major_s}"
echodev "appvers_minor_s: ${appvers_minor_s}"
echodev "appvers_dot_s: ${appvers_dot_s}"

if [[ ! -d "${NOTION_USER_APP}" ]] ; then
  echo "No User app, Install the App "
  exit 0 ## aka do the install
else

## Check the App Version
  APP_CFBundleVersion="$(${DEFAULTS} read ${NOTION_USER_APP}/Contents/Info.plist CFBundleVersion)"
  OLDIFS=$IFS
  IFS="." read appvers_major_d appvers_minor_d appvers_dot_d <<< "${APP_CFBundleVersion}"
  IFS=$OLDIFS
  echodev "appvers_major_d: ${appvers_major_d}"
  echodev "appvers_minor_d: ${appvers_minor_d}"
  echodev "appvers_dot_d: ${appvers_dot_d}"

  echodev "APP_CFBundleVersion: ${APP_CFBundleVersion}"
  if [[ "${APP_CFBundleVersion}" == "${APP_VERSION}" ]] ; then
   echo "good version, no need to install App"
   exit 1
  elif [[ "${APP_CFBundleVersion}" != "${APP_VERSION}" ]] ; then
   if [[ "${appvers_major_d}" -lt "${appvers_major_s}" ]] ; then
  	echo "Major version inferior, install the app"
  	exit 0
   elif [[ "${appvers_major_d}" -gt "${appvers_major_s}" ]] ; then
  	echo "Major version superior, DO NOT install the app"
  	exit 1
   elif [[ "${appvers_major_d}" == "${appvers_major_s}" ]] ; then
    echo "same Major version checking Minor version"
    if [[ "${appvers_minor_d}" -lt "${appvers_minor_s}" ]] ; then
  	echo "Major version inferior, install the app"
  	exit 0
    elif [[ "${appvers_minor_d}" -gt "${appvers_minor_s}" ]] ; then
  	echo "Major version superior, DO NOT install the app"
  	exit 1
    elif [[ "${appvers_minor_d}" == "${appvers_minor_s}" ]] ; then
    echo "same Minor version checking dot version"
     if [[ "${appvers_dot_d}" -lt "${appvers_dot_s}" ]] ; then
      echo "dot version inferior, install the app"
  	  exit 0
     elif [[ "${appvers_dot_d}" -ge "${appvers_dot_s}" ]] ; then
  	  echo "dot version superior or equal, DO NOT install the app"
  	  exit 1
     fi
    fi
   fi
  fi
 fi
