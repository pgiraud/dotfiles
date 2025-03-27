if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -Ux FZF_DEFAULT_COMMAND 'fdfind --type f --strip-cwd-prefix'
