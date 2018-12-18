#!/usr/bin/python
# -*- coding: utf-8 -*-
import math

import cv2
import numpy as np

class RectPainter(object):
    '''Use `draw_rect` to draw, press `esc` to exit and save the data in `box.txt`
```
(0,0) > 0 ________1
        |         |
        |         |
        3 _______ 2
```
    '''
    def __init__(self):
        self.drawing = False
        self.points = []
        self.start = None
        self.roll_angle = 0.0

    def mouse_callback(self, event, x, y, flags, param):
        if event == cv2.EVENT_LBUTTONDOWN:
            # 第一次点击开始绘制
            if self.drawing == False:
                self.drawing = True
                self.points = []
                self.start = (x, y)
                # 按下鼠标左键，记录下当前坐标点

            else:
                # 第二次点击进入旋转（绕左上点）
                self.drawing = False
                # 这些向量用来计算点的坐标
                self.width = np.add(self.points[1], np.multiply(self.points[0], -1))
                self.diag = np.add(self.points[2], np.multiply(self.points[0], -1))
                self.height = np.add(self.points[3], np.multiply(self.points[0], -1))
                # 矩阵用来计算矩阵旋转后的坐标的
                self.axis_matrix = np.zeros((4, 2))  
                self.axis_matrix[1] = self.width
                self.axis_matrix[2] = self.diag
                self.axis_matrix[3] = self.height
                self.axis_matrix = np.transpose(self.axis_matrix)

        elif event == cv2.EVENT_MOUSEMOVE:
            if self.drawing:
                #鼠标移动，画出矩形框（未旋转）
                min_x = min(self.start[0], x)
                min_y = min(self.start[1], y)
                max_x = max(self.start[0], x)
                max_y = max(self.start[1], y)

                self.points = []

                self.points.append((min_x, min_y))
                self.points.append((max_x, min_y))
                self.points.append((max_x, max_y))
                self.points.append((min_x, max_y))
                self.show_rect() # 显示画框后的图像

        elif event == cv2.EVENT_RBUTTONDOWN:
            self.drawing = False
            cv2.imshow('img', self.img)  # 显示原始的图像
            self.points = []

    def key_callback(self, key):
        '''Key events to control the rect'''
        if key == 27:   # Esc
            print "Nothing to save"
            return
            
        if key == 81:  # Left_arrow
            min_x = min(i[0] for i in self.points)
            if min_x > 0:
                points = []
                for i in self.points:
                    move_i = np.add(i, (-1, 0))
                    points.append((move_i[0], move_i[1]))
                self.points = points

        elif key == 82:  # Up_arrow
            min_y = min(i[1] for i in self.points)
            if min_y > 0:
                points = []
                for i in self.points:
                    move_i = np.add(i, (0, -1))
                    points.append((move_i[0], move_i[1]))
                self.points = points

        elif key == 83:  # Right_arrow
            max_x = max(i[0] for i in self.points)
            if max_x < self.MAX_X:
                points = []
                for i in self.points:
                    move_i = np.add(i, (1, 0))
                    points.append((move_i[0], move_i[1]))
                self.points = points

        elif key == 84:  # Down_arrow
            max_y = max(i[1] for i in self.points)
            if max_y < self.MAX_Y:
                points = []
                for i in self.points:
                    move_i = np.add(i, (0, 1))
                    points.append((move_i[0], move_i[1]))
                self.points = points

        elif key == 45:  # minus '-'
            self.roll_angle -= 1
            self.rotate_rect()
        elif key == 61:  # equal '='
            self.roll_angle += 1
            self.rotate_rect()

        self.show_rect()

    def rotate_rect(self):
        '''Calc the points coordinates after rotation'''
        arc = self.roll_angle * np.pi / 180.0
        cos_theta = np.cos(arc)
        sin_theta = np.sin(arc)
        rotation_maxtrix = np.zeros((2, 2))
        rotation_maxtrix[0, 0] = cos_theta
        rotation_maxtrix[0, 1] = sin_theta * -1
        rotation_maxtrix[1, 0] = sin_theta
        rotation_maxtrix[1, 1] = cos_theta
        
        points = np.dot(rotation_maxtrix, self.axis_matrix)
        points = np.transpose(points)
        points += self.points[0]
        self.points = [
            (i[0], i[1]) for i in points
        ]
    
    def show_rect(self):
        '''Draw the rect'''
        tmp = np.copy(self.img)

        p1 = (int(self.points[0][0]), int(self.points[0][1]))
        p2 = (int(self.points[1][0]), int(self.points[1][1]))
        p3 = (int(self.points[2][0]), int(self.points[2][1]))
        p4 = (int(self.points[3][0]), int(self.points[3][1]))

        cv2.line(tmp, p1, p2, (0, 0, 255))
        cv2.line(tmp, p2, p3, (0, 0, 255))
        cv2.line(tmp, p3, p4, (0, 0, 255))
        cv2.line(tmp, p4, p1, (0, 0, 255))
        cv2.imshow('img', tmp)

    def draw_rect(self, img_path='./openrave.png', data_path='box.txt'):
        '''Draw the rectangular manually, and save at data_path'''
        img = cv2.imread(img_path)
        self.MAX_Y, self.MAX_X = img.shape[0:2]
        cv2.namedWindow('img')
        cv2.setMouseCallback('img', self.mouse_callback)
        self.img = img
        cv2.imshow('img', img)
        while True:
            key = cv2.waitKey(0) & 0xFF
            if key == 27 and self.points != []: # Esc
                np.savetxt(data_path, self.points)
                break
            else:
                self.key_callback(key)
        cv2.destroyWindow('img')

if __name__ == "__main__":
    box = RectPainter()
    box.draw_rect()
