# Create weekly note
get_weekly_note_dir() {
  echo "$HOME/.notes/weeklies"
}

get_next_sunday_date() {
  local current_day=$(date +%u)
  local days_until_sunday=$((7 - current_day))
  if [ $current_day -eq 7 ]; then
      days_until_sunday=0
  fi
  date -v +${days_until_sunday}d "+%Y-%m-%d"
}

ensure_weekly_file_exists() {
  local dir=$(get_weekly_note_dir)
  local file_date=$(get_next_sunday_date)
  local full_path="${dir}/${file_date}.md"

  # Create dir if needed
  [[ ! -d $dir ]] && mkdir -p "$dir"

  # Create file if needed
  [[ ! -f $full_path ]] && echo "# ${file_date}" > $full_path
}

open_weekly_note() {
  ensure_weekly_file_exists
  local dir=$(get_weekly_note_dir)
  local file_date=$(get_next_sunday_date)
  local full_path="${dir}/${file_date}.md"

  nvim "$full_path"
}

alias nw='open_weekly_note'


# Saving links
sl() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: sl <url>"
    return 1
  fi

  echo "$1" >> ~/.notes/links.md
  echo "Added $1 to links.md"
}

# Quick open notes
notes() {
  nvim ~/.notes/
}
