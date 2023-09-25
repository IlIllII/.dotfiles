#!/bin/bash

DOTFILES_DIR=~/.dotfiles
BACKUP_DIR=~/.dotfiles_backup
EXCLUDE_FILES=("README.md" "LICENSE" "*.sh" ".gitignore" ".git")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "Backing up existing dotfiles..."
mkdir -p $BACKUP_DIR

should_exclude() {
	local file_name="$1"
	for excluded_file in "${EXCLUDE_FILES[@]}"; do
		[[ "$file_name" == $excluded_file ]] && return 0
	done
	return 1
}

for dotfile in $DOTFILES_DIR/.*; do
	file=$(basename $dotfile)

	if [ "$file" == "." ] || [ "$file" == ".." ]; then
		continue
	fi

	if should_exclude "$file"; then
		echo "Skipping $file_name"
		continue
	fi

	if [ -e ~/$file ] || [ -L ~/$file ]; then
		echo "Moving ~/$file to $BACKUP_DIR/${file}_$TIMESTAMP"
		mv ~/$file $BACKUP_DIR/${file}_$TIMESTAMP
	fi

	echo "Creating symlink for $file in home directory"
	ln -s $DOTFILES_DIR/$file ~/$file
done

echo "...done"
