# Jump-Jump-helper

Tiao Yi Tiao, loosely translated as Jump Jump, is a mini game on Wechat. Players move a balck block from one platform to another by tapping the smartphone screen. A point is scored for each successful jump. Players need to tap the screen longer when the jumping distance between the platforms is greater. This repo will help you get high score in the game automatically.

![alt text](https://github.com/zhangchicheng/Jump-Jump-helper/blob/master/images/game.png)

## Getting Started

Currently, only Android smartphone is supported. Before you run the script [JumpJump](https://github.com/zhangchicheng/Jump-Jump-helper/blob/master/src/JumpJump.m) you need to install and setup Android Debug Bridge (adb) which can catch screenshot, pull images and simulate touch events. To use ADB with your Android device, you must enable USB debugging in the device system settings, under Developer options.

## Result

Running the JumpJump script you will get some results as follows:

![alt text](https://github.com/zhangchicheng/Jump-Jump-helper/blob/master/images/ellipse.png)
![alt text](https://github.com/zhangchicheng/Jump-Jump-helper/blob/master/images/rectangle.png)

## Note

Detecting ellipse is a time-consuming task. To reduce computational complexity, we do some optimization which may cause detection failure as follow:

![alt text](https://github.com/zhangchicheng/Jump-Jump-helper/blob/master/images/bad.png)
