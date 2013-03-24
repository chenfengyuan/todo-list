module("todo-list-api", package.seeall)

local JSON = require("cjson")
local utils = require("awutils")
local html = require("htmlentities")
local entities = html.htmlentities
local rds_parser = require "rds.parser"
local quote_pgsql_str = ndk.set_var.set_quote_pgsql_str

function get_arg_html_entities_encoded(req,name,default)
   local arg = req:get_arg(name)
   if arg then
      return entities(arg)
   else
      return default
   end
end

function pg_conn(str)
   local pg_res = ngx.location.capture("/postgres_default",{vars = {internal_postgres_sql = str}})
   if pg_res.status ~= ngx.HTTP_OK or not pg_res.body then
      error("failed to query PostgreSQL")
   end
   local res, err = rds_parser.parse(pg_res.body)
   if res == nil then
      error("failed to parse: " .. err)
   end
   return res;
end

function pg_conn_format(fmt,...)
   return pg_conn(string.format(fmt,...));
end

function test(req,resp)
   delete_item(req,resp)
end

function get_all_items(start,limit)
   start = quote_pgsql_str("" .. (start or 0))
   limit = quote_pgsql_str("".. math.min(limit or 30,100))
   return pg_conn_format("select * from tl_items order by item_id limit %s offset %s",limit,start).resultset
end

function get_last_item()
   return pg_conn("select * from tl_items order by item_id desc limit 1").resultset
end

function get_item(id)
   return pg_conn_format("select * from tl_items where item_id = %s limit 1",quote_pgsql_str(id)).resultset
end
