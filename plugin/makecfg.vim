command! -nargs=1 -complete=customlist,makecfg#vimCommandCompletion MCF call makecfg#vimCommand(<q-args>)
