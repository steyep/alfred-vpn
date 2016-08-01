# Function for communicating with Pashua
#
# Argument 1: Configuration string
# Argument 2: Path to a folder containing Pashua.app (optional)
pashua_run() {

    # Write config file
    local pashua_configfile=`/usr/bin/mktemp /tmp/pashua_XXXXXXXXX`
    pashuapath="./_resources/Pashua.app/Contents/MacOS/Pashua"
    echo "$1" > "$pashua_configfile"

    # Get result
    local result=$("$pashuapath" "$pashua_configfile")

    # Remove config file
    rm "$pashua_configfile"

    oldIFS="$IFS"
    IFS=$'\n'

    # Parse result
    for line in $result
    do
        local name=$(echo $line | sed 's/^\([^=]*\)=.*$/\1/')
        local value=$(echo $line | sed 's/^[^=]*=\(.*\)$/\1/')
        eval $name='$value'
    done

    IFS="$oldIFS"
}
