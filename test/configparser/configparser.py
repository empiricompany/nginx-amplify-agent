# -*- coding: utf-8 -*-
import os

from hamcrest import *

from amplify.agent.objects.nginx.config.config import NginxConfig
from test.base import BaseTestCase

__author__ = "Mike Belov"
__copyright__ = "Copyright (C) Nginx, Inc. All rights reserved."
__license__ = ""
__maintainer__ = "Mike Belov"
__email__ = "dedm@nginx.com"


class ConfigParserTestCase(BaseTestCase):

    def _run_check(self, filename):
        config = NginxConfig(filename)

        assert_that(config.tree, empty())
        config.full_parse()
        assert_that(config.tree, not_(empty()))

        for error_string in config.parser_errors:
            assert_that(error_string, is_not(contains_string('Parse')))

    def test_fail(self):
        """
        A special test that checks that _run_check actually works
        """
        assert_that(
            calling(self._run_check).with_args(os.getcwd() + '/test/configparser/configs/fail/nginx.conf'),
            raises(AssertionError)
        )

    def test_parse_1000(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1000/nginx.conf')

    def test_parse_1001(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1001/nginx.conf')

    def test_parse_1002(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1002/nginx.conf')

    def test_parse_1003(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1003/nginx.conf')

    def test_parse_1020(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1020/nginx.conf')

    def test_parse_1051(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1051/nginx.conf')

    def test_parse_1059(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1059/nginx.conf')

    def test_parse_1081(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1081/nginx.conf')

    def test_parse_1132(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1132/nginx.conf')

    def test_parse_1141(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1141/nginx.conf')

    def test_parse_1146(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1146/nginx.conf')

    def test_parse_1152(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1152/nginx.conf')

    def test_parse_1158(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1158/nginx.conf')

    def test_parse_1159(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1159/nginx.conf')

    def test_parse_1172(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1172/nginx.conf')

    def test_parse_1226(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1226/nginx.conf')

    def test_parse_1248_first(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1248/nginx_proxy/nginx.conf')

    def test_parse_1248_second(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1248/nginx_webserve/nginx.conf')

    def test_parse_1262(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1262/nginx.conf')

    def test_parse_1263(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1263/nginx.conf')

    def test_parse_1282(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1282/nginx.conf')

    def test_parse_1290(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1290/nginx.conf')

    def test_parse_1298(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1298/nginx.conf')

    def test_parse_1305(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1305/nginx.conf')

    def test_parse_1306(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1306/nginx.conf')

    def test_parse_1344(self):
        self._run_check(os.getcwd() + '/test/configparser/configs/1344/nginx.conf')
