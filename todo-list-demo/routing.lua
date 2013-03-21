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
map('^/db/create_item',             'db.create_item')
map('^/db/count_items',             'db.count_items')
map('^/db/get_item',                'db.get_item')
map('^/db/update_item',             'db.update_item')
map('^/db/delete_item',             'db.delete_item')
map('^/get_last_item_html',         'test.get_last_item_html')
map('^/get_item_html',              'test.get_item_html')
map('^/get_all_items_html',         'test.get_all_items_html')
---------------------------------------------------------------------
