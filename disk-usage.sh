#!/bin/bash
#disk_usage.sh
# Script to check disk usage and report result if over limit set in $percent
# v 1.0 info@ljeltd.co.uk 17052009
# v 1.1 Chris Smith 13012016 - Add slack function

#check=`df -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -`
check=`df -k |grep -v Vol|grep -v Use|cut -d "%" -f1 -|awk {'print $NF'} |sort -n|tail -1`

percent=80
result=`df -h` #can be used for full detail

# Send message to yourslackaccount-devops.slack.com

if [ "$check" -ge "$percent" ];then
curl -X POST --data-urlencode "payload={\"channel\": \"#admin\", \"username\": \"Disk_Usage.sh\", \"text\": \" Please check ${HOSTNAME} its disk is ${check}% full! \", \"icon_emoji\": \":robot_face:\"}" https://hooks.slack.com/services/your/encryted/slackurl
fi

#Also send email with details

if [ "$check" -ge "$percent" ];then
{
echo
echo -----------------------------------------------
echo    Daily check to prevent Disk from filling
echo -----------------------------------------------
echo
echo $HOSTNAME Partitions are over $percent%
echo
#df -h | awk '$5 ~ "[9].%" {print $5 "\t" $6}'
df -h |grep -v Vol
echo -----------------------------------------------
}|mail -s "Disk $check% full @$HOSTNAME" youremail@yourdomain.net
#else
#echo diskusage OK
fi

