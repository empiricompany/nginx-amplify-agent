#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys

from builders import deb, rpm
from builders.util import shell_call

__author__ = "Mike Belov"
__copyright__ = "Copyright (C) Nginx, Inc. All rights reserved."
__license__ = ""
__maintainer__ = "Mike Belov"
__email__ = "dedm@nginx.com"


if __name__ == '__main__':
    if os.path.isfile('/etc/debian_version'):
        deb.build()
    elif os.path.isfile('/etc/redhat-release'):
        rpm.build()
    else:
        os_release = shell_call('cat /etc/os-release', important=False)

        if 'amazon linux' in os_release.lower():
            rpm.build()
        else:
            print("sorry, it will be done later\n")
