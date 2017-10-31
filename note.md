ROS
====
![ROS](http://www.ros.org/wp-content/uploads/2013/10/rosorg-logo1.png "ROS") 
<link href="http://cdn.bootcss.com/highlight.js/8.0/styles/monokai_sublime.min.css" rel="stylesheet">  
<script src="http://cdn.bootcss.com/highlight.js/8.0/highlight.min.js"></script>
<script >hljs.initHighlightingOnLoad();</script>

## 创建ROS程序包
1. 创建一个文件夹`my_ws`作为工作区域，在文件夹里面再创建一个`src`文件夹，我们将在`src`文件夹里面创建ROS的包。
2. 进入`my_ws`文件夹，使用命令`catkin_make`创建一个catkin工作空间，然后进入`my_ws/src`使用命令`catkin_create_pkg`创建一个ROS程序包，这里就命名为`moving`。
    创建的命令如下：

        mkdir -p ~/my_ws/src
        cd my_ws
        catkin_make
        cd src
        catkin_create_pkg moving rospy std_msgs geometry_msgs

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
                    
    > **package.xml里面的一些东西**


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

    source /opt/ros/indigo/setup.bash
2. 进入`my_ws`文件夹，使用命令`catkin_make`开始编译。

    cd my_ws
    catkin_make
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

    cd my_ws/src/moving
    mkdir msg scripts
    vi msg/hello.msg
    vi scripts/talker.py
    vi scripts/listener.py
> hello.msg
>       
    string myData

> talker.py (Publisher)
>       
    #!/usr/bin/env python
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
            hello_str = "hello"
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
    import rospy
    from moving.msg import hello

    def callback(data):
        rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.MyData)
        
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

2. 写好上面的这些代码后，还需要重新编译一下，而且我们这里用到了自己写的msg，所以要在`my_ws/src/moving/CMakeLists.txt`里面修改一下编译的参数，具体内容如下：

















<!-- + asd 
+ asd
    > asd 
> [GOOGLE](https://google.com/ "google")
>> asd 
>>> 1. as
>>> 2. as

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