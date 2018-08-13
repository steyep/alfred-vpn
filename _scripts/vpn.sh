q="$1"
status_indicator="./_resources/VPNStatus.app"
statusPID="./_resources/vpnstat.pid"
auth="./_scripts/auth.sh"
source $auth

# If the AnyConnect.app is running, we want to quit it
# before trying to connect via the CLI tool.
app=$(ps ax | grep -v grep | grep AnyConnect | awk '{ printf $1; }')
test "$app" && kill -9 $app

if [[ "$q" == "Connect" ]];
then
	authenticate
	result="$(/usr/bin/expect ./_scripts/connect.exp "$host" "$username" "$password" || forgetMe)"
	if [[ "$showmenu" == "1" ]];
		then
		open $status_indicator
		ps aux | grep -v grep | grep $status_indicator | awk '{ printf $2; }' > $statusPID
	fi
else
	/opt/cisco/anyconnect/bin/vpn disconnect 1>/dev/null
	# Capture status pid & kill on disconnect (if it's running).
	if [ -f $statusPID ];
		then
		kill -9 $(cat $statusPID) && rm $statusPID
	fi

	result="Disconnected Successfully"
fi

echo $result
