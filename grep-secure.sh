#!/bin/bash
# grep-secure.sh info@ljeltd.co.uk 17052009
# Script to check secure logs for user access hacks
# v1.1 21-05-16 ubuntu/debian used auth.log rather then secure.
# v1.1a 21-05-16 also Add only send Slack message if issues found logic
# Scripts to check secure log for
#1.Logins using invalid user names
#2.Logins with 3 Password failures

invalidusers_issues=0
password_issues=0

if grep -q "Invalid user" /var/log/secure; then
invalidusers_issues=1
invalid_users=`grep "Invalid user" /var/log/secure`
invalid_users_message=`
echo
echo -----------------------------------------------
echo
echo    Login attempts using Invalid user name
echo
echo -----------------------------------------------
echo
echo $invalid_users`
fi


if grep -q "authentication failure" /var/log/secure; then
password_issues=1
too_many_wrong_passwds=`grep "authentication failure" /var/log/secure`
too_many_passwords_message=`
echo
echo -----------------------------------------------
echo
echo    Login attempts with three wrong passwords
echo
echo -----------------------------------------------
echo $too_many_wrong_passwds`
fi


# Send message to yourslack-account.slack.com


if [[ ("$invalidusers_issues" -ge 1) || ("$password_issues" -ge 1)]];then # If either value met

curl -X POST --data-urlencode "payload={\"channel\": \"#admin\", \"username\": \"Grep_Secure.sh\", \"text\": \" Please check ${HOSTNAME} its had $too_many_passwords_message or $invalid_users_message   \", \"icon_emoji\": \":robot_face:\"}" https://hooks.slack.com/services/your/encryted/slackdomainname
fi

