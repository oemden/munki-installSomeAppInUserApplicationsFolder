#!/bin/bash
#
# oem at oemden dot com - Install App in User's app folder
#
## need a preinstall script to check if app exist
version="2.0" ## RC
#

DEFAULTS=/usr/bin/defaults

########################## EDIT END #############################
LOGIN="$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')"
LOGINHOMEDIR="$(/usr/bin/dscl . -read /Users/$LOGIN | grep 'NFSHomeDirectory:' | grep -v 'OriginalNFSHomeDirectory:' | awk '{print $2}')"
LOGINAPPDIR="${LOGINHOMEDIR}/Applications"
TO_INSTALLAPP="Some App.app"
TO_INSTALLTMP_APP="/tmp/${TO_INSTALLAPP}"
TO_INSTALLUSER_APP="${LOGINAPPDIR}/${TO_INSTALLAPP}"


function echovar {
 echo "LOGIN: ${LOGIN}"
 echo "LOGINHOMEDIR: ${LOGINHOMEDIR}"
 echo "LOGINAPPDIR: ${LOGINAPPDIR}"
 echo "TO_INSTALLUSER_APP: ${TO_INSTALLUSER_APP}"
}

echovar

# su as loggedin user

## Check Notion app in tmp
if [[ ! "${TO_INSTALLTMP_APP}" ]] ; then
 echo "no ${TO_INSTALLAPP} in /tmp, something is wrong"
fi

## Check User's Applications folder
if [[ ! -d "${LOGINAPPDIR}" ]] ; then
 echo "no User Applications folder, creating it"
 mkdir -p "${LOGINAPPDIR}"
 chown "${LOGIN}" "${LOGINAPPDIR}"
else
 echo "User has Applications folder"
fi

## NOTE: munki's preinstallCheck script has taken of version check
## now let's install the App
echo "${TO_INSTALLAPP} not installed, Installing it "
xattr -r -d com.apple.quarantine "${TO_INSTALLTMP_APP}"
cp -Ra "${TO_INSTALLTMP_APP}" "${LOGINAPPDIR}/"
chown -R "${LOGIN}" "${LOGINAPPDIR}"

## cleanUP
echo "Cleaning Up"
rm -Rf "${TO_INSTALLTMP_APP}"
## in case the App has been installed in /Applications folder uncomment below
rm -Rf "/Applications/${TO_INSTALLAPP}"
