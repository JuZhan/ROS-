# VcXsrv

## 用于显示WSL下Ubuntu的图形界面的工具
1. windows上安装WSL
2. windows安装VcXsrv
3. 在ubuntu的`.bashrc`加上一句： `export DISPLAY=:0`
4. 在ubuntu的`.bashrc`加上一句：`export LIBGL_ALWAYS_INDIRECT=`
4. windows上启动VcXsrv，记得在初始设置界面的时候将`-1`改为`0`
5. 可能还需要在最后的设置界面中加上一句命令`-nowgl`
6. 然后wsl中的图形界面就可以直接出现在windows上了。

### 2004版本后的wsl将支持GPU，微软NB
