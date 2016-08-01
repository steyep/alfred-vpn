source "./_resources/pashua.sh"
conf="
# Set window title
*.title = Alfred VPN

img.type = image
img.path = ./_icons/reprint.png
img.maxwidth = 50

info.type = text
info.x = 60
info.y = 50
info.text = Your workflow has been updated![return]In order for the changes to take effect, you may need to restart Alfred.

restart.type = defaultbutton
restart.label = Restart now

cancel.type = cancelbutton
cancel.label = Later
"

upstream="$(git branch -lvv | grep \* | sed 's/.*\[\(.*\):.*/\1/')"
[[ -z "$upstream" ]] && upstream="origin/master"

git reset --hard $upstream
echo "Workflow updated"

pashua_run "$conf"

if [[ "$restart" == "1" ]]; then
  alfred_pid=$(ps -o ppid= $PPID)
  app=$(ps -p $alfred_pid -o comm=)
  ( kill -9 $alfred_pid && open "${app/.app*/.app}" ) &
fi
exit 0