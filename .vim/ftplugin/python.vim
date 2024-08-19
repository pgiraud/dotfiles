" F2 insert breakpoint
imap <F3> breakpoint()

let b:ale_linters = ['mypy', 'ruff']
let b:ale_fixers = ['ruff_format']
let b:ale_python_mypy_options = '--strict --ignore-missing-imports'
let b:ale_python_autoflake_options = '--remove-unused-variables'
