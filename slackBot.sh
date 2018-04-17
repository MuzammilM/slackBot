#Author : MuzammilM
#Enables a command line utility to send messages to a slack channel
ARG_C=0
COLOR='\033[0;31m'
reset=`tput sgr0`

if [ ! -f "/home/"$USER"/config/shellscript/.slackcfg" ]; then
        mkdir -p "/home/"$USER"/config/shellscript"
        echo "foobarurl" > "/home/"$USER"/config/shellscript/.slackcfg"
fi

display_help() {
    echo "Usage: $0 [option...] | [channelname] [message] " >&2
    echo
    echo "   -c, --configure         Requests slack web hook url"
    echo "   -h, --help              Prints this help message"
    exit 1
}

while :
do
    case "$1" in
      -c | --configure)
          ARG_C=1
          shift
          ;;
      -h | --help)
          display_help  # Call your function
          exit 0
          ;;
      --) # End of all options
          shift
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          ## or call function display_help
          exit 1
          ;;
      *)  # No more options
          break
          ;;
    esac
done

if [ "$ARG_C" -eq "1" ]; then
        read -p "Please enter slack web hook url: " configure
        echo $configure
        sed -i 's,foobarurl,'$configure',g' "/home/"$USER"/config/shellscript/.slackcfg"
        exit
else
        slackUrl=`cat ~/config/shellscript/.slackcfg`
        if [ "$slackUrl" == "foobarurl" ]; then
                echo -e "${COLOR}SlackBot not configured"
                echo -e "${COLOR}Please visit :${reset}"
                echo -e "https://my.slack.com/apps/A0F7XDUAZ-incoming-webhooks"
                exit
        else
                if [ $# -lt 1 ]
                then
                        echo -e "${COLOR}No arguments passed."
                        echo -e "${COLOR}Add message to be sent to slack channel"
                        echo -e "${COLOR}Execution : slackBot channelname message ${reset}"
                exit
                fi
                z="\"${@:2}\""
                echo $z
                curl -X POST --data-urlencode 'payload={"channel": "#'$1'", "text": '"$z"'}'  $slackUrl
                exit
        fi
fi
