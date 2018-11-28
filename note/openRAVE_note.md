
关于openRAVE中获取图片的问题

### couldn't create GLX context
> https://askubuntu.com/questions/745135/how-to-enable-indirect-glx-contexts-iglx-in-ubuntu-14-04-lts-with-nvidia-gfx/747088

> https://github.com/roboticslab-uc3m/openrave-yarp-plugins/issues/48

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
