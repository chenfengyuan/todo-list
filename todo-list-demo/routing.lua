#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : ldmiao
--

local router = require('mch.router')
router.setup()

---------------------------------------------------------------------
map('^/index.html',                      'main.index')
map('^/api/create_item_json',            'todo-list-public-api.create_item_json')
map('^/api/count_items',                 'todo-list-public-api.count_items')
map('^/api/get_item_json',               'todo-list-public-api.get_item_json')
map('^/api/update_item_json',            'todo-list-public-api.update_item_json')
map('^/api/delete_item_json',            'todo-list-public-api.delete_item_json')
map('^/api/get_last_item_html',          'todo-list-public-api.get_last_item_html')
map('^/api/get_item_html',               'todo-list-public-api.get_item_html')
map('^/api/get_all_items_html',          'todo-list-public-api.get_all_items_html')
map('^/test',                            'todo-list-api.test')
---------------------------------------------------------------------
