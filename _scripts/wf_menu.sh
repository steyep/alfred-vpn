q="$1"

# Make sure the CLI exists
test ! -f /opt/cisco/anyconnect/bin/vpn && cat << EOF
<?xml version="1.0"?>
  <items>
  <item valid="no">
      <title>This workflow requires Cisco AnyConnect VPN</title>
      <subtitle></subtitle>
      <icon>_icons/warning.png</icon>
    </item>
  </items>
EOF

read -a arr <<< "$(echo "${q// }" | sed 's/►/ /g' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
len=$(( $(echo "${#arr[@]}") -1 ))

case "${arr[$len]}" in
  # Update
  u*) script="checkup.sh";;
  # Settings
  s*) script="settings.sh";;
  *) script="scriptfilter.sh";;
esac

sh ./_scripts/$script