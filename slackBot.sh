#Author : MuzammilM
#Enables a command line utility to send messages to a slack channel

COLOR='\033[0;31m'
reset=`tput sgr0`

if [ $# -lt 1 ]
then
        echo -e "${COLOR}No arguments passed."
        echo -e "${COLOR}Add message to be sent to slack channel"
        echo -e "${COLOR}Execution : slackBot channelname message ${reset}"
        exit
fi
z="\"${@:2}\""
echo $z

curl -X POST --data-urlencode 'payload={"channel": "#'$1'", "text": '"$z"'}'  https://hooks.slack.com/{{Paste your slack hook link here}}
