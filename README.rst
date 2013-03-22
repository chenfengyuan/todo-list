===========
 TODO-LIST
===========

TODO LIST是一个简单的todo list服务

运行
----
::
   
   # 启动postgres
   $ postgres -D /usr/local/var/postgres
   # 初始化数据库
   $ /path/to/todo-list/todo-list-demo/bin/create-db.sh 
   # 启动todo-list
   $ /path/to/todo-list/todo-list-demo/bin/start.sh
   # 浏览器打开http://127.0.0.1:9800/
   # 左侧是新增修改栏,输入内容后按Submit创建新的todo item,创建出来的item会出现右边.按Clear来清空输入,按Change Todo来切换Todo状态.
   # 右边的会显示每个todo item.todo状态若是TODO则颜色会是红色,若是DONE则颜色是绿色.
   # 按Delete按钮删除当前todo item,按Modify将当前的todo item复制到左边,修改后按Submit提交.
   # 也可以直接按Change Todo来切换当前todo状态.
   # 前端和后端全部通过ajax交互.

截图
----
1) http://cfy.googlecode.com/files/Screen%20Shot%202013-03-22%20at%201.13.01%20PM.png

实现功能
--------

实现增删改等功能

实现方式
--------
- 基于appwill的moochine
- 后端存储用PostgreSQL和Redis
- 用AJAX刷新

项目完成目标
------------

1) 了解和尝试moochine,PostgreSQL和Redis,写一个hello world.
2) 初步确定存储方式,写个对数据库等的简单封装,实现增加删除修改等功能(后台).
3) 在网页端(前台)实现增加删除修改等功能.
4) 完善功能,改进UI

进度
----
1) 3.20中午:本来使用luasql-postgres来和PostgreSQL交互,准备换成ngx_postgres,打算在PostgreSQL里存放todo资料,在Redis里存放当前用户的一些信息,因为没有接触过,不好估计时间,预计花一个下午时间熟悉相应的模块,然后做个demo出来看看.
2) 3.20下午:现在大概知道如何通过ngx_postgres来和数据库交互了,晚上尝试写个可以添加修改删除的简单demo出来.
3) 3.20晚上:现在可以用 http://127.0.0.1:9800/index 来获取整个列表,用类似 curl "http://localhost:9800/db/update_item?id=1&title=title40" GET/POST的方式创建,修改,删除了.准备明天实现网页端的功能.
4) 3.21早上:花一个上午的时间了解下bootstrap
5) 3.21下午:可以做到在web端更新和删除item,通过ajax方式实现.
6) 3.21晚上:已经可以修改了,而且还做了下对html entities的encode/decode.不过todo状态还没做到web上.
7) 3.22上午:已经加入了todo状态功能.不过目前界面有点丑.
   
计划
----
1) 准备用3.21下午的时间做个简单的web前端出来.
2) 准备用3.21晚上的时间把修改功能做出来,然后再优化下用户界面.
3) 准备3.22在web上加入todo状态的功能,稳定api.然后看看可以增加啥别的新功能.
4) 准备在3.22下午开个新的分支整理代码稳定api,统一方式.现在的处理方式有点乱.有时间的话,再美化下页面.

体会
----
a) 看了下 Demiao Lin(ldmiao <at< gmail.com>推荐的文章之一: `由Lua 粘合的Nginx生态环境`_,才体会到原来协程是这么用的,lua是多么好用.接下去赶紧尝试下.


   
.. _由Lua 粘合的Nginx生态环境: http://blog.zoomquiet.org/pyblosxom/oss/openresty-intro-2012-03-06-01-13.html
