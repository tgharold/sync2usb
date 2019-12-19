#import os
import sys
from argparse import ArgumentParser
#from configparser import ConfigParser
#from collections import OrderedDict


class ArgParser(ArgumentParser):

    def __init__(self, *args, **kwargs):
        return

    def parse_args(self, args=None, namespace=None):
        if args or len(sys.argv) > 1:
            # if no args nor sys.argv, we don't bother loading the config as
            # there are missing args and super().parse_args below will raise an
            # exception
            self.load_cfg(args[0] if args else sys.argv[1])

        parsed = super(ArgParser, self).parse_args(args, namespace)

        if parsed.action is False:
            raise ValueError('Argument error: you must select an action using '
                             'one of the "sync", "update" or "diff" options\n')

        return parsed        

    def load_cfg(self, src_dir):
        return

    