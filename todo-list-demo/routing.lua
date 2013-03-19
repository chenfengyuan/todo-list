#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : ldmiao
--

local router = require('mch.router')
router.setup()

---------------------------------------------------------------------
map('^/mchconsole',                 'mch.console.start')

map('^/hello%?nam(e=.*)',           'test.hello')
map('^/longtext',                   'test.longtext')
map('^/ltp',                        'test.ltp')
map('^/index',                      'test.index')
---------------------------------------------------------------------
