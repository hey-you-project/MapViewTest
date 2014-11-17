//
//  ViewController.swift
//  MapTest
//
//  Created by Cameron Klein on 11/13/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
  
  var HORIZONTAL_CURVE_OFFSET = 2
  var VERTICAL_CURVE_OFFSET = 15
  
  let customDarkOrange  = UIColor(red: 250 / 255.0, green: 105 / 255.0, blue: 0   / 255.0, alpha: 1)
  let customLightOrange = UIColor(red: 243 / 255.0, green: 134 / 255.0, blue: 48  / 255.0, alpha: 1)
  let customBlue        = UIColor(red: 105 / 255.0, green: 210 / 255.0, blue: 231 / 255.0, alpha: 1)
  let customTeal        = UIColor(red: 167 / 255.0, green: 219 / 255.0, blue: 216 / 255.0, alpha: 1)
  let customBeige       = UIColor(red: 224 / 255.0, green: 228 / 255.0, blue: 204 / 255.0, alpha: 1)
  
  var currentCommentViewController : CommentViewController!
  var mapView : MKMapView!
  var originalCircleCenter : CGPoint!
  var draggableCircle: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView = MKMapView(frame: self.view.frame)
    self.view.addSubview(mapView)
    
    currentCommentViewController = CommentViewController(nibName: "CommentViewController", bundle: NSBundle.mainBundle());
    
    let recog2 = UITapGestureRecognizer()
    recog2.addTarget(self, action: "didTap:")
    mapView.addGestureRecognizer(recog2)
    
    addCircleView()
    addHamburgerMenuCircle()
    
  }
  
  
  func addCircleView() {
    var circleView = UIView(frame: CGRect(x: self.view.frame.width - 100, y: self.view.frame.height - 100, width: 60, height: 60))
    circleView.layer.cornerRadius = circleView.frame.height / 2
    circleView.backgroundColor = customBeige
    circleView.layer.shadowColor = UIColor.blackColor().CGColor
    circleView.layer.shadowOpacity = 0.6
    circleView.layer.shadowRadius = 3.0
    circleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    
    self.draggableCircle = UIView(frame: CGRect(origin: CGPoint(x: circleView.frame.origin.x + 17.5, y: circleView.frame.origin.y + 17.5), size: CGSize(width: 25, height: 25)))
    draggableCircle.layer.cornerRadius = draggableCircle.frame.height / 2
    draggableCircle.backgroundColor = customBlue
    self.originalCircleCenter = draggableCircle.center;
    
    draggableCircle.layer.shadowColor = UIColor.blackColor().CGColor
    draggableCircle.layer.shadowOpacity = 0.8
    draggableCircle.layer.shadowRadius = 1.0
    draggableCircle.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    
    self.view.addSubview(circleView)
    self.view.addSubview(draggableCircle)
    
    let dragger = UIPanGestureRecognizer()
    dragger.addTarget(self, action: "didDragCircle:")
    draggableCircle.addGestureRecognizer(dragger)
    
  }
  
  func addHamburgerMenuCircle() {
    
    var circleView = UIView(frame: CGRect(x: self.view.frame.origin.x + 40, y: self.view.frame.height - 100, width: 60, height: 60))
    circleView.layer.cornerRadius = circleView.frame.height / 2
    circleView.backgroundColor = customBeige
    circleView.layer.shadowColor = UIColor.blackColor().CGColor
    circleView.layer.shadowOpacity = 0.6
    circleView.layer.shadowRadius = 3.0
    circleView.layer.shadowOffset = CGSize(width: 0, height: 3)
    self.view.addSubview(circleView)
    
    var hamburgerLabel = UILabel(frame: CGRect(origin: CGPoint(x: circleView.bounds.origin.x + 20, y: circleView.bounds.origin.y + 17.5), size: CGSize(width: 25, height: 25)))
    hamburgerLabel.text = "\u{e116}"
    hamburgerLabel.font = UIFont(name: "typicons", size: 30)
    hamburgerLabel.textColor = customDarkOrange
    
    hamburgerLabel.layer.shadowColor = UIColor.blackColor().CGColor
    hamburgerLabel.layer.shadowOpacity = 0.8
    hamburgerLabel.layer.shadowRadius = 1.0
    hamburgerLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    circleView.addSubview(hamburgerLabel)
    
    let tap = UITapGestureRecognizer()
    tap.addTarget(self, action: "didTapHamburger:")
    circleView.addGestureRecognizer(tap)
    
  }
  
  func spawnPopupAtPoint(point: CGPoint) {
    
    self.addChildViewController(currentCommentViewController)
    self.view.addSubview(currentCommentViewController.view)
    currentCommentViewController.view.alpha = 0
    
    currentCommentViewController.view.frame = CGRect(x: self.view.frame.origin.x + 20, y: point.y - 170, width: self.view.frame.width - 40, height: 200)
    
    let newRect = CGRect(x: currentCommentViewController.view.bounds.origin.x, y: currentCommentViewController.view.bounds.origin.y, width: currentCommentViewController.view.bounds.width, height: currentCommentViewController.view.bounds.height - 50)
    
    let path = UIBezierPath(roundedRect: newRect, cornerRadius: 10)
    
    var combinedPath = CGPathCreateMutableCopy(path.CGPath)
    var triangle = CGPathCreateMutable()
    
    let newTouchPoint = currentCommentViewController.view.convertPoint(point, fromView: self.view)
    
    CGPathMoveToPoint   (triangle, nil, newTouchPoint.x,      newTouchPoint.y)
    CGPathAddArcToPoint (triangle, nil, newTouchPoint.x - 2,  newTouchPoint.y - 15, newTouchPoint.x - 10, newTouchPoint.y - 20, 20)
    CGPathAddLineToPoint(triangle, nil, newTouchPoint.x - 10, newTouchPoint.y - 20)
    CGPathAddLineToPoint(triangle, nil, newTouchPoint.x + 10, newTouchPoint.y - 20)
    CGPathAddArcToPoint (triangle, nil, newTouchPoint.x + 3,  newTouchPoint.y - 15, newTouchPoint.x, newTouchPoint.y, 20)
    CGPathAddLineToPoint(triangle, nil, newTouchPoint.x,      newTouchPoint.y)
    CGPathCloseSubpath  (triangle)
    
    //      CGPathMoveToPoint(triangle, nil, self.view.frame.width / 2, self.view.frame.height - 20)
    //      CGPathAddLineToPoint(triangle, nil, (self.view.frame.width / 2) - 20, self.view.frame.height - 60)
    //      CGPathAddLineToPoint(triangle, nil, (self.view.frame.width / 2) + 20, self.view.frame.height - 60)
    //      CGPathAddLineToPoint(triangle, nil, self.view.frame.width / 2, self.view.frame.height - 20)
    
    CGPathAddPath(combinedPath, nil, triangle)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = combinedPath
    
    currentCommentViewController.view.layer.mask = shapeLayer
    
    currentCommentViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    UIView.animateWithDuration(0.2,
      delay: 0.0,
      usingSpringWithDamping: 0.6,
      initialSpringVelocity: 0.2,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        self.currentCommentViewController.view.alpha = 1
        self.currentCommentViewController.view.transform = CGAffineTransformMakeScale(1, 1);
      },
      completion: { (success) -> Void in
        return ()
    })
    
  }
  
  func didTap(sender: UITapGestureRecognizer){
    
    UIView.animateWithDuration(0.2,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.4,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        self.currentCommentViewController.view.alpha = 0
        self.draggableCircle.center = self.originalCircleCenter
      },
      completion: { (success) -> Void in
        self.currentCommentViewController.view.removeFromSuperview()
        self.currentCommentViewController.removeFromParentViewController()
    })
  }
  
  func didDragCircle(sender: UIPanGestureRecognizer){
    
    if sender.state == .Changed {
      draggableCircle.center = sender.locationInView(self.view)
    } else if sender.state == .Ended {
      spawnPopupAtPoint(sender.locationInView(self.view))
    }
  }
  
  func didTapHamburger(sender: UITapGestureRecognizer){
    
    if sender.state == .Ended {
      //self.showSideMenu()
    }
    
  }
  
}


