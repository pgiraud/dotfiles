" F2 insert breakpoint
imap <F3> breakpoint()

" Don't need /usr/include for Python
setlocal path-=/usr/include

" Add stdlib to path
setlocal path+=/usr/lib/python3.9
" Add system dist-packages to path, detecting virtualenv
if !empty($VIRTUAL_ENV)
    if !empty(glob($VIRTUAL_ENV . "/lib/python3.9/site-packages"))
        setlocal path+=$VIRTUAL_ENV/lib/python3.9/site-packages
    endif
    if !empty(glob($VIRTUAL_ENV . "/lib/python2.7/site-packages"))
        setlocal path+=$VIRTUAL_ENV/lib/python2.7/site-packages
    endif
else
    setlocal path+=/usr/lib/python3/dist-packages
endif

let b:ale_linters = ['flake8', 'isort', 'mypy', 'ruff']
let b:ale_fixers = ['autoflake', 'black', 'isort', 'ruff']
let b:ale_python_mypy_options = '--strict --ignore-missing-imports'
let b:ale_python_autoflake_options = '--remove-unused-variables'
