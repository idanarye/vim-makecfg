# Contributing

Just add an entry to `autoload/makecfg.json` for the missing tool, with the key
being the name(the first argument of `:MCF`) and the value being an object with
`"makeprg"` and `"errorformat"` fields.

Travis CI will run a basic test to make sure the JSON format is correct(it
can't verify the actual settings though)

Pull requests for new entries will be added wihtout farther ceremony(unless
they fail Travis, of course), but if you change an existing entry you should
explain why it was changed.
