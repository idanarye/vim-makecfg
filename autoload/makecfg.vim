let s:jsonPath = fnameescape(expand('<sfile>:p:r')) . '.json'

let s:loadedCfgsTimestamp = 0

function! makecfg#load() abort
    let l:timestamp = getftime(s:jsonPath)
    if l:timestamp != s:loadedCfgsTimestamp
        let s:cfgs = json_decode(join(readfile(s:jsonPath)))
    endif
    let s:loadedCfgsTimestamp = l:timestamp
    return s:cfgs
endfunction

function! makecfg#getOptions(cfgName) abort
    try
        return makecfg#load()[a:cfgName]
    catch /E716/
        throw 'MakeCFG has no configuration named ' . a:cfgName
    endtry
endfunction

function! s:set(makeprg, errorformat, scope) abort
endfunction

function! makecfg#useOptions(cfgName, scope) abort
    let l:options = makecfg#getOptions(a:cfgName)
    if a:scope == ''
        let &makeprg = l:options.makeprg
        let &errorformat = l:options.errorformat
    elseif a:scope == 'l'
        let &l:makeprg = l:options.makeprg
        let &l:errorformat = l:options.errorformat
    elseif a:scope == 'g'
        let &g:makeprg = l:options.makeprg
        let &g:errorformat = l:options.errorformat
    endif
endfunction

function! makecfg#withOptions(cfgName, command) abort
    try
        let l:options = makecfg#load()[a:cfgName]
    catch /E716/
        throw 'MakeCFG has no configuration named ' . a:cfgName
    endtry

    let l:lMakeprg = &l:makeprg
    let l:lErrorformat = &l:errorformat
    let l:gMakeprg = &g:makeprg
    let l:gErrorformat = &g:errorformat
    try
        let &makeprg = l:options.makeprg
        let &errorformat = l:options.errorformat
        execute a:command
    finally
        let &l:makeprg = l:lMakeprg
        let &l:errorformat = l:lErrorformat
        let &g:makeprg = l:gMakeprg
        let &g:errorformat = l:gErrorformat
    endtry
endfunction

function! s:parseCommand(command) abort
    let l:match = matchlist(a:command, '\v^(\S*)(\s*)(.*)$')
    return l:match[1:3]
endfunction

function! makecfg#vimCommand(command, local) abort
    let [l:config, l:_, l:command] = s:parseCommand(a:command)
    if empty(l:command)
        call makecfg#useOptions(l:config, a:local ? 'l' : 'g')
    else
        if a:local
            throw '`:MCF!` cannot be used when executing command - use `:MFC`'
        endif
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

