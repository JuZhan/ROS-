# Fetch Gazebo 7 for indigo

### 安装
ros-indigo自带的本来是Gazebo2，但是Gazebo中自己导入obj文件的功能只在Gazebo7以上的版本才出现，所以根据下面的指导我卸载了Gazebo2
> http://www.laomn.com/article/item/62213


比较重要的是下面的几句命令（不过还算乖乖看上面的指导）：

 ```
 sudo apt-get remove gazebo2*  # 我是直接gazebo2
 ---------------
 sudo apt-get install gazebo7
 sudo apt-get install ros-indigo-gazebo7-ros-pkgs
# 这个就安装了Gazebo7
 ```
但是这样会把fetch_gazebo的ROS包都一起被删除，由于Gazebo7的存在，Fetch官方提供的包不能直接下载和使用。

不过他们有提供不同版本的Gazebo下的包（虽然只给Gazebo2提供了命令行下载），链接如下，clone下来后将branch切换为gazebo7就行了（注意是orgin/gazebo7，不是0.7.0那些分支）。
> https://github.com/fetchrobotics/fetch_gazebo.git

### 配置环境
如果是临时用的包，就直接克隆到自己的开发项目里面用就行。

如果要长期使用的，我是创建了一个空白ros项目，然后将```fetch_gazebo```的代码克隆下来，```catkin_make```后，将这个项目路径写入```.bashrc```里（暂不清楚怎么安装本地的包）。
