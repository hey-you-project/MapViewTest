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
  
  // MARK: Child View Controllers
  var mapView : MKMapView!
  var currentCommentViewController : CommentViewController!
  var sideMenuVC : SideMenuViewController!
  var hamburgerWrapper : UIView!
  var hamburgerLabel : UILabel!
  
  // MARK: Subviews and UI Elements
  var originalCircleCenter : CGPoint!
  var draggableCircle: UIView!
  var dragCircleWrapper : UIView!
  
  // MARK: Color Palette
  let customDarkOrange  = UIColor(red: 250 / 255.0, green: 105 / 255.0, blue: 0   / 255.0, alpha: 1)
  let customLightOrange = UIColor(red: 243 / 255.0, green: 134 / 255.0, blue: 48  / 255.0, alpha: 1)
  let customBlue        = UIColor(red: 105 / 255.0, green: 210 / 255.0, blue: 231 / 255.0, alpha: 1)
  let customTeal        = UIColor(red: 167 / 255.0, green: 219 / 255.0, blue: 216 / 255.0, alpha: 1)
  let customBeige       = UIColor(red: 224 / 255.0, green: 228 / 255.0, blue: 204 / 255.0, alpha: 1)
  
  // MARK: Constants
  var kHorizontalCurveOffset : CGFloat = 2
  var kVerticalCurveOffset   : CGFloat = 15
  var kPopupHeight           : CGFloat = 540
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = customTeal
    
    setupSideMenu()
    setupMapView()
    addCircleView()
    addHamburgerMenuCircle()
    setupGestureRecognizers()

    currentCommentViewController = CommentViewController(nibName: "CommentViewController", bundle: NSBundle.mainBundle())

  }
  
  
  func addCircleView() {
    
    dragCircleWrapper = UIView(frame: CGRect(x: self.view.frame.width - 100, y: self.view.frame.height - 100, width: 60, height: 60))
    dragCircleWrapper.layer.cornerRadius = dragCircleWrapper.frame.height / 2
    dragCircleWrapper.backgroundColor = customBeige
    dragCircleWrapper.layer.shadowColor = UIColor.blackColor().CGColor
    dragCircleWrapper.layer.shadowOpacity = 0.6
    dragCircleWrapper.layer.shadowRadius = 3.0
    dragCircleWrapper.layer.shadowOffset = CGSize(width: 0, height: 3)
    
    self.draggableCircle = UIView(frame: CGRect(origin: CGPoint(x: dragCircleWrapper.frame.origin.x + 17.5, y: dragCircleWrapper.frame.origin.y + 15), size: CGSize(width: 25, height: 25)))
    draggableCircle.layer.cornerRadius = draggableCircle.frame.height / 2
    draggableCircle.backgroundColor = customBlue
    self.originalCircleCenter = draggableCircle.center;
    
    draggableCircle.layer.shadowColor = UIColor.blackColor().CGColor
    draggableCircle.layer.shadowOpacity = 0.8
    draggableCircle.layer.shadowRadius = 1.0
    draggableCircle.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    self.view.addSubview(dragCircleWrapper)
    self.view.addSubview(draggableCircle)
    
    let dragger = UIPanGestureRecognizer()
    dragger.addTarget(self, action: "receivedDragGestureOnDragCircle:")
    draggableCircle.addGestureRecognizer(dragger)
    
  }
  
  func addHamburgerMenuCircle() {
    
    hamburgerWrapper = UIView(frame: CGRect(x: self.view.frame.origin.x + 40, y: self.view.frame.height - 100, width: 60, height: 60))
    hamburgerWrapper.layer.cornerRadius = hamburgerWrapper.frame.height / 2
    hamburgerWrapper.backgroundColor = customBeige
    hamburgerWrapper.layer.shadowColor = UIColor.blackColor().CGColor
    hamburgerWrapper.layer.shadowOpacity = 0.6
    hamburgerWrapper.layer.shadowRadius = 3.0
    hamburgerWrapper.layer.shadowOffset = CGSize(width: 0, height: 3)
    self.view.addSubview(hamburgerWrapper)
    
    hamburgerLabel = UILabel(frame: CGRect(origin: CGPoint(x: hamburgerWrapper.bounds.origin.x + 19, y: hamburgerWrapper.bounds.origin.y + 17.5), size: CGSize(width: 25, height: 25)))
    hamburgerLabel.text = "\u{e116}"
    hamburgerLabel.font = UIFont(name: "typicons", size: 30)
    hamburgerLabel.textColor = customDarkOrange
    
    hamburgerLabel.layer.shadowColor = UIColor.blackColor().CGColor
    hamburgerLabel.layer.shadowOpacity = 0.8
    hamburgerLabel.layer.shadowRadius = 1.0
    hamburgerLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    hamburgerWrapper.addSubview(hamburgerLabel)
    
    let tap = UITapGestureRecognizer()
    tap.addTarget(self, action: "receivedTapGestureOnHamburgerButton:")
    hamburgerWrapper.addGestureRecognizer(tap)
    
  }
  
  func spawnPopupAtPoint(point: CGPoint) {
    
    self.addChildViewController(currentCommentViewController)
    self.view.addSubview(currentCommentViewController.view)
    currentCommentViewController.view.alpha = 0
    
    currentCommentViewController.view.frame = CGRect(x: self.view.frame.origin.x + 20, y: point.y - (kPopupHeight - 30), width: self.view.frame.width - 40, height: kPopupHeight)
    
    let vcBounds = currentCommentViewController.view.bounds
    
    let newRect = CGRect(x: vcBounds.origin.x, y: vcBounds.origin.y, width: vcBounds.width, height: vcBounds.height - 50)
    
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
  
  func receivedTapGestureOnMapView(sender: UITapGestureRecognizer){
    
    unpopCurrentComment()
    returnDragCircleToHomeBase()
    
  }
  
  func receivedDragGestureOnDragCircle(sender: UIPanGestureRecognizer){
    
    if sender.state == .Changed {
      draggableCircle.center = sender.locationInView(self.view)
    } else if sender.state == .Ended {
      spawnPopupAtPoint(sender.locationInView(self.view))
    }
    
  }
  
  func receivedTapGestureOnHamburgerButton(sender: UITapGestureRecognizer){
    
    if sender.state == .Ended {
      self.toggleSideMenu()
    }
    
  }
  
  func receivedPanFromLeftEdge(sender: UIScreenEdgePanGestureRecognizer) {
    
    if sender.state == .Changed {
      let offsetX = sender.translationInView(self.view).x
      mapView.frame.origin.x = offsetX
      
    }
  }
  
  func toggleSideMenu() {
  if self.mapView.frame.origin.x == 0{
    returnDragCircleToHomeBase()
    }
    unpopCurrentComment()
    
    UIView.animateWithDuration(0.4,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.4,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        if self.mapView.frame.origin.x == 0{
          self.mapView.center.x += 200
          self.dragCircleWrapper.center.x += 200
          self.draggableCircle.center.x += 200
          self.hamburgerWrapper.layer.shadowOffset = CGSize(width: 0, height: 6)
          self.hamburgerWrapper.layer.shadowRadius = 4.0
         
        } else {
          self.mapView.center.x -= 200
          self.dragCircleWrapper.center.x -= 200
          self.draggableCircle.center = self.originalCircleCenter
          self.hamburgerWrapper.layer.shadowOffset = CGSize(width: 0, height: 3)
          self.hamburgerWrapper.layer.shadowRadius = 3.0
          
        }
      }) { (success) -> Void in
        return ()
    }
    
      if self.mapView.frame.origin.x == 0{
        self.hamburgerLabel.text = "\u{e116}"
        self.hamburgerLabel.transform = CGAffineTransformMakeScale(1, 1)
        self.hamburgerLabel.center.x -= 6
      } else {
        self.hamburgerLabel.text = "\u{e122}"
        self.hamburgerLabel.transform = CGAffineTransformMakeScale(1.4, 1.4)
        self.hamburgerLabel.center.x += 6
      }

  }
  
  func returnDragCircleToHomeBase() {
    UIView.animateWithDuration(0.2,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.4,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        self.draggableCircle.center = self.originalCircleCenter
      },
      completion: { (success) -> Void in
        return ()
    })
  }
  
  func unpopCurrentComment() {
    UIView.animateWithDuration(0.2,
      delay: 0.0,
      usingSpringWithDamping: 0.0,
      initialSpringVelocity: 0.0,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        self.currentCommentViewController.view.alpha = 0
      },
      completion: { (success) -> Void in
        self.currentCommentViewController.view.removeFromSuperview()
        self.currentCommentViewController.removeFromParentViewController()
    })
  }
  
  func setupSideMenu(){
    
    sideMenuVC = SideMenuViewController(nibName:"SideMenuViewController", bundle: NSBundle.mainBundle())
    self.addChildViewController(sideMenuVC)
    self.view.addSubview(sideMenuVC.view)
    sideMenuVC.view.frame = CGRect(x: 0, y: 0, width: 200, height: self.view.frame.height)
    sideMenuVC.view.backgroundColor = customTeal
    
  }
  
  func setupMapView(){
    
    mapView = MKMapView(frame: self.view.frame)
    self.view.addSubview(mapView)
    mapView.clipsToBounds = false
    mapView.layer.shadowColor = UIColor.blackColor().CGColor
    mapView.layer.shadowOpacity = 0.6
    mapView.layer.shadowRadius = 3.0
    mapView.layer.shadowOffset = CGSize(width: -5, height: 0)
    
  }
  
  func setupGestureRecognizers() {
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: "receivedTapGestureOnMapView:")
    mapView.addGestureRecognizer(tapRecognizer)
    
    let edgePanRecognizer = UIScreenEdgePanGestureRecognizer()
    edgePanRecognizer.addTarget(self, action: "receivedPanFromLeftEdge:")
    edgePanRecognizer.edges = UIRectEdge.Left
    self.view.addGestureRecognizer(edgePanRecognizer)
    
  }
  
}


