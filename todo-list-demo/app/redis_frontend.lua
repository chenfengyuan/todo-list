module("redis_frontend", package.seeall)

local JSON = require("cjson")
local utils = require("awutils")

-- todo items data key
local tl = "tl_items_data"
-- todo items id key
local tl_ids = "tl_items_ids"
-- todo items id sequence
local tl_s = "tl_items_sequence"

function redis_connect()
   local redis = require "resty.redis"
   local red = redis:new()
   red:set_timeout(1000)
   local ok, err = red:connect("127.0.0.1", 6379)
   if not ok then
      ngx.say("failed to connect: ", err)
      return
   end
   return red
end   

local push = function(arr,item)
   arr[#arr+1]=item
end

function get_all_items()
   local red = redis_connect()
   local items = {}
   for _,v in pairs(red:lrange(tl_ids,0,-1)) do
      push(items,JSON.decode(red:hget(tl,v)))
   end
   return items
end

function get_last_item()
   local red = redis_connect()
   local id = red:rpop(tl_ids)
   red:rpush(tl_ids,id)
   return {JSON.decode(red:hget(tl,id))}
end

function get_item(id)
   local red = redis_connect()
   return {JSON.decode(red:hget(tl,id))}
end

function count_items()
   local red = redis_connect()
   return red:llen(tl_ids)
end

function create_item(title,state,content)
   local red = redis_connect()
   local id = red:incr(tl_s)
   red:rpush(tl_ids,id)
   return red:hset(tl,id,JSON.encode({item_todo_state = state,
				      item_id = id,
				      item_title = title,
				      item_content = content}))
end

function update_item(id,state,title,content)
   local red = redis_connect()
   return red:hset(tl,id,JSON.encode({item_todo_state = state,
				      item_id = id,
				      item_title = title,
				      item_content = content}))
end

function delete_item(id)
   local red = redis_connect()
   red:lrem(tl_ids,1,id)
   return red:hdel(tl,id)
end
function test(req,resp)
   resp:writeln(utils.strify(count_items()))
end

