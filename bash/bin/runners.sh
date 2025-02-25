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

# A ts-node helper for quickly running .ts files
t() {
  local ts_files=($(ls *.ts 2>/dev/null))

  # If no .ts files found
  if [ "${#ts_files[@]}" -eq 0 ]; then
    echo -e "${RED}No .ts files found.${ESC}"
    return
  fi

  # If one .ts file found
  if [ "${#ts_files[@]}" -eq 1 ]; then
    ts-node "${ts_files[0]}"
    return
  fi

  # If multiple .ts files found
  if [ -z "$1" ]; then
    echo -e "\n${GREEN}${#ts_files[@]} files found:${ESC}"

    for i in "${!ts_files[@]}"; do
      echo -e "$((i+1)). ${PINK}${ts_files[$i]}${ESC}"
    done

    printf "\n${ORANGE}Run which file? ${ESC}"
    read -r choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#ts_files[@]}" ]; then
      ts-node "${ts_files[$((choice-1))]}"
    else
      echo -e "${RED}Invalid selection.${ESC}"
    fi
  else
    ts-node "$1"
  fi
}

# Create digest file
ai() {
    local relative_path=""
    local original_dir="$PWD"

    # Calculate relative path to HOME
    while [[ "$PWD" != "$HOME" ]]; do
        relative_path="../$relative_path"
        cd ..
    done
    cd "$original_dir"

    # Create .ignore file
    mkdir -p "$HOME/aidigest"
    echo "dist
.yarn*
.github*
.mypy*
*.backup*" > "$HOME/aidigest/.ignore"

    # Run
    npx ai-digest --ignore-file "${relative_path}aidigest/.ignore" --show-output-files --output "$HOME/aidigest/$(basename "$PWD").md"
}
