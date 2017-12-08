import json
from os import path
import shlex


def test_json_file():
    json_path = path.join(path.dirname(__file__), path.pardir,
                          'autoload', 'makecfg.json')
    with open(json_path) as f:
        json_data = json.load(f)

    option_names = {'makeprg', 'errorformat'}

    for name, settings in json_data.items():
        assert ' ' not in name, '%r has spaces in it' % (name,)

        assert settings.keys() == option_names, "%s's settings are not %s" % (
            name, option_names)

        for option in option_names:
            assert isinstance(settings[option], str), '%s.%s is not str' % (
                name, option)

        makeprg = settings['makeprg']
        makeprg_parts = shlex.split(makeprg)
        if makeprg_parts[0] == '/usr/bin/env':
            # This style is redundant for makeprg - but we'll allow it
            makeprg_parts.pop(0)

        assert path.split(makeprg_parts[0])[0] == '', \
            '%s.makeprg has a directory path' % (name,)
