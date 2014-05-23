# Valid and working

# Xcode 5.0.1, XCode Server
#
# Settings

API_TOKEN="662684bcf8e94c89a0d8e32dff255182" # "This can be found here: https://rink.hockeyapp.net/manage/auth_tokens"

AP_ID="f7df2091faeb653d4d1f384a1d2813d3"

DISTRIBUTION_LISTS="Jdlink"

PROVISIONING_PROFILE="/Library/Server/Xcode/Data/ProvisioningProfiles/JDLinkAlpha_In_House_Distribution.mobileprovision"

#EXAMPLE:"/Library/Server/Xcode/Data/ProvisioningProfiles/DocLink_InHouse_2013.mobileprovision"

NOTIFY="1"

# 0 - Do not notify, 1 - Notify users by e-mail

STATUS="2"

# 1 - Don't allow users to download, 2 - Available for download

MANDATORY="0"

# 0 - No, 1 - Yes

SIGNING_IDENTITY="iPhone Distribution: Deere & Company"

#EXAMPLE:"iPhone Distribution: Unwired Revolution, LLC."



# Getting latest commit message

echo "Getting latest commit message"

latest=$(ls -1td /Library/Server/Xcode/Data/BotRuns/Bot* | head -n 1)

echo ${latest}

substringOn=0

blankLineCount=0

commitsString=$(cat ${latest}/output/scm_commit*.log |

awk '{

if (match($0, "CommitDate") == 1) {

substringOn=1

blankLineCount=0

}

if (substringOn==1) {

if ($0 != "") {

if (blankLineCount==1)  {

sub(/^[ \t]+/, "",$0)

print $0

}

} else

blankLineCount++

}

}')

echo ${commitsString}



# DO NOT EDIT BELOW HERE!

########################################

DSYM="/tmp/Archive.xcarchive/dSYMs/${PRODUCT_NAME}.app.dSYM"



IPA="/tmp/${PRODUCT_NAME}.ipa"



APP="/tmp/Archive.xcarchive/Products/Applications/${PRODUCT_NAME}.app"



# Clear out any old copies of the Archive

echo "Removing old Archive files from /tmp...";

/bin/rm -rf /tmp/Archive.xcarchive*



#Copy over the latest build the bot just created

echo "Copying latest Archive to /tmp/...";

LATESTBUILD=$(ls -1rt /Library/Server/Xcode/Data/BotRuns | tail -1)

/bin/cp -Rp "/Library/Server/Xcode/Data/BotRuns/${LATESTBUILD}/output/Archive.xcarchive" "/tmp/"



echo "Creating .ipa for ${PRODUCT_NAME}"

/bin/rm "${IPA}"

/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${APP}" -o "${IPA}" --sign "${SIGNING_IDENTITY}" --embed "${PROVISIONING_PROFILE}"



echo "Done with IPA creation."



echo "Zipping .dSYM for ${PRODUCT_NAME}"

/bin/rm "${DSYM}.zip"

/usr/bin/zip -r "${DSYM}.zip" "${DSYM}"



echo "Created .dSYM for ${PRODUCT_NAME}"



echo "*** Uploading ${PRODUCT_NAME} to HockeyApp ***"

/usr/bin/curl "https://rink.hockeyapp.net/api/2/apps/${AP_ID}/app_versions/upload" \

-F notify="${NOTIFY}" \

-F status="${STATUS}" \

-F mandatory="${MANDATORY}" \

-F ipa=@"${IPA}" \

-F dsym=@"${DSYM}.zip" \

-F notes="${commitsString}" \

-F tags="${DISTRIBUTION_LISTS}" \

-H "X-HockeyAppToken: ${API_TOKEN}"



echo "HockeyApp upload finished!"