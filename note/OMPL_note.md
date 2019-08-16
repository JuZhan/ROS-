OMPL (open motion planning liberay)
----

这个手臂规划库是基于sampling的方法，里面提供了不少方案
> planner types [:link:](https://ompl.kavrakilab.org/planners.html)

moveit也是将这个作为手臂规划的默认方法。

但是，这种方法的求解并不是很好，同时[这里](https://github.com/ros-planning/moveit/issues/197)提到默认的求解优化方案是`LBKPIECE`，
不过`RRTConnect`是一个更多人推崇的方案，而且经过[对比](https://github.com/ros-planning/moveit/issues/197#issuecomment-249539630)，
前者的计算耗时也比后者的要多（我自己简单测的结果是前者大概比后者多一倍时间）；所以2016年后的版本好像将默认设置为`RRTConnect`了。
如果想知道自己的默认是什么可以在规划的时候看一下运行`moveit_group.launch`的终端显示的内容。

不过我使用的是ubuntu14.14，indigo在2014年出现，所以它里面的并没有更新默认方法。[设置自己的默认方案](https://github.com/ros-planning/moveit_ros/pull/625#issuecomment-158246373)