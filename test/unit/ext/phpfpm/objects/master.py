# -*- coding: utf-8 -*-
from hamcrest import *

from test.base import BaseTestCase
from test.fixtures.defaults import DEFAULT_UUID
from amplify.ext.phpfpm.objects.master import PHPFPMObject


__author__ = "Grant Hulegaard"
__copyright__ = "Copyright (C) Nginx, Inc. All rights reserved."
__license__ = ""
__maintainer__ = "Grant Hulegaard"
__email__ = "grant.hulegaard@nginx.com"


class PHPFPMObjectTestCase(BaseTestCase):
    """
    Test case for PHPFPMObject (master).
    """

    def test_init(self):
        phpfpm_obj = PHPFPMObject(
            local_id=123,
            pid=2,
            cmd='php-fpm: master process (/etc/php/7.4/fpm/php-fpm.conf)',
            conf_path='/etc/php/7.4/fpm/php-fpm.conf',
            workers=[3, 4]
        )
        assert_that(phpfpm_obj, not_none())

        assert_that(phpfpm_obj.local_id_args, equal_to(
            ('php-fpm: master process (/etc/php/7.4/fpm/php-fpm.conf)', '/etc/php/7.4/fpm/php-fpm.conf')
        ))
        assert_that(phpfpm_obj.local_id, equal_to(123))
        assert_that(phpfpm_obj.definition, equal_to(
            {'local_id': 123, 'type': 'phpfpm', 'root_uuid': DEFAULT_UUID}
        ))
        assert_that(phpfpm_obj.definition_hash, equal_to(
            '552ab980ed3317f2e4864e3164d2724e53e2064ae055ad6087645a92ae585224'
        ))
        assert_that(phpfpm_obj.collectors, has_length(2))

    def test_parse(self):
        """This test is only possible because there is a working config in the test container"""
        phpfpm_obj = PHPFPMObject(
            local_id=123,
            pid=2,
            cmd='php-fpm: master process (/etc/php/7.4/fpm/php-fpm.conf)',
            conf_path='/etc/php/7.4/fpm/php-fpm.conf',
            workers=[3, 4]
        )
        assert_that(phpfpm_obj, not_none())

        parsed_conf = phpfpm_obj.parse()
        assert_that(parsed_conf, not_none())
        assert_that(parsed_conf, has_entries(
            {
                'include': ['/etc/php/7.4/fpm/pool.d/*.conf'],
                'file': '/etc/php/7.4/fpm/php-fpm.conf',
                'pools': has_items(
                    {
                        'status_path': '/status',
                        'name': 'www',
                        'file': '/etc/php/7.4/fpm/pool.d/www.conf',
                        'listen': '/run/php/php7.0-fpm.sock'
                    },
                    {
                        'status_path': '/status',
                        'name': 'www2',
                        'file': '/etc/php/7.4/fpm/pool.d/www2.conf',
                        'listen': '127.0.0.1:51'
                    }
                )
            }
        ))

    def test_properties(self):
        """
        This test is meant to test some properties that have had intermittent
        user bug reports.
        """
        phpfpm_obj = PHPFPMObject(
            pid=2,
            cmd='php-fpm: master process (/etc/php/7.4/fpm/php-fpm.conf)',
            conf_path='/etc/php/7.4/fpm/php-fpm.conf',
            workers=[3, 4]
        )
        assert_that(phpfpm_obj, not_none())

        assert_that(phpfpm_obj.local_id_args, equal_to(
            (
                'php-fpm: master process (/etc/php/7.4/fpm/php-fpm.conf)',
                '/etc/php/7.4/fpm/php-fpm.conf'
            )
        ))
        assert_that(phpfpm_obj.local_id, equal_to(
            '1d9d085ed78429167a51345ad39bbd9b2e0156f32a8e093f92db062c8dde632c'
        ))
        assert_that(phpfpm_obj.definition, equal_to(
            {
                'local_id': '1d9d085ed78429167a51345ad39bbd9b2e0156f32a8e093f92db062c8dde632c',
                'type': 'phpfpm',
                'root_uuid': DEFAULT_UUID
            }
        ))
        assert_that(phpfpm_obj.definition_hash, equal_to(
            '0a7426a29131567e96362921150f2833f68f104f91b8ee2667d131403d7e8207'
        ))
