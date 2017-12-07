let s:jsonPath = fnameescape(expand('<sfile>:p:r')) . '.json'

let s:loadedCfgsTimestamp = 0

function! makecfg#load() abort
    let l:timestamp = getftime(s:jsonPath)
    if l:timestamp != s:loadedCfgsTimestamp
        let s:cfgs = json_decode(readfile(s:jsonPath))
    endif
    let s:loadedCfgsTimestamp = l:timestamp
    return s:cfgs
endfunction

function! makecfg#setOptions(cfgName) abort
    try
        let l:options = makecfg#load()[a:cfgName]
    catch /E716/
        throw 'MakeCFG has no configuration named ' . a:cfgName
    endtry

    let &makeprg = l:options.makeprg
    let &errorformat = l:options.errorformat
endfunction

function! makecfg#withOptions(cfgName, command) abort
    try
        let l:options = makecfg#load()[a:cfgName]
    catch /E716/
        throw 'MakeCFG has no configuration named ' . a:cfgName
    endtry

    let l:oldMakeprg = &makeprg
    let l:oldErrorformat = &errorformat
    try
        let &makeprg = l:options.makeprg
        let &errorformat = l:options.errorformat
        execute a:command
    finally
        let &makeprg = l:oldMakeprg
        let &errorformat = l:oldErrorformat
    endtry
endfunction

function! s:parseCommand(command) abort
    let l:match = matchlist(a:command, '\v^(\S*)(\s*)(.*)$')
    return l:match[1:3]
endfunction

function! makecfg#vimCommand(command) abort
    let [l:config, l:_, l:command] = s:parseCommand(a:command)
    if empty(l:command)
        call makecfg#setOptions(l:config)
    else
        call makecfg#withOptions(l:config, l:command)
    endif
endfunction

function! makecfg#vimCommandCompletion(argLead, cmdLine, cursorPos) abort
    let [l:config, l:spaces, l:command] = s:parseCommand(s:parseCommand(a:cmdLine[:a:cursorPos])[2])
    messages clear
    echomsg string([l:config, l:spaces, l:command])
    if empty(l:config)
        return keys(makecfg#load())
    elseif empty(l:spaces)
        return filter(keys(makecfg#load()), 'v:val[:len(l:config) - 1] == l:config')
    else
        return getcompletion(l:command, 'cmdline')
    endif
endfunction

