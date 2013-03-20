module("db", package.seeall)
local JSON = require("cjson")
function create_item(req,resp)
   req:read_body()
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
