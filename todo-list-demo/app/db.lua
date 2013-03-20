module("db", package.seeall)
local JSON = require("cjson")
local utils = require("awutils")
function count_items(req,resp)
   local resp2 = ngx.location.capture("/db/_count_items")
   resp:writeln(JSON.decode(resp2.body)[1]["count"])
end

function create_item(req,resp)
   if req.method=='POST' then req:read_body() end
   local state = req:get_arg("state",0)
   local title = req:get_arg("title","no title")
   local content = req:get_arg("content","no content")
   local resp2 = ngx.location.capture("/db/_create_item",
   				      {args = {state = state,
   					       title = title,
   					       content = content},
				       method = ngx.HTTP_POST})
   if(resp2.status ~= 200) then
      ngx.exit(resp2.status)
   end
end
function get_item(req,resp)
   if req.method=='POST' then req:read_body() end
   resp.headers['Content-Type'] = 'application/json'
   local id = req:get_arg("id")
   if (not id) then
      resp:writeln(JSON.encode({err="id required"}))
      logger:w("uri: %s ;err: %s",req.uri,"id required")
      return
   end
   local resp2 = ngx.location.capture("/db/_get_item",
				      {args = {id = id},
				       method = ngx.HTTP_POST});
   local r =JSON.decode(resp2.body)
   if (#r==0) then
      resp:writeln(JSON.encode({err="can't find id: " .. id}))
      logger:w("uri: %s ;err: %s",req.uri,"can't find id: " ..id)
      return
   else
	 resp:writeln(resp2.body)
   end
end
function update_item(req,resp)
      if req.method=='POST' then req:read_body() end
      resp.headers['Content-Type'] = 'application/json'
      local id = req:get_arg("id")
      if (not id) then
	 resp:writeln(JSON.encode({err="id required"}))
	 logger:w("uri: %s ;err: %s",req.uri,"id required")
	 return
      end
      local old = JSON.decode(ngx.location.capture("/db/_get_item",{args = {id = id}}).body)[1]
      local state = req:get_arg("state",old.item_todo_state)
      local title = req:get_arg("title",old.item_title)
      local content = req:get_arg("content",old.item_content)
      local resp2 = ngx.location.capture("/db/_update_item",
      					 {args = {
					     id = id,
					     state = state,
					     title = title,
					     content = content},
      					  method = ngx.HTTP_POST})
      if(resp2.status ~= 200) then
      	 ngx.exit(resp2.status)
      end
      resp:writeln(resp2.body)
end      
