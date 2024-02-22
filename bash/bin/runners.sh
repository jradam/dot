find_main_file() {
    local extension="$1"
    local files_to_check=("main" "init")

    for filename in "${files_to_check[@]}"; do
        if [ -f "${filename}.${extension}" ]; then
            echo "${filename}.${extension}"
            return 
        fi
    done

    echo "" # Empty string if no file found
}


j() {
    if [ $# -gt 0 ]; then
        node "$@"
        return
    fi

    local file=$(find_main_file "js")

    if [ -n "$file" ]; then
        node "$file"
    else
        echo "No main.js or init.js found."
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
        echo "No main.py or init.py found."
    fi
}
