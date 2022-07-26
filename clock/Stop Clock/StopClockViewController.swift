//
//  TimerViewController.swift
//  clock
//
//  Created by Shien on 2022/7/19.
//

import UIKit

class StopClockViewController: UIViewController {
    @IBOutlet weak var recordTableView: UITableView!
    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    var milliSecond = 0
    var second = 0
    var minute = 0
    var timer: Timer?
    var records = [String]()
    var lastRecords = [0, 0, 0]
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundButton.layer.cornerRadius = roundButton.bounds.width/2
        startButton.layer.cornerRadius = startButton.bounds.width/2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setRound(_ sender: UIButton) {
        var theMilliSecond = milliSecond
        var theSecond = second
        var theMinute = minute
        
        if sender.titleLabel?.text == "分圈" {
            while theMilliSecond < lastRecords[2] {
                theMilliSecond += 100
                theSecond -= 1
            }
            while theSecond < lastRecords[1] {
                theSecond += 60
                theMinute -= 1
            }
            print(theMinute,theSecond, theMilliSecond)
            print(lastRecords)
            records.append(displayTime(theMinute-lastRecords[0], theSecond-lastRecords[1], theMilliSecond-lastRecords[2]))
            lastRecords[0] = theMinute
            lastRecords[1] = theSecond
            lastRecords[2] = theMilliSecond
            
        } else {
            timerLabel.text = "00:00.00"
            milliSecond = 0
            second = 0
            minute = 0
            lastRecords = [0, 0, 0]
            records.removeAll()
        }
        recordTableView.reloadData()
    }
    
    @IBAction func start(_ sender: Any) {
        if startButton.backgroundColor == .red {
            roundButton.setTitle("重置", for: .normal)
            timer?.invalidate()
            startButton.backgroundColor = .green
            startButton.setTitle("開始", for: .normal)
        } else {
            roundButton.setTitle("分圈", for: .normal)
            roundButton.isEnabled = true
            runByMilliSecond()
            startButton.backgroundColor = .red
            startButton.setTitle("暫停", for: .normal)
        }
    }
    
    func displayTime(_ minute: Int, _ second: Int, _ milliSecond: Int)->String {
        var minuteString = ""
        var secondString = ""
        var milliSecondString = ""
        if minute < 10 {
            minuteString = "0\(minute)"
        } else {
            minuteString = "\(minute)"
        }
        if second < 10 {
            secondString = "0\(second)"
        } else {
            secondString = "\(second)"
        }
        if milliSecond < 10 {
            milliSecondString = "0\(milliSecond)"
        } else {
            milliSecondString = "\(milliSecond)"
        }
        return "\(minuteString):\(secondString).\(milliSecondString)"
    }
    
    func runByMilliSecond() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1/100), repeats: true, block: { _ in
            self.milliSecond += 1
            if self.milliSecond == 100 {
                self.milliSecond = 0
                self.second += 1
            }
            if self.second == 60 {
                self.second = 0
                self.minute += 1
            }
            self.timerLabel.text = self.displayTime(self.minute, self.second, self.milliSecond)
        })
    }
}

extension StopClockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordTableViewCell else {
            return RecordTableViewCell()
        }
        cell.roundLabel.text = "第 \(records.count-indexPath.row) 圈"
        cell.timeLabel.text = "\(records[records.count-indexPath.row-1])"
        return cell
    }
}
