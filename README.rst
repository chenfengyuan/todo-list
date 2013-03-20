===========
 TODO-LIST
===========

TODO LIST是一个简单的todo list服务

实现功能
--------

实现增删改等功能

实现方式
--------
- 基于appwill的moochine
- 后端存储用PostgreSQL和Redis
- 用AJAX刷新

项目完成计划
------------

1) 了解和尝试moochine,PostgreSQL和Redis,写一个hello world.
2) 初步确定存储方式,写个对数据库等的简单封装,实现增加删除修改等功能(后台).
3) 在网页端(前台)实现增加删除修改等功能.
4) 完善功能,改进UI

进度
----
1) 本来使用luasql-postgres来和PostgreSQL交互,准备换成ngx_postgres,打算在PostgreSQL里存放todo资料,在Redis里存放当前用户的一些信息,因为没有接触过,不好估计时间,预计花一个下午时间熟悉相应的模块,然后做个demo出来看看.
2) 现在大概知道如何通过ngx_postgres来和数据库交互了,晚上尝试写个可以添加修改删除的简单demo出来.
3) 现在可以用 http://127.0.0.1:9800/index 来获取整个列表,用类似 curl "http://localhost:9800/db/update_item?id=1&title=title40" GET/POST的方式创建,修改,删除了.准备明天实现网页端的功能.

体会
----
a) 看了下 Demiao Lin(ldmiao <at< gmail.com>推荐的文章之一: `由Lua 粘合的Nginx生态环境`_,才体会到原来协程是这么用的,lua是多么好用.接下去赶紧尝试下.


   
.. _由Lua 粘合的Nginx生态环境: http://blog.zoomquiet.org/pyblosxom/oss/openresty-intro-2012-03-06-01-13.html
