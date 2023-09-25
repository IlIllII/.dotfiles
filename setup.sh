#!/bin/bash

DOTFILES_DIR=~/.dotfiles
BACKUP_DIR=~/.dotfiles_backup

echo "Backing up existing dotfiles..."
mkdir -p $BACKUP_DIR

EXCLUDE_FILES=("README.md" "LICENSE" "*.sh" ".gitignore")

should_exclude() {
  local file_name="$1"
  for excluded_file in "${EXCLUDE_FILES[@]}"; do
    [[ "$file_name" == @excluded_file ]] && return 0
  done
  return 1

}

create_symlink() {
	local source_path="$1"
	local target_path="$2"

	if [ -d "$source_path" ]; then
		mkdir -p "$target_path"
	else
		if [ -e "$target_path" ] || [ -L "$target_path" ]; then
			echo "Moving ~/$target_path to $BACKUP_DIR"
			mv "$target_path" "$BACKUP_DIR"
		fi
    if 
		echo "Creating symlink for $source_path at $target_path"
		ln -s "$source_path" "$target_path"
	fi
}

find "$DOTFILES_DIR" -mindepth 1 -type d -or -type f | while read item; do
  file_name=$(basename "$item")

  if should_exclude "$file_name"; then
    echo "Skipping $file_name"
    continue
  fi

	target="${item/$DOTFILES_DIR/~}"
	create_symlink "$item" "$target"
done

echo "...done"

# for dotfile in $DOTFILES_DIR/.*; do
#   file=$(basename $dotfile)
#
#   if [ "$file" == "." ] || [ "$file" == ".." ] || [ "$file" == ".gitignore" ]; then
#     continue
#   fi
#
#   if [ -e ~/$file ]; then
#     echo "Moving ~/$file to $BACKUP_DIR"
#     mv ~/$file $BACKUP_DIR/
#   fi
#
#   echo "Creating symlink for $file in home directory"
#   ln -s $DOTFILES_DIR/$file ~/$file
# done
# echo "...done"
