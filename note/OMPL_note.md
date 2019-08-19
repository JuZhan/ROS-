OMPL (open motion planning liberay)
----

这个手臂规划库是基于sampling的方法，里面提供了不少方案[:link:](https://ompl.kavrakilab.org/planners.html)

moveit也是将这个作为手臂规划的默认方法。

但是，这种方法的求解并不是很好，同时[这里](https://github.com/ros-planning/moveit/issues/197)提到默认的求解优化方案是`LBKPIECE`，
不过`RRTConnect`是一个更多人推崇的方案，而且经过[对比](https://github.com/ros-planning/moveit/issues/197#issuecomment-249539630)，
前者的计算耗时也比后者的要多（我自己简单测的结果是前者大概比后者多一倍时间）；所以2016年后的版本好像将默认设置为`RRTConnect`了。
如果想知道自己的默认是什么可以在规划的时候看一下运行`moveit_group.launch`的终端显示的内容。

不过我使用的是ubuntu14.14，indigo在2014年出现，所以它里面的并没有更新默认方法。[设置自己的默认方案](https://github.com/ros-planning/moveit_ros/pull/625#issuecomment-158246373)

----

后来我又发现，虽然配置文件改了，RVIZ的moveit插件里面确实是`RRTConnect`的方法，然而我用代码写`move_group`的时候调用的还是`LBK`，不过也只要多一句代码就行：
```move_group.setPlannerId("RRTConnectkConfigDefault")```


### TODO
除了OMPL，还有专门针对路径优化的规划方法：[CHOMP](https://ros-planning.github.io/moveit_tutorials/doc/chomp_planner/chomp_planner_tutorial.html)。

虽然`fetch_moveit_config`里面有CHOMP的配置文件，但是运行的时候被告知没有这个插件。

