module("todo-list-public-api", package.seeall)

local JSON = require("cjson")
local Redis = require("resty.redis")
local utils = require("awutils")
local tl = require("todo-list-api")
local html = require("htmlentities")
local entities = html.htmlentities
local rds_parser = require "rds.parser"
local pg_conn = tl.pg_conn
local pg_conn_format = tl.pg_conn_format
local quote_pgsql_str = ndk.set_var.set_quote_pgsql_str
local get_arg_html_entities_encoded = tl.get_arg_html_entities_encoded

function count_items(req,resp)
   resp:writeln(pg_conn("select count(1) from tl_items").resultset[1].count)
end

function get_last_item_html(req,resp)
   resp:ltp("item.html",{todo_lists = tl.get_last_item()})
end

function get_all_items_html(req,resp)
   resp:ltp("item.html",{todo_lists = tl.get_all_items()})
end

function get_item_html(req,resp)
   if req.method=='POST' then req:read_body() end
   local id = req:get_arg("id")
   if (not id) then
      resp:ltp("item.html",{todo_lists = tl.get_last_item()})
   else
      resp:ltp("item.html",{todo_lists = tl.get_item(id)})
   end
end
   
function create_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   local state = quote_pgsql_str(req:get_arg("state","0"))
   local title = quote_pgsql_str(req:get_arg("title","no title"))
   local content = quote_pgsql_str(req:get_arg("content","no content"))
   resp.headers['Content-Type'] = 'application/json'
   resp:writeln(JSON.encode(pg_conn_format("insert into tl_items (item_todo_state,item_title,item_content) values(%s,%s,%s)",state,title,content)));
end

function get_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   resp.headers['Content-Type'] = 'application/json'
   local id = req:get_arg("id")
   if (not id) then
      resp:writeln(JSON.encode({err="id required"}))
      logger:w("uri: %s ;err: %s",req.uri,"id required")
      return
   end
   local r = pg_conn_format("select * from tl_items where item_id = %s limit 1",quote_pgsql_str(id))
   if (#r.resultset == 0) then
      resp:writeln(JSON.encode({err="can't find id: " .. id}))
      logger:w("uri: %s ;err: %s",req.uri,"can't find id: " ..id)
   else
      resp:writeln(JSON.encode(r.resultset))
   end
end
function update_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   local id = req:get_arg("id")
   if (not id) then
      resp:writeln(JSON.encode({err="id required"}))
      logger:w("uri: %s ;err: %s",req.uri,"id required")
      return
   end
   local old = pg_conn_format("select * from tl_items where item_id = %s limit 1",quote_pgsql_str(id)).resultset[1]
   local state = get_arg_html_entities_encoded(req,"state",old.item_todo_state)
   local title = get_arg_html_entities_encoded(req,"title",old.item_title)
   local content = get_arg_html_entities_encoded(req,"content",old.item_content)
   local q_id,q_state,q_title,q_content = quote_pgsql_str(id),quote_pgsql_str(state),quote_pgsql_str(title),quote_pgsql_str(content)
   resp.headers['Content-Type'] = 'application/json'
   resp:writeln(JSON.encode(pg_conn_format("update tl_items set item_todo_state = %s,item_title = %s,item_content = %s where item_id = %s",q_state,q_title,q_content,q_id)))
end

function delete_item_json(req,resp)
   if req.method=='POST' then req:read_body() end
   local id = req:get_arg("id")
   if (not id) then
      resp:writeln(JSON.encode({err="id required"}))
      logger:w("uri: %s ;err: %s",req.uri,"id required")
      return
   end
   resp.headers['Content-Type'] = 'application/json'
   resp:writeln(JSON.encode(pg_conn_format("delete from tl_items where item_id = %s",quote_pgsql_str(id))))
end
