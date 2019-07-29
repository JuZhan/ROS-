# Fetch Gazebo 7 for indigo

### 安装
ros-indigo自带的本来是Gazebo2，但是Gazebo中自己导入obj文件的功能只在Gazebo7以上的版本才出现，所以先卸载了Gazebo2

 ```
 sudo apt-get remove gazebo2*
```
然后可以使用下面的文件安装Gazebo7

> https://github.com/nubot-nudt/simatch/blob/master/gazebo7_install.sh
接着安装包
 ```
 sudo apt-get install ros-indigo-gazebo7-ros
 sudo apt-get install ros-indigo-gazebo7-ros-control
 sudo apt-get install ros-indigo-gazebo7-...(全部)
```
但是这样会把fetch_gazebo的ROS包都一起被删除，由于Gazebo7的存在，Fetch官方提供的包不能直接下载和使用。

不过他们有提供不同版本的Gazebo下的包（虽然只给Gazebo2提供了命令行下载），链接如下，clone下来后将branch切换为gazebo7就行了（注意是origin/gazebo7，不是0.7.0那些分支）。
> https://github.com/fetchrobotics/fetch_gazebo.git



### 配置环境
如果是临时用的包，就直接克隆到自己的开发项目里面用就行。

如果要长期使用的，我是创建了一个空白ros项目，然后将```fetch_gazebo```的代码克隆下来，```catkin_make```后，将这个项目路径写入```.bashrc```里（暂不清楚怎么安装本地的包）。

### 可能的问题

    ResourceNotFound: rgbd_launch
    ROS path [0]=/opt/ros/indigo/share/ros
    ROS path [1]=/home/zhan/env/fetch_gazebo/src
    ROS path [2]=/opt/ros/indigo/share
    ROS path [3]=/opt/ros/indigo/stacks

这时需要安装：
```sudo apt-get install ros-indigo-rgbd-launch```

Gazebo版本替换的时候，原先使用的Gazebo的项目得删除掉`devel`和`build`文件夹，重新`catkin_make`。

### 卸载回Gazebo2
和安装的流程差不多，不过有些`libsdformatxxxx`这种库文件要慢慢找，一个一个卸载。具体的可以先下载Gazebo2的时候看哪些文件不让下载一个一个试。
