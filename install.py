#! /usr/bin/env python

import os
import fnmatch

exclude = ['*.sw*', '.git', 'install.*', '.gitmodules']

for f in os.listdir('.'):
    if not any(fnmatch.fnmatch(f, p) for p in exclude):
        path = os.path.join(os.path.expanduser('~'), f)
        if os.path.isfile(path) or os.path.isdir(path):
            os.unlink(path)
        os.symlink(os.path.abspath(f), path)
        print 'create link for %s' % (path)

# Symlink nvim config file
path = os.path.expanduser('~/.config/nvim/init.vim')
path_dir = os.path.dirname(path)
if os.path.isfile(path) or os.path.isdir(path):
    os.unlink(path)
if not os.path.exists(path_dir):
    os.makedirs(path_dir)
os.symlink(os.path.abspath('nvim.init'), path)

# to get better colors in the terminal, launch the following command
# gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/palette "#000000000000:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2:#4CCC4CCC4CCC:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2"
