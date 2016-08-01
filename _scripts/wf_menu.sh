q="$1"
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