//
//  CommentViewController.swift
//  MapTest
//
//  Created by Cameron Klein on 11/13/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  @IBOutlet weak var picker: UIPickerView!
  
  let firstArray = ["Girl","Boy","Jerk"]
  let secondArray = ["With", "In", "On"]
  let thirdArray = ["The", "A"]
  let fourthArray = ["Red", "Green", "Blue", "Orange"]
  let fifthArray = ["Hair", "Shirt", "Shoes"]

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 5
  }

  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch component{
    case 0:
      return firstArray.count * 3
    case 1:
       return secondArray.count * 3
    case 2:
       return thirdArray.count * 3
    case 3:
       return fourthArray.count * 3
    case 4:
       return fifthArray.count * 3
    default:
      return 0
    }
  }
  
  func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
    
    var pickerViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.rowSizeForComponent(component).width, height: picker.rowSizeForComponent(component).height))
    pickerViewLabel.textAlignment = NSTextAlignment.Center
    
    switch component{
    case 0:
      pickerViewLabel.text = firstArray[row % firstArray.count]
    case 1:
      pickerViewLabel.text = secondArray[row % secondArray.count]
    case 2:
      pickerViewLabel.text = thirdArray[row % thirdArray.count]
    case 3:
      pickerViewLabel.text = fourthArray[row % fourthArray.count]
    case 4:
      pickerViewLabel.text = fifthArray[row % fifthArray.count]
    default:
      println("Ok")
    }
    
    pickerViewLabel.font = UIFont(name: "Heavyweight", size: 20)
    pickerViewLabel.textColor = UIColor.orangeColor()
  
    return pickerViewLabel

  }
  
  func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 20
  }
  
  func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return 50
  }
}
