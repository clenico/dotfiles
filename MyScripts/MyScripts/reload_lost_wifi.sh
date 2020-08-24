wget -q --spider http://google.com

if [ $? -eq 0 ]; then
    echo "Online. All is fine."
else
    msg="Offline. Re-initiating wifi."
    echo $msg
    notify-send -t 1000 -u low "$msg"
    nmcli radio wifi off
    sleep 1
    nmcli radio wifi on
fi
