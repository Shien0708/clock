//
//  StopClockTableViewController.swift
//  clock
//
//  Created by Shien on 2022/7/20.
//

import UIKit

class CountDownTableViewController: UITableViewController {
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet var timeLabels: [UILabel]!
    let countDownTimer = StopWatch()
    var timer: Timer!
    var times = [0, 0, 0]
    var totalSeconds: Int {
        return times[0]*3600 + times[1]*60 + times[2]
    }
    var hours: [Int] {
        var hours = [Int]()
        for i in 0...23 {
            hours.append(i)
        }
        return hours
    }
    
    var minutes: [Int] {
        var minutes = [Int]()
        for i in 0...59 {
            minutes.append(i)
        }
        return minutes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayTime() {
        if countDownTimer.hour < 10 {
            timeLabels[0].text = "0\(countDownTimer.hour)"
        } else {
            timeLabels[0].text = "\(countDownTimer.hour)"
        }
        if countDownTimer.minute < 10 {
            timeLabels[1].text = "0\(countDownTimer.minute)"
        } else {
            timeLabels[1].text = "\(countDownTimer.minute)"
        }
        
        if countDownTimer.second < 10 {
            timeLabels[2].text = "0\(countDownTimer.second)"
        } else {
            timeLabels[2].text = "\(countDownTimer.second)"
        }
    }
    
    @IBAction func cancelCountDown(_ sender: UIButton) {
        sender.isEnabled = false
        countDownTimer.pause()
        timeView.isHidden = true
        startButton.setTitle("開始", for: .normal)
        startButton.configuration?.baseBackgroundColor = .green
    }
    
    @IBAction func startCountDown(_ sender: UIButton) {
        if sender.titleLabel?.text! == "開始" {
            self.countDownTimer.hour = self.times[0]
            self.countDownTimer.minute = self.times[1]
            self.countDownTimer.second = self.times[2]
        }
        if sender.titleLabel?.text == "開始" || sender.titleLabel?.text == "繼續" {
            self.countDownTimer.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
                if self.countDownTimer.second == 0 && self.countDownTimer.minute == 0 {
                    if self.countDownTimer.hour == 0 {
                        self.setNotification()
                        self.countDownTimer.pause()
                        self.timeView.isHidden = true
                        self.startButton.setTitle("開始", for: .normal)
                        self.startButton.configuration?.baseBackgroundColor = .green
                        self.cancelButton.isEnabled = false
                        return
                    } else {
                        self.countDownTimer.second = 59
                        self.countDownTimer.minute = 59
                        self.countDownTimer.hour -= 1
                    }
                } else if self.countDownTimer.second == 0 && self.countDownTimer.minute != 0 {
                    self.countDownTimer.second = 59
                    self.countDownTimer.minute -= 1
                }
                print(self.countDownTimer.second)
                self.timeView.isHidden = false
                sender.configuration?.baseBackgroundColor = .orange
                sender.setTitle("暫停", for: .normal)
                self.cancelButton.isEnabled = true
                self.displayTime()
                self.countDownTimer.fire(hour: self.countDownTimer.hour, minute: self.countDownTimer.minute, second: self.countDownTimer.second)
            })
        } else {
            countDownTimer.pause()
            startButton.setTitle("繼續", for: .normal)
            startButton.configuration?.baseBackgroundColor = .green
        }
    }
}

extension CountDownTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        case 2:
            return 60
        default:
            print("something wrong with component")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch component {
        case 0:
            return NSAttributedString(string: String(hours[row]), attributes: [.foregroundColor : UIColor.white])
        case 1:
            return NSAttributedString(string: String(minutes[row]), attributes: [.foregroundColor: UIColor.white])
        case 2:
            return NSAttributedString(string: String(minutes[row]), attributes: [.foregroundColor: UIColor.white])
        default:
            print("something wrong with row title")
            return NSAttributedString(string: "", attributes: [.foregroundColor: UIColor.white])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            times[0] = hours[row]
            
        case 1:
            times[1] = minutes[row]
            
        case 2:
            times[2] = minutes[row]
            
        default:
            print("something wrong with component")
        }
    }
}

extension CountDownTableViewController {
    func setNotification() {
        print("notification is triggered")
        let content = UNMutableNotificationContent()
        content.title = "時鐘"
        content.body = "計時器"
        let request = UNNotificationRequest(identifier: "countDownNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

