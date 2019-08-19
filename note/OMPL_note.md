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

### STOMP
这是2011年提出的新算法，基于距离场，优化路径得到较好的轨迹。

这是indigo版本的源码以及操作：https://github.com/ros-industrial/industrial_moveit/tree/indigo-devel

首先先下载`STOMP`的库：

     sudo apt-get install ros-indigo-stomp-moveit

它会同时把`stomp-core`和`stomp-moveit`下载下来，其他的就不用了。然后根据[这里](http://docs.ros.org/melodic/api/moveit_tutorials/html/doc/stomp_planner/stomp_planner_tutorial.html)创建配置文件。

如果这个时候允许手臂规划的话会报错：

    [ERROR] [1566220817.427105460, 4597.815000000]: STOMP Start joint pose is out of bounds
    [ERROR] [1566220817.427169435, 4597.816000000]: STOMP failed to get the start and goal positions


他们的README里面写了，这个算法得提供一个初始姿态`Start pose`，最直接的方法就是在Rviz的`MotionPlanning`这个插件里面操作，在`Planning`一栏的`Start pose`有`Update`的操作，点击后，才可以进行手臂规划，很麻烦。不过好像indigo版本只能先这样？[2018年底](https://github.com/ros-industrial/industrial_moveit/issues/64)作者说他后面改moveit源代码才实现了默认不用设置，暂时无法用`MoveGroup`进行操作。从`melodic`版本的README来看他们已经改成了默认的方法，但是我不知道怎么来弄了。
