# -*- coding: utf-8 -*-
import test.unit.agent.managers.status

from amplify.agent.managers.api import ApiManager


__author__ = "Grant Hulegaard"
__copyright__ = "Copyright (C) Nginx, Inc. All rights reserved."
__license__ = ""
__maintainer__ = "Grant Hulegaard"
__email__ = "grant.hulegaard@nginx.com"


class ApiManagerTestCase(test.unit.agent.managers.status.StatusManagerTestCase):
    plus_manager = ApiManager
    api = True
    collector_method = 'plus_api'
