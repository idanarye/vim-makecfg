from omnipytent import FN, OPT


_get_options = FN['makecfg#getOptions']


def makecfg(name):
    options = _get_options(name)
    return OPT.changed(**options)
