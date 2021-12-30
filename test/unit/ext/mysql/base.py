# -*- coding: utf-8 -*-
import time

from test.base import BaseTestCase
from amplify.agent.common.util import subp


__author__ = "Mike Belov"
__copyright__ = "Copyright (C) Nginx Inc. All rights reserved."
__license__ = ""
__maintainer__ = "Mike Belov"
__email__ = "dedm@nginx.com"


class MySQLTestCase(BaseTestCase):
    """
    Tester helper that starts and stops php-fpm on the test container before running tests.
    """
    def __init__(self, *args, **kwargs):
        super(MySQLTestCase, self).__init__(*args, **kwargs)
        self.running = False

    @classmethod
    def setup_class(cls):
        # init mysql
        subp.call('service mysql start', check=False)
        subp.call("mysql -e \"CREATE USER IF NOT EXISTS 'amplify-agent'@'localhost' IDENTIFIED BY 'amplify-agent';\"")
        subp.call('service mysql stop')

    def setup_method(self, method):
        super(MySQLTestCase, self).setup_method(method)
        if self.running:
            self.stop_mysqld()
        self.start_mysqld()

    def teardown_method(self, method):
        if self.running:
            self.stop_mysqld()
        super(MySQLTestCase, self).teardown_method(method)

    def start_mysqld(self):
        if not self.running:
            subp.call('service mysql start')
            self.running = True

    def stop_mysqld(self):
        if self.running:
            subp.call('service mysql stop')
            self.running = False

    def restart_mysqld(self):
        if self.running:
            subp.call('service mysql restart')


class MySQLSupervisordTestCase(MySQLTestCase):

    def __init__(self, *args, **kwargs):
        super(MySQLSupervisordTestCase, self).__init__(*args, **kwargs)
        self.running = False

    @classmethod
    def setup_class(cls):
        subp.call('supervisorctl -c /etc/supervisord.conf shutdown', check=False)
        subp.call('supervisord -c /etc/supervisord.conf')

        # init mysql
        subp.call('service mysql start', check=False)
        subp.call("mysql -e \"CREATE USER IF NOT EXISTS 'amplify-agent'@'localhost' IDENTIFIED BY 'amplify-agent';\"")
        subp.call('service mysql stop')

    @classmethod
    def teardown_class(cls):
        subp.call('supervisorctl -c /etc/supervisord.conf shutdown')

    def start_mysqld(self):
        if not self.running:
            subp.call('supervisorctl -c /etc/supervisord.conf start mysqld')
        self.running = True

    def stop_mysql(self):
        if self.running:
            subp.call('supervisorctl -c /etc/supervisord.conf stop mysqld')
        self.running = False

    def restart_mysqld(self):
        if self.running:
            subp.call('supervisorctl -c /etc/supervisord.conf restart mysqld')
