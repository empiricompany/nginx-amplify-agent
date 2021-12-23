#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
import os

from builders.util import shell_call, color_print

__author__ = "Mike Belov"
__copyright__ = "Copyright (C) Nginx, Inc. All rights reserved."
__license__ = ""
__maintainer__ = "Mike Belov"
__email__ = "dedm@nginx.com"

parser = argparse.ArgumentParser(prog='tools/test.py')
group = parser.add_mutually_exclusive_group()
group.add_argument('--plus', action='store_true', help='run with nginx+')
group.add_argument('--plus-r15', action='store_true', help='run with nginx+ r15')
parser.add_argument('--base', dest='base', help='base image (rhel8, ubuntu2004, debian10, ubuntu1804)', default='ubuntu2004')
args = parser.parse_args()

if __name__ == '__main__':
    if args.plus:
        path, image = 'docker/test-plus', 'amplify-agent-test-plus'
    elif args.plus_r15:
        path, image = 'docker/test-plus-r15', 'amplify-agent-test-plus-r15'
        args.base = 'ubuntu1804'
    else:
        path, image = 'docker/test', 'amplify-agent-test'

    shell_call('find . -name "*.pyc" -type f -delete', terminal=True)
    shell_call('rm -f %s/requirements.txt' % path)
    shell_call('cat packages/nginx-amplify-agent/requirements-%s.txt >> %s/requirements.txt' % (args.base, path))
    shell_call('docker build -t %s:%s -f %s/Dockerfile.%s .' % (image, args.base, path, args.base), terminal=True)
    shell_call('rm -f %s/requirements.txt' % path)

    rows, columns = os.popen('stty size', 'r').read().split()
    color_print("\n= RUN TESTS =" + "="*(int(columns)-13))
    color_print("py.test test/", color="yellow")
    color_print("="*int(columns)+"\n")
    shell_call('docker-compose -f %s-%s.yml run test bash' % (path, args.base), terminal=True)
