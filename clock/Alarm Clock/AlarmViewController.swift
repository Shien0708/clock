//
//  AlarmViewController.swift
//  clock
//
//  Created by Shien on 2022/7/11.
//

import UIKit

class AlarmViewController: UIViewController {
    @IBOutlet weak var clocksTableView: UITableView!
    var clocks = [AlarmClock]()
    var editedClockIndex: Int?
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editClocksTableView(_ sender: UIButton) {
        if clocksTableView.isEditing {
            clocksTableView.setEditing(false, animated: true)
            sender.setTitle("編輯", for: .normal)
        } else {
            clocksTableView.setEditing(true, animated: true)
            sender.setTitle("完成", for: .normal)
        }
    }
    
    @IBSegueAction func editClock(_ coder: NSCoder) -> AlarmSettingTableViewController? {
        let  controller = AlarmSettingTableViewController(coder: coder)
        controller?.clock = clocks[clocksTableView.indexPathForSelectedRow!.row]
        controller?.editedClockIndex = clocksTableView.indexPathForSelectedRow!.row
        controller?.delegate = self
        return controller
    }
    
    @IBSegueAction func addClock(_ coder: NSCoder) -> AlarmSettingTableViewController? {
        let controller = AlarmSettingTableViewController(coder: coder)
        controller?.delegate = self
        return controller
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlarmTableViewCell else { return AlarmTableViewCell() }
        cell.timeLabel.text = clocks[indexPath.row].displayTime()
        cell.titleLabel.text = clocks[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        clocks.remove(at: indexPath.row)
        if clocks.count == 0 {
            editButton.isHidden = true
            if clocksTableView.isEditing {
                editButton.setTitle("編輯", for: .normal)
                clocksTableView.setEditing(false, animated: false)
            }
        }
        clocksTableView.deleteRows(at: [indexPath], with: .automatic)
        clocksTableView.reloadData()
    }
}

extension AlarmViewController: AlarmSettingTableViewControllerDelegate {
    func alarmSettingTableViewController(_ controller: AlarmSettingTableViewController, didSet clock: AlarmClock, at index: Int) {
        clocksTableView.setEditing(false, animated: false)
        clocks[index] = clock
        
        clocksTableView.reloadData()
        if clocks.count > 0 {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
    }
    
    func alarmSettingTableViewController(_ controller: AlarmSettingTableViewController, didSet clock: AlarmClock) {
        clocksTableView.setEditing(false, animated: false)
        clocks.append(clock)
        
        clocksTableView.reloadData()
        if clocks.count > 0 {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
    }
    
    func alarmSettingTableViewController(_ controller: AlarmSettingTableViewController, delete clock: AlarmClock, at index: Int) {
        clocks.remove(at: index)
        clocksTableView.reloadData()
        if clocks.count > 0 {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
    }
}

