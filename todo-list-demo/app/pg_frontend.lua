module("pg_frontend", package.seeall)

local JSON = require("cjson")
local utils = require("awutils")
local html = require("htmlentities")
local entities = html.htmlentities
local rds_parser = require "rds.parser"
local quote_pgsql_str = ndk.set_var.set_quote_pgsql_str

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

function count_items()
   return resp:writeln(pg_conn("select count(1) from tl_items").resultset[1].count)
end

function create_item(title,state,content)
   state = quote_pgsql_str(state)
   title = quote_pgsql_str(title)
   content = quote_pgsql_str(content)
   return pg_conn_format("insert into tl_items (item_todo_state,item_title,item_content) values(%s,%s,%s)",state,title,content)
end

function get_item(id)
   local r = pg_conn_format("select * from tl_items where item_id = %s limit 1",quote_pgsql_str(id))
   if (#r.resultset == 0 ) then
      return nil
   else
      return r.resultset
   end
end

function update_item(id,state,title,content)
   local q_id,q_state,q_title,q_content = quote_pgsql_str(id),quote_pgsql_str(state),quote_pgsql_str(title),quote_pgsql_str(content)
   return pg_conn_format("update tl_items set item_todo_state = %s,item_title = %s,item_content = %s where item_id = %s",q_state,q_title,q_content,q_id)
end

function delete_item(id)
   return pg_conn_format("delete from tl_items where item_id = %s",quote_pgsql_str(id))
end
