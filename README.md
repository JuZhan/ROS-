ROS
====
![ROS](http://www.ros.org/wp-content/uploads/2013/10/rosorg-logo1.png "ROS") 
<!-- <link href="http://cdn.bootcss.com/highlight.js/8.0/styles/monokai_sublime.min.css" rel="stylesheet">  
<script src="http://cdn.bootcss.com/highlight.js/8.0/highlight.min.js"></script>
<script >hljs.initHighlightingOnLoad();</script> -->

## 创建ROS程序包
1. 创建一个文件夹`my_ws`作为工作区域，在文件夹里面再创建一个`src`文件夹，我们将在`src`文件夹里面创建ROS的包。
2. 进入`my_ws`文件夹，使用命令`catkin_make`创建一个catkin工作空间，然后进入`my_ws/src`使用命令`catkin_create_pkg`创建一个ROS程序包，这里就命名为`moving`。
    创建的命令如下：

        $ mkdir -p ~/my_ws/src
        $ cd my_ws
        $ catkin_make
        $ cd src
        $ catkin_create_pkg moving rospy std_msgs geometry_msgs

    `catkin_create_pkg`后面的第一个参数是程序包的名字，后面的多个参数是依赖包的名字，依赖包是已经存在的程序包，`rospy`、`std_msgs`、`geometry_msgs`是我们这个`moving`里面将要用到的包，所以在创建的时候先声明好，不过我们也可以在`CMakeLists.txt`和`package.xml`里面修改我们要的依赖包。

    最后得到的文件结构如下：
        
        my_ws/
            build/
                ...
            devel/
                setup.bash          --> 记得source一下这个
                ...
            src/
                CMakeLists.txt
                moving/
                    CMakeLists.txt  --> 修改cmake参数
                    package.xml     --> 修改程序包参数
                    src/            --> ROS预先创建的src文件夹
                    
    > **package.xml里面的一些东西（可能和实际生成结果有出入，不过能跑就行了）**


        <!-- catkin是创建工具 -->
        <buildtool_depend>catkin</buildtool_depend>
        
        <!-- 这里就是我们前面声明的需要的依赖包，要什么依赖包就往这里面添加 -->
        <build_depend>geometry_msgs</build_depend>
        <build_depend>rospy</build_depend>
        <build_depend>std_msgs</build_depend>

        <build_export_depend>geometry_msgs</build_export_depend>
        <build_export_depend>rospy</build_export_depend>
        <build_export_depend>std_msgs</build_export_depend>
        
        <exec_depend>geometry_msgs</exec_depend>
        <exec_depend>rospy</exec_depend>
        <exec_depend>std_msgs</exec_depend>

        <export> </export>
    </package>

## 编译ROS程序包
1. 首先我们要source一下ROS的环境配置文件。

        $ source /opt/ros/indigo/setup.bash
2. 进入`my_ws`文件夹，使用命令`catkin_make`开始编译。

        $ cd my_ws
        $ catkin_make
------
## [ROS的一些概念](http://www.guyuehome.com/229 "wiki")
### **node**
每个运行中的程序（python文件和c++编译后的程序）就叫做node。有关node的命令是`rosnode`。
### **master**
ROS需要有一个控制器可以使所有节点有条不紊的执行，这就是一个ROS的控制器（ROS Master）,就像中心服务器一样的存在。有关master的命令是`roscore`。
### **topic**
不同node之间进行信息交流就像网络一样（可能就是网络）,有两种方式：
* message

    两个交流消息的节点分别是`Publisher`发布者和`Subscriber`订阅者，一个发布消息，一个接收消息
* service

    两个交流的节点分别是`Server`服务器和`Client`客户端，服务器要一直运行，而客户端可以在需要的时候运行，就是网络的Client/Server的架构。

节点之间的交流就像收听电台，所谓`topic`就是电台的名字，比如Publisher发布的内容时，会定义个名字，这个名字就是topic。有关topic的命令是`rostopic`。
### **message**
两个交流消息的节点分别是`Publisher`发布者和`Subscriber`订阅者，一个发布消息，一个接收消息
消息由一种特定的文件定义，就是xxx.msg，里面声明了我们要用到的数据类型，比如下面的例子就是在msg文件里面声明了一个整型data和一个字符串name：
> listener.msg
>       
    int64 data
    string name
### **service**
两个交流的节点分别是`Server`服务器和`Client`客户端，客户端发送请求消息，服务器接受请求消息后回复，就是`request`和`response`那一套。

服务也是由一种特定的文件定义的，就是xxx.srv，里面声明的数据类型和message的一毛一样，不过有个不太一样的地方是srv文件的数据分为“请求”和“回复”两部分，之间由`---`分隔开，上半部分是客户端发送请求的数据类型，下半部分是服务端回应请求的数据类型，如果想实现一个客户端发送两个数字给服务器，服务器返回这两个数字之和的功能，我们可以定义下面这个文件：
> addTwoInts.srv
>       
    int64 a
    int64 b
    ---
    int64 sum
-----
## 直接敲代码才能感受到message和service是什么玩意
### **一个简单的发布和接收**
1. 回到前面我们创建的`my_ws`，进入`my_ws/src/moving`，创建一个`msg`文件夹和`scripts`文件夹，一个存放.msg文件，一个存放我们的python代码（直接在写`my_ws/src/moving/src/`也是OK的）

        $ cd my_ws/src/moving
        $ mkdir msg scripts
        $ vi msg/hello.msg
        $ vi scripts/talker.py
        $ vi scripts/listener.py
> hello.msg
>       
    string myData

> talker.py (Publisher)
>       
    #!/usr/bin/env python
    # -*- coding=UTF-8 -*-
    import rospy
    # 也可以直接用我们的依赖包std_msgs里面定义好的String.msg文件
    # 用 "rosmsg show std_msgs/String"可以看到String里面定义的和我们的一样
    # from std_msgs.msg import String
    from moving.msg import hello
    def talker():
        # 声明了一个发布者pub，名字为“chatter”，这里的“chatter”就是我们的topic
        # 发布的消息类型是我们创建好的hello.msg里面定义的类型
        # queuesize是发布者的询问次数，用来判断是否有订阅者接受到消息了
        pub = rospy.Publisher('chatter', hello, queue_size=10)
        # 前面说我们运行的py脚本就是一个节点，这里就是这个节点的初始化内容
        # 节点名字为“talker”，anonymous是为了确保这个节点名字唯一确定
        # 因为我们可能会跑多个代码，这个时候会有重复的名字
        # 如果为True就会在我们定义的名字后面添加一个乱七八糟的数字保证名字唯一性
        # 如果False就不鸟了，自己修改代码感受一下
        rospy.init_node('talker', anonymous=True)
        # rate是用来控制发布的频率，这里是10Hz，即10次/s
        rate = rospy.Rate(10) # 10hz
        # 当我们没有结束程序的时候，一直发布信息
        while not rospy.is_shutdown():
            hello_str = " hello"
            # loginfo是打印运行信息的语句（好像包含时间戳什么的？），当成ROS的cout就行了
            rospy.loginfo(hello_str)
            # 这里我们的发布者pub发布信息hello_str
            pub.publish(hello_str)
            # sleep让程序在我们设定好的时间后醒来（0.1s）
            rate.sleep()

    if __name__ == '__main__':
        try:
            talker()
        except:
            pass



> listener.py (Subscriber)
>       
    #!/usr/bin/env python
    # -*- coding=UTF-8 -*-
    import rospy
    from moving.msg import hello

    def callback(data):
        rospy.loginfo(rospy.get_caller_id() + " ==> I heard %s", data.myData)
        
    def listener():
        # 这个节点就叫做“listener”
        rospy.init_node('listener', anonymous=True)
        # 创建一个订阅者Subscriber，订阅话题就和发布者的一致才能建立起交流
        # 所以订阅的topic为“chatter”，msg为hello，接收到信息后调用回调函数
        rospy.Subscriber("chatter", hello, callback)
        # spin() simply keeps python from exiting until this node is stopped
        # spin()让程序一直运行下去
        rospy.spin()

    if __name__ == '__main__':
        listener()

2. 写好上面的这些代码后，还需要重新编译一下，而且我们这里用到了自己写的msg，所以要在`my_ws/src/moving/CMakeLists.txt`里面修改一下编译的参数，`CmakeLists.txt`里面已经把可以写的参数都写在文件里面，并且把它们注释了，我们找到下面这几个参数，进行修改，具体内容如下，


> CmakeLists.txt（要修改部分）
>               
    find_package( catkin REQUIRED COMPONENTS
        message_generation # 记得加上这个
        rospy
    )

    add_message_files(
        FILES
        hello.msg   # 我们用到了自己定义的hello.msg
                    # 就是在这里声明的
    )

    generate_messages(
        DEPENDENCIES
        moving  # 这个是我们的ROS程序包的名字
                # 因为我们要用到我们自己写的这个包里面的hello.msg文件
    )
3. 回到我们的`my_ws`路径，重新编译一下
    ```
    $ cd xxx/my_ws
    $ catkin_make
    ```
4. 在跑我们的代码前，有个坑注意一下，我们创建的python文件有可能是不可运行的，所以要先更改一下权限。

    ```
    $ cd my_ws/src/moving/scripts
    $ chmod +x *.py   # 将所有python文件改成可运行的
    ```
    然后要开启两个终端，一个运行`talker.py`，一个运行`listener.py`，每个终端都要运行下面的命令。
    ```
    $ cd my_ws
    $ source devel/setup.bash # 一定要跑这句话
    $ cd src/moving/srcipts
    ```
    然后一定要记得开启一个 **第三个终端**，运行我们的`roscore`
    ```
    $ roscore
    ```
5. 完成上面的所有操作后，可以开始跑我们的代码了，总共有3种运行程序的方法：
    1. 使用`python`运行
    >
    >  终端1
    > ```
    > python talker.py
    > ```
    >  终端2
    > ```
    > python listener.py
    > ```
    >
    > 终端1的输出结果
    > ```
    > [INFO] [WallTime: 1510127122.377361]   hello
    > [INFO] [WallTime: 1510127122.477398]   hello
    > [INFO] [WallTime: 1510127122.577426]   hello
    > [INFO] [WallTime: 1510127122.677380]   hello
    > [INFO] [WallTime: 1510127122.777345]   hello
    > [INFO] [WallTime: 1510127122.877358]   hello
    > [INFO] [WallTime: 1510127122.977358]   hello
    > [INFO] [WallTime: 1510127123.077362]   hello
    > [INFO] [WallTime: 1510127123.177419]   hello
    > [INFO] [WallTime: 1510127123.277348]   hello
    > [INFO] [WallTime: 1510127123.377363]   hello
    > [INFO] [WallTime: 1510127123.477353]   hello
    > [INFO] [WallTime: 1510127123.577346]   hello
    > [INFO] [WallTime: 1510127123.677302]   hello
    > [INFO] [WallTime: 1510127123.777298]   hello
    > [INFO] [WallTime: 1510127123.877360]   hello
    > ...
    > ```
    > 终端2的输出结果
    > ```
    > [INFO] [WallTime: 1510127120.878118] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127120.978094] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.078180] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.178131] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.278213] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.378392] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.478166] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.578136] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.678163] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.778169] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.878124] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.978157] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.078196] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.178300] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.278211] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.378174] /listener_27769_1510127115970  ==> I heard   hello
    > ...
    > ```
    2. 使用`rosrun`
    > 首先我们要先`source`一下我们的ROS程序包，以确保ROS可以找到我们写的ROS程序包
    >```
    > $ cd xxx/my_ws
    > $ source devel/setup.bash 
    >```
    >
    >  终端1 (如果运行提示说找不到该文件的话，要么你没有source这个包，要么你的python文件不可运行，要把它修改为可运行文件，参考前面第4步对python文件的修改操作)
    > ```
    > rosrun moving talker.py
    > ```
    >  终端2
    > ```
    > rosrun moving listener.py
    > ```
    > 终端1的输出结果
    > ```
    > [INFO] [WallTime: 1510127122.377361]   hello
    > [INFO] [WallTime: 1510127122.477398]   hello
    > [INFO] [WallTime: 1510127122.577426]   hello
    > [INFO] [WallTime: 1510127122.677380]   hello
    > [INFO] [WallTime: 1510127122.777345]   hello
    > [INFO] [WallTime: 1510127122.877358]   hello
    > [INFO] [WallTime: 1510127122.977358]   hello
    > [INFO] [WallTime: 1510127123.077362]   hello
    > [INFO] [WallTime: 1510127123.177419]   hello
    > [INFO] [WallTime: 1510127123.277348]   hello
    > [INFO] [WallTime: 1510127123.377363]   hello
    > [INFO] [WallTime: 1510127123.477353]   hello
    > [INFO] [WallTime: 1510127123.577346]   hello
    > [INFO] [WallTime: 1510127123.677302]   hello
    > [INFO] [WallTime: 1510127123.777298]   hello
    > [INFO] [WallTime: 1510127123.877360]   hello
    > ...
    > ```
    > 终端2的输出结果
    > ```
    > [INFO] [WallTime: 1510127120.878118] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127120.978094] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.078180] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.178131] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.278213] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.378392] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.478166] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.578136] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.678163] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.778169] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.878124] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127121.978157] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.078196] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.178300] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.278211] /listener_27769_1510127115970  ==> I heard   hello
    > [INFO] [WallTime: 1510127122.378174] /listener_27769_1510127115970  ==> I heard   hello
    > ...
    > ```
    3. 使用`roslaunch`
    > 要用这个方法的话我们也是要要先`source`一下我们的ROS程序包，以确保ROS可以找到我们写的ROS程序包，而且对于每个新开启的命令行，如果要使用这个ROS程序包的话，都要记得`source`一下这个ROS程序包的`setup.bash`
    >```
    > $ cd xxx/my_ws
    > $ source devel/setup.bash 
    >```
    > 然后我们要编写一个`talk.launch`，其实名字随你便，重要的是后缀名为”`.launch`“。
    > 
    > `launch`文件其实就是一个`XML`语言格式的文本，里面定义了你要跑的各个节点和参数信息，如果要同时运行多个node，这是最好的选择。
    > ```
    > $ cd xxx/my_ws/src/moving
    > $ mkdir launch
    > $ cd launch
    > $ vi talk.launch
    > $ vi listen.launch
    > ```
    > talk.launch
    > ```
    > <launch>
    >       <!-- 这个文件运行的是talker.py -->
    >       <node pkg="moving" type="talker.py" name="ListenToMe" output="screen"/>
    ></launch>
    >  ```
    >
    > listen.launch
    > ```
    > <launch>
    >       <!-- 这个文件运行的是listener.py -->
    >       <node pkg="moving" type="listener.py" name="IAmListening" output="screen"/>
    ></launch>
    >  ```
    >  终端1 (如果运行提示说找不到该文件的话，要么你没有source这个包，要么你的python文件不可运行，要把它修改为可运行文件，参考前面第4步对python文件的修改操作)
    > ```
    > roslaunch moving talk.launch
    > ```
    >  终端2
    > ```
    > roslaunch moving listen.launch
    > ```
    > 终端1的输出结果
    > ```
    > ... logging to /home/juzhan/.ros/log/4b3a7bf2-c922-11e7-a593-1866da390d4f/roslaunch-moha-14654.log
    > Checking log directory for disk usage. This may take awhile.
    > Press Ctrl-C to interrupt
    > Done checking log file disk usage. Usage is <1GB.
    > 
    > started roslaunch server http://localhost:43385/
    > 
    > SUMMARY
    > ========
    > 
    > PARAMETERS
    >  * /rosdistro: indigo
    >  * /rosversion: 1.11.21
    > 
    > NODES
    >   /
    >     TalkerIsTalking (moving/talker.py)
    > 
    > ROS_MASTER_URI=http://localhost:11311
    > 
    > core service [/rosout] found
    > process[TalkerIsTalking-1]: started with pid [14674]
    > ^C[TalkerIsTalking-1] killing on exit
    > shutting down processing monitor...
    > ... shutting down processing monitor complete
    > 
    > ```
    > 终端2的输出结果
    > ```
    > ... logging to /home/juzhan/.ros/log/4b3a7bf2-c922-11e7-a593-1866da390d4f/roslaunch-moha-15533.log
    > Checking log directory for disk usage. This may take awhile.
    > Press Ctrl-C to interrupt
    > Done checking log file disk usage. Usage is <1GB.
    > 
    > started roslaunch server http://localhost:32896/
    > 
    > SUMMARY
    > ========
    > 
    > PARAMETERS
    >  * /rosdistro: indigo
    >  * /rosversion: 1.11.21
    > 
    > NODES
    >   /
    >     IAmListening (moving/listener.py)
    > 
    > ROS_MASTER_URI=http://localhost:11311
    > 
    > core service [/rosout] found
    > process[IAmListening-1]: started with pid [15551]
    > ^C[IAmListening-1] killing on exit
    > shutting down processing monitor...
    > ... shutting down processing monitor complete
    > 
    > ```
6. 你会发现用`roslaunch`的结果不太对劲，我也第一次运行这个，反正这是在运行中的node，不信你自己用`rosnode`和`rostopic`去看看，看了`roslaunch`在这种情况下不太实用，不过在控制机器人的运行的那些程序用`roslaunch`就挺好的。

# todo









<!-- 
+ asd 
+ asd
    > asd 
> [GOOGLE](https://google.com/ "google")
> asd 
>> 1. as
>> 2. as

    #include <iostream>
    int main(){
        return 0;
    }
----

I get 10 times more traffic from Google [1] than from
[Yahoo] [2] or [MSN] [3].

  [1]: http://google.com/        "Google"
  [2]: http://search.yahoo.com/  "Yahoo Search"
  [3]: http://search.msn.com/    "MSN Search"

**as** _a_ __a__
* <http://www.baidu.com> -->