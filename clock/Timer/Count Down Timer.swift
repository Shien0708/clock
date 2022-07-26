//
//  Count Down Timer.swift
//  clock
//
//  Created by Shien on 2022/7/20.
//

import Foundation

class StopWatch {
    var seconds = 0
    var timer: Timer!
    var hour = 0
    var minute = 0
    var second = 0
    func fire(hour: Int, minute: Int, second: Int) {
        seconds = hour*3600 + minute*60 + second
        seconds -= 1
        self.second -= 1
    }
    func pause() {
        timer.invalidate()
    }
}
