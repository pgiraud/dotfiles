#!/usr/bin/env python3

import fnmatch
import os
import subprocess
from pathlib import Path

DOTFILES = Path(__file__).resolve().parent
HOME = Path.home()

EXCLUDE = [
    "*.sw*",
    ".git",
    "install.*",
    ".gitmodules",
]

def symlink(source, target):
    target.parent.mkdir(parents=True, exist_ok=True)

    # Preserve existing directories, but replace files and symlinks.
    if target.is_dir() and not target.is_symlink():
        print(f"Skipping existing directory: {target}")
        return

    target.unlink(missing_ok=True)
    target.symlink_to(source)

    print(f"Created link: {target} -> {source}")


def main():
    files = subprocess.check_output(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard"],
        cwd=DOTFILES,
        text=True,
    ).splitlines()

    # Link files and directories.
    for file in files:
        source = DOTFILES / file
        target = HOME / file

        if source.is_file():
            symlink(source, target)

if __name__ == "__main__":
    main()

# to get better colors in the terminal, launch the following command
# gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/palette "#000000000000:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2:#4CCC4CCC4CCC:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2"
