items=

disconnected=$(/opt/cisco/anyconnect/bin/vpn status | grep Disconnected)

if [[ $disconnected ]]; then
  arg=Connect
  icon=./_resources/off.png
  status=Disconnected
  test -f ./_resources/vpnstat.pid && rm ./_resources/vpnstat.pid
else
  arg=Disconnect
  icon=./_resources/on.png
  status=Connected
fi

items=$(cat << EOB
    <item valid="yes" arg='vpn.sh $arg'>
      <title>$arg VPN</title>
      <subtitle></subtitle>
      <icon>$icon</icon>
    </item>
EOB
)

cat << EOB
  <?xml version="1.0"?>
  <items>
    $items
    <item valid="no" autocomplete="► settings">
      <title>VPN Settings</title>
      <subtitle></subtitle>
      <icon>./_icons/config.png</icon>
    </item>
  </items>
EOB