source "./_scripts/auth.sh"
items=
[[ -d "$PWD/.git" ]] && items+='
		<item valid="no" autocomplete="► settings ► update">
      <title>Check for updates</title>
      <subtitle></subtitle>
      <icon>_icons/config.png</icon>
    </item>
'

cat << EOB
	<?xml version="1.0"?>
  <items>
  	$items
    <item valid="yes" autocomplete="► settings" arg='auth.sh log_in'>
      <title>Change login settings</title>
      <subtitle></subtitle>
      <icon>_icons/config.png</icon>
    </item>
    <item valid="yes" autocomplete="► settings" arg='auth.sh forgetMe'>
      <title>Clear settings</title>
      <subtitle></subtitle>
      <icon>_icons/config.png</icon>
    </item>
    <item valid="yes" autocomplete="► settings" arg='auth.sh toggle_menu'>
      <title>Show menu bar icon: $( test $showmenu -eq 1 && echo "TRUE" || echo "FALSE")</title>
      <subtitle></subtitle>
      <icon>_icons/config.png</icon>
    </item>
   </items>
EOB
