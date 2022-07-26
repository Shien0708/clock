//
//  Time Picker.swift
//  clock
//
//  Created by Shien on 2022/7/13.
//

import Foundation
import UIKit

class TimePicker {
    let periods = ["A.M.", "P.M."]
    let hours = [1, 2, 3, 4, 5, 6, 7, 8, 9 ,10 ,11 ,12]
    var seconds: [Int] {
        var nums: [Int] = []
        for num in 1...60 {
            nums.append(num)
        }
        return nums
    }
   
    func displayTimeInPicker(in component: Int, at row: Int) -> NSAttributedString {
        switch component {
        case 0:
            return  NSAttributedString(string: periods[row], attributes: [.foregroundColor:UIColor.white])
        case 1:
            return NSAttributedString(string: String(hours[row%hours.count]), attributes: [.foregroundColor:UIColor.white])
        case 2:
            if seconds[row%seconds.count] < 10 {
                return NSAttributedString(string: "0" + String(seconds[row%seconds.count]), attributes: [.foregroundColor:UIColor.white])
                
            } else {
                return NSAttributedString(string: String(seconds[row%seconds.count]), attributes: [.foregroundColor:UIColor.white])
            }
        default:
            print("something wrong with title")
            return NSAttributedString(string: "", attributes: [.foregroundColor:UIColor.white])
        }
    }
    
    
}
