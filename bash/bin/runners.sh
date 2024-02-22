find_main_file() {
    local extension="$1"
    local files_to_check=("main" "init" "index")

    for filename in "${files_to_check[@]}"; do
        if [ -f "${filename}.${extension}" ]; then
            echo "${filename}.${extension}"
            return 
        fi
    done

    echo "" # Empty string if no file found
}

# TODO: make this run ts files too. Combine both as well (i.e. if find a js file, run it with node, else if .py then run with python). Make hotkey just "r"

j() {
    if [ $# -gt 0 ]; then
        node "$@"
        return
    fi

    local file=$(find_main_file "js")

    if [ -n "$file" ]; then
        node "$file"
    else
        echo "No main/init/index file found."
    fi
}

p() {
    if [ $# -gt 0 ]; then
        python3 "$@"
        return
    fi

    local file=$(find_main_file "py")

    if [ -n "$file" ]; then
        python3 "$file"
    else
        echo "No main/init/index file found."
    fi
}
