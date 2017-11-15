#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import rospy
from moving.msg import hello
import tf

def talker():
    listener = tf.TransformListener
    
    pub = rospy.Publisher('chatter', hello, queue_size=10)
    rospy.init_node('talker', anonymous=True)
    rate = rospy.Rate(10)  # 10hz
    while not rospy.is_shutdown():
        hello_str = "  hello"
        rospy.loginfo(hello_str)
        pub.publish(hello_str)
        rate.sleep()


if __name__ == '__main__':
    try:
        talker()
    except:
        pass
