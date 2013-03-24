module("main", package.seeall)

function index(req,resp)
   resp:ltp("index.html",{})
end
