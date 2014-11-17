//
//  PopoverView.swift
//  MapTest
//
//  Created by Cameron Klein on 11/13/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class PopoverView: UIView {

  
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
      println("Draw Rect Called!")
      
      var context = UIGraphicsGetCurrentContext()
      
      CGContextBeginPath(context)
      CGContextMoveToPoint(context, rect.minX, rect.minY) //upper left
      CGContextMoveToPoint(context, rect.maxX, rect.minY) //upper right
      CGContextMoveToPoint(context, rect.maxX, rect.maxY) //lower right
      CGContextMoveToPoint(context, rect.minX, rect.minY) //upper left
      CGContextClosePath(context)
      
      CGContextClip(context)
      
      var path = UIBezierPath(roundedRect: rect, cornerRadius: 50)
      var radius = 10
      
      // determine where the arrow is
//      CGFloat arrowEdge = CGRectGetMidY(outerRect) + self.arrowOffset - (ARROW_BASE / 2.0f);
//      CGRect arrowRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(outerRect) + arrowEdge, ARROW_HEIGHT, ARROW_BASE);
      
      //start in upper left corner
      path.moveToPoint(CGPoint(x: rect.minX, y: rect.minY))
      path.addArcWithCenter(CGPoint(x: rect.maxX, y: rect.minY), radius: 10, startAngle: 270, endAngle: 0, clockwise: true)
      path.addArcWithCenter(CGPoint(x: rect.maxX, y: rect.maxY), radius: 10, startAngle: 0, endAngle: 90, clockwise: true)
      path.addArcWithCenter(CGPoint(x: rect.minX, y: rect.maxY), radius: 10, startAngle: 90, endAngle: 180, clockwise: true)
      
      
    }
  
  
  

}
