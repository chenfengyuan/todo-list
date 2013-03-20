#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : ldmiao
--

module("test", package.seeall)

local JSON = require("cjson")
local Redis = require("resty.redis")
local utils = require("awutils")

local push = function(arr,item)
   arr[#arr+1]=item
end

function hello(req, resp, name)
   logger:i("hello request started!")
   if req.method=='GET' then
      -- resp:writeln('Host: ' .. req.host)
      -- resp:writeln('Hello, ' .. ngx.unescape_uri(name))
      -- resp:writeln('name, ' .. req.uri_args['name'])
      resp.headers['Content-Type'] = 'application/json'
      resp:writeln(JSON.encode(req.uri_args))

      resp:writeln({{'a','c',{'d','e', {'f'}}},'b'})
   elseif req.method=='POST' then
      -- resp:writeln('POST to Host: ' .. req.host)
      req:read_body()
      resp.headers['Content-Type'] = 'text/plain'
      resp:writeln(name)
      for k,v  in pairs(req.post_args) do
	 resp:writeln(k..','..v)
      end
   end
   logger:i("hello request completed!")
end


function longtext(req, resp)
   -- local a = string.rep("xxxxxxxxxx", 100000)
   -- resp:writeln(a)
   -- resp:finish()
   
   local red = Redis:new()
   local ok, err = red:connect("127.0.0.1", 6379)
   if not ok then
      resp:writeln({"failed to connect: ", err})
   end

   --red:set_timeout(30)

   -- for i=1,1000 do
   --    local k = "foo"..tostring(i)
   --    red:set(k, "bar"..tostring(i))
   --    local v = red:get(k)
   --    ngx.log(ngx.ERR, "i:"..tostring(i), ", v:", v)
   
   --    ngx.sleep(1)
   -- end
   local foo = red:get("foo")
   -- foo = foo + 1
   resp:writeln(foo)
   -- red:set("foo",foo)
end

function ltp(req, resp)
   resp:ltp("ltp.html", {v="hello, moochine!",
			 content = {
			    column = {
			       [==[
				   <h1>Hello World Column One</h1>
				   <p>Hello <?lua= 1+1 ?>!</p>
				]==],
			       [==[
				       <h1>Hello World Column Two</h1>
				       <p>Hello <?lua= 1+2 ?>!</p>
				    ]==]
			    }}})
end

function index(rep,resp)
   local todo_lists2={}
   local todo_lists={
      {title="title-a",content="content-a"},
      {title="title-b",content="content-b"}}
   -- resp:ltp("index.html",{todo_lists = todo_lists})
   -- resp:ltp("index.html",{todo_lists = todo_lists2})
   local resp2 = ngx.location.capture("/db/get_items?limit=3");
   resp:ltp("index.html",{todo_lists = JSON.decode(resp2.body)})
   -- resp:writeln(utils.strify(JSON.decode(resp2.body)))
   -- ngx.say(ngx.var.uri, ": ", ngx.var.dog)
end
