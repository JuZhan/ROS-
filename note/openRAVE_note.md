
## 关于openRAVE中获取图片的问题
### couldn't create GLX context
> https://askubuntu.com/questions/745135/how-to-enable-indirect-glx-contexts-iglx-in-ubuntu-14-04-lts-with-nvidia-gfx/747088

I had a similar issue when running some GL applications via 'ssh -X' and solved it by adding "+iglx" to xserver-command in /usr/share/lightdm/lightdm.conf.d/50-xserver-command.conf.
```
[SeatDefaults]
# Dump core
xserver-command=X -core +iglx
```
After which you either reboot or Ctrl-Alt-F1, login, and 'sudo service lightdm restart'.

应该没用了：
   0. new: 还要跟这个改应该就ok了 https://github.com/roboticslab-uc3m/openrave-yarp-plugins/issues/48
   1. 显卡驱动换做nvidia
   2. 我后面在 `/usr/share/X11/xorg.conf.d/` 下面的nvidia文件夹下写入的配置：
   ```
   Section "ServerFlags"  
      Option "AllowIndirectGLX" "on"  
      Option "IndirectGLX" "on"  
   EndSection
   ```
   3. 最后在环境变量里面加入这句
   ```
   export COIN_FULL_INDIRECT_RENDERING=1
   ```
ok

## openRAVE中使用flashLidar获取点云会卡顿

1. 官方的代码里面有提供显示激光效果的设置
```
sensor.Configure(Sensor.ConfigureCommand.RenderDataOn)
```
2. 不用就行了
