//
//  Alarm Clock.swift
//  clock
//
//  Created by Shien on 2022/7/13.
//

import Foundation

@objc class AlarmClock: NSObject {
    var hour = 1
    var minute = 1
    var period = "A.M."
    var title = "鬧鐘"
    
    func displayTime()->String {
        if minute < 10 {
            return "\(period) \(hour):0\(minute)"
        } else {
            return "\(period) \(hour):\(minute)"
        }
    }
}
