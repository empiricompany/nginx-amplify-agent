# -*- coding: utf-8 -*-
import time

from hamcrest import *

from test.unit.ext.phpfpm.base import PHPFPMTestCase, PHPFPMSupervisordTestCase
from amplify.agent.common.context import context
from amplify.ext.phpfpm.managers.master import PHPFPMManager
from amplify.ext.phpfpm.managers.pool import PHPFPMPoolManager


__author__ = "Grant Hulegaard"
__copyright__ = "Copyright (C) Nginx, Inc. All rights reserved."
__license__ = ""
__maintainer__ = "Grant Hulegaard"
__email__ = "grant.hulegaard@nginx.com"


class PHPFPMPoolManagerTestCase(PHPFPMTestCase):

    def setup_method(self, method):
        super(PHPFPMPoolManagerTestCase, self).setup_method(method)
        context._setup_object_tank()
        self.phpfpm_manager = PHPFPMManager()
        self.phpfpm_manager._discover_objects()

    def teardown_method(self, method):
        context._setup_object_tank()
        super(PHPFPMPoolManagerTestCase, self).teardown_method(method)

    def test_find_all(self):
        pool_manager = PHPFPMPoolManager()
        assert_that(pool_manager, not_none())

        found_pools = pool_manager._find_all()
        assert_that(found_pools, not_none())
        assert_that(found_pools, has_length(2))

        assert_that(found_pools, has_items(
            {
                'name': 'www',
                'file': '/etc/php/7.4/fpm/pool.d/www.conf',
                'listen': '/run/php/php7.0-fpm.sock',
                'status_path': '/status',
                'parent_id': 1,
                'parent_local_id': '185502c3d367a8036dfda481e8421e9ae04f6d1031375496ee7bddd7f0a5534a',
                'local_id': 'f53516fd0b4b4924d63e3391a6ebb0f62428f7036fbe0a9643acca681456a3cf'
            },
            {
                'name': 'www2',
                'file': '/etc/php/7.4/fpm/pool.d/www2.conf',
                'listen': '127.0.0.1:51',
                'status_path': '/status',
                'parent_id': 1,
                'parent_local_id': '185502c3d367a8036dfda481e8421e9ae04f6d1031375496ee7bddd7f0a5534a',
                'local_id': '0be82e33e7b26d756f01485837d1ce9a77ed4a560868fb0645426cb3d9ed8b7a'
            }
        ))

    def test_discover_objects(self):
        pool_manager = PHPFPMPoolManager()
        assert_that(pool_manager, not_none())

        # check to make sure there are no pools
        current_pools = context.objects.find_all(types=pool_manager.types)
        assert_that(current_pools, has_length(0))

        # find pools
        pool_manager._discover_objects()

        # check that a pool is found
        current_pools = context.objects.find_all(types=pool_manager.types)
        assert_that(current_pools, has_length(2))

    def test_remove(self):
        pool_manager = PHPFPMPoolManager()
        assert_that(pool_manager, not_none())

        # check to make sure there are no pools
        current_pools = context.objects.find_all(types=pool_manager.types)
        assert_that(current_pools, has_length(0))

        # find pools
        pool_manager._discover_objects()

        # check that a pool is found
        current_pools = context.objects.find_all(types=pool_manager.types)
        assert_that(current_pools, has_length(2))

        # stop php-fpm
        self.stop_fpm()

        time.sleep(0.1)  # release gil

        # re-run master manager to remove the master
        self.phpfpm_manager._discover_objects()

        # check to see pools are also removed
        current_pools = context.objects.find_all(types=pool_manager.types)
        assert_that(current_pools, has_length(0))


class SupervisorPHPFPMPoolManagerTestCase(PHPFPMPoolManagerTestCase, PHPFPMSupervisordTestCase):
    pass
