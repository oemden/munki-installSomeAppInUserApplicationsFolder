#!/bin/bash
#
# oem at oemden dot com - Install App in User's app folder
#
## pre-install script to delete older version if app exist

version="1.0"
#

DEFAULTS=/usr/bin/defaults

########################## EDIT END #############################
LOGIN="$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')"
LOGINHOMEDIR="$(/usr/bin/dscl . -read /Users/$LOGIN | grep 'NFSHomeDirectory:' | grep -v 'OriginalNFSHomeDirectory:' | awk '{print $2}')"
LOGINAPPDIR="${LOGINHOMEDIR}/Applications"
TO_INSTALLAPP="Some App.app"
TO_INSTALLTMP_APP="/tmp/${TO_INSTALLAPP}"
TO_INSTALLUSER_APP="${LOGINAPPDIR}/${TO_INSTALLAPP}"

if [[ -d "${TO_INSTALLUSER_APP}" ]] ; then
 echo "remove the old App"
 rm -Rf "${TO_INSTALLUSER_APP}"
fi
