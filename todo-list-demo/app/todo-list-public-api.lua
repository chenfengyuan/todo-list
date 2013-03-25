module("todo-list-public-api", package.seeall)

local JSON = require("cjson")
local Redis = require("resty.redis")
local utils = require("awutils")
local pg = require("pg_frontend")
-- local redis = require("redis_frontend")
local html = require("htmlentities")
local entities = html.htmlentities
local rds_parser = require "rds.parser"

local db = pg

function get_arg_html_entities_encoded(req,name,default)
   local arg = req:get_arg(name)
   if arg then
      return entities(arg)
   else
      return default
   end
end

function count_items(req,resp)
   resp:write(db.count_items())
end

function get_last_item_html(req,resp)
   resp:ltp("item.html",{todo_lists = db.get_last_item()})
end

function get_all_items_html(req,resp)
   resp:ltp("item.html",{todo_lists = db.get_all_items()})
end

function get_item_html(req,resp)
   if req.method=='POST' then req:read_body() end
   local id = req:get_arg("id")
   if (not id) then
      resp:ltp("item.html",{todo_lists = db.get_last_item()})
   else
      resp:ltp("item.html",{todo_lists = db.get_item(id)})
   end
end
   
function create_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   local title = req:get_arg("title","no title")
   local state = req:get_arg("state","0")
   local content = req:get_arg("content","no content")
   resp.headers['Content-Type'] = 'application/json'
   resp:write(JSON.encode(db.create_item(title,state,content)));
end

function get_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   resp.headers['Content-Type'] = 'application/json'
   local id = req:get_arg("id")
   if (not id) then
      resp:write(JSON.encode({err="id required"}))
      logger:w("uri: %s ;err: %s",req.uri,"id required")
      return nil
   end
   local data = db.get_item(id)
   if (not data) then
      resp:write(JSON.encode({err="can't find id: " .. id}))
      logger:w("uri: %s ;err: %s",req.uri,"can't find id: " ..id)
   else
      resp:write(JSON.encode(data))
   end
end

function update_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   local id = req:get_arg("id")
   if (not id) then
      resp:write(JSON.encode({err="id required"}))
      logger:w("uri: %s ;err: %s",req.uri,"id required")
      return
   end
   local old = db.get_item(id)[1]
   local state = get_arg_html_entities_encoded(req,"state",old.item_todo_state)
   local title = get_arg_html_entities_encoded(req,"title",old.item_title)
   local content = get_arg_html_entities_encoded(req,"content",old.item_content)
   
   resp.headers['Content-Type'] = 'application/json'
   resp:write(JSON.encode(db.update_item(id,state,title,content)))
end

function delete_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   local id = req:get_arg("id")
   if (not id) then
      resp:write(JSON.encode({err="id required"}))
      logger:w("uri: %s ;err: %s",req.uri,"id required")
      return
   end
   resp.headers['Content-Type'] = 'application/json'
   resp:write(JSON.encode(db.delete_item(id)))
end
