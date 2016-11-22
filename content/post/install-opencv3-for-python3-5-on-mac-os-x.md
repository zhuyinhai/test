+++
title = "Install Opencv3 for Python3.5 on Mac OS X"
description = "在 Mac OS X 上安装 Opencv3 (Python3.5)"
date = "2016-08-01T21:17:51+08:00"
tags = ["Python","opencv"]

+++


## 通过 homebrew 安装 opencv

通过 homebrew 安装在 Mac OS X 上安装为 Python3.5 安装 Opencv3：

```
$ brew install opencv3 --with-python3
......
......
This formula is keg-only, which means it was not symlinked into /usr/local.

opencv3 and opencv install many of the same files.

Generally there are no consequences of this for you. If you build your
own software and it requires this formula, you'll need to add to your
build variables:

    LDFLAGS:  -L/usr/local/opt/opencv3/lib
    CPPFLAGS: -I/usr/local/opt/opencv3/include

==> Summary
```

<!--more-->

安装完成后，会有如上提示。接下来需要做的事，将 `opencv3` 的 `site-packegs` 链接到 `Python3` 的 `site-packegs`:

```
echo /usr/local/opt/opencv3/lib/python3.5/site-packages >> /usr/local/lib/python3.5/site-packages/opencv3.pth
```

## 检查是否安装成功

```
$ python
>>> import cv2
>>> cv2.__version__
'3.1.0'
```

---
Github Issue: [https://github.com/nodejh/test/issues/106](https://github.com/nodejh/test/issues/106)
