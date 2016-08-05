status=
if [[ -d "$PWD/.git" ]]; then
  pushurl="$(git remote get-url origin)"
  if [[ ! "$(echo $pushurl | grep steyep)" ]]; then
    git remote set-url origin git@github.com:steyep/alfred-vpn.git
    git remote set-url --push origin $pushurl
  fi
  git fetch --all > /dev/null
  branch_status="$(git status)"
  if [[ "$branch_status" == *"up-to-date"* ]];
    then
    status=$(cat << EOB
    <item valid="no">
        <title>Workflow is up-to-date</title>
        <subtitle></subtitle>
        <icon>./_icons/good.png</icon>
    </item>
EOB
) 
  elif [[ "$branch_status" == *"ahead"* ]];
    then
    status=$(cat << EOB
    <item valid="no">
        <title>Workflow is ahead</title>
        <subtitle></subtitle>
        <icon>./_icons/good.png</icon>
    </item>
EOB
) 
  else
    status=$(cat << EOB
    <item valid="yes" arg='update.sh'>
        <title>Update available</title>
        <subtitle>Update this workflow</subtitle>
        <icon>./_icons/update.png</icon>
    </item>
EOB
)
  fi
fi

cat << EOB
  <?xml version="1.0"?>
  <items>
    $status
  </items>
EOB