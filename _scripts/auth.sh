keychain="alfred-vpn"
config='./_resources/settings'

function export_settings() {
  showmenu=${showmenu:-0}
  host=${host:-}
  cat > $config << EOF
showmenu=$showmenu
host="$host"
EOF
}

test ! -f $config && export_settings
source $config
default_host="$host"

function get_hosts() {
  _IFS=$IFS
  IFS=$'\n'
  for host in $(/opt/cisco/anyconnect/bin/vpn hosts | grep '>');
  do
    test -z $default_host && default_host="${host#*> }"
    echo "host.option = ${host#*> }"
  done
  echo "host.default = $default_host"
  IFS=$_IFS
}

function log_in() {
  source "./_resources/pashua.sh"

  conf="
  # Set window title
  *.title = Alfred VPN
  
  # Get Host
  host.type = popup
  host.label = Host
  $(get_hosts)
  host.width = 310

  # Get Username
  username.type = textfield
  username.label = Username
  username.default = $username
  username.mandatory = 1
  username.width = 310

  # Get Password
  password.type = password
  password.label = Password
  password.mandatory = 1
  password.width = 310

  save.rely = -18
  save.type = checkbox
  save.label = Save credentials to Keychain
  save.default = 0

  cancel.type = cancelbutton
  "

  pashua_run "$conf"

  [[ "$cancel" == "1" ]] && exit 0

  auth="$username:"

  [[ "$save" == "1" ]] && auth+="$password"

  # save it
  security add-generic-password -a $USER -s $keychain -w "$(echo "$auth" | base64)" -U
  export_settings
}

function toggle_menu() {
  showmenu=$(( ($showmenu + 1) % 2 ))
  export_settings
  [[ "$showmenu" == "1" ]] && 
    echo "Enabled menu bar icon" ||
    echo "Disabled menu bar icon"
}

function authenticate() {
  # find it
  auth="$(security 2>&1 >/dev/null find-generic-password -s $keychain -g | sed -E 's/^password: "(.+)"$/\1/')"
  [[ "$auth" == "security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain." ]] && auth="" || auth="$(echo "$auth" | base64 -D)"
  username="${auth%%:*}"
  password="${auth#*:}"

  [[ "$username" == "" || "$password" == "" ]] && log_in "$username"
}

function forgetMe() {
  test -f $config && rm $config
  security &>/dev/null delete-generic-password -s $keychain && 
    echo "Credentials erased!" || 
    echo "No credentials found for $keychain"

}

eval "$1"