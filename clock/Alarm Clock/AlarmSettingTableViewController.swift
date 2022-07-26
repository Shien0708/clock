//
//  AlarmSettingTableViewController.swift
//  clock
//
//  Created by Shien on 2022/7/11.
//

import UIKit


@objc protocol AlarmSettingTableViewControllerDelegate: NSObjectProtocol {
    @objc optional func alarmSettingTableViewController(_ controller: AlarmSettingTableViewController, didSet clock: AlarmClock)
    @objc optional func alarmSettingTableViewController(_ controller: AlarmSettingTableViewController, didSet clock: AlarmClock, at index: Int)
    @objc optional func alarmSettingTableViewController(_ controller: AlarmSettingTableViewController, delete clock: AlarmClock, at index: Int)
}

class AlarmSettingTableViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var deleteCell: UITableViewCell!
    let timePicker = TimePicker()
    var editedClockIndex: Int?    
    var clock = AlarmClock()
    var controller: AlarmViewController!
    var delegate: AlarmSettingTableViewControllerDelegate?
    
    let now = Date.now
    var timeComponents: DateComponents?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if editedClockIndex != nil {
            deleteCell.isHidden = false
        } else {
            deleteCell.isHidden = true
        }
        setNavBar()
    }
    @IBAction func deleteClock(_ sender: UIButton) {
        if let editedClockIndex = editedClockIndex {
            delegate?.alarmSettingTableViewController?(self, delete: clock, at: editedClockIndex)
        }
        self.dismissPage()
    }
    
    func getDuration() -> Int {
        let nowComponent = Calendar.current.dateComponents(in: TimeZone.current, from: now)
        let nowSecond = nowComponent.hour! * 3600 + nowComponent.minute! * 60 + nowComponent.second!
        var dueSecond = 0
        if let timeComponents = timeComponents {
            dueSecond = timeComponents.hour! * 3600 + timeComponents.minute! * 60 + (timeComponents.second ?? 0)
        }
        if dueSecond-nowSecond < 0 {
            return (24*3600)+dueSecond-nowSecond
        } else {
            return dueSecond-nowSecond
        }
        
    }
    
    @objc func storeClock() {
        if clock.period == "A.M." {
            timeComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, hour: clock.hour, minute: clock.minute)
        } else {
            timeComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, hour: clock.hour+12, minute: clock.minute)
        }
        
        createNotification(getDuration())
        self.dismiss(animated: true)
        
        if let editedClockIndex = editedClockIndex {
            delegate?.alarmSettingTableViewController!(self, didSet: clock, at: editedClockIndex)
        } else {
            delegate?.alarmSettingTableViewController?(self, didSet: clock)
        }
    }
    
    @objc func dismissPage() {
        self.dismiss(animated: true)
    }
    
    @IBSegueAction func editTitle(_ coder: NSCoder) -> ClockTitleViewController? {
        let controller = ClockTitleViewController(coder: coder)
        controller?.delegate = self
        controller?.clockTitle = clock.title
        return controller
    }
    
    
}

// set time picker
extension AlarmSettingTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return timePicker.periods.count
        case 1:
            return timePicker.hours.count*1000
        case 2:
            return timePicker.seconds.count*1000
        default:
            print("something wrong with component")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        timePicker.displayTimeInPicker(in: component, at: row)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            clock.period = timePicker.periods[row]
        case 1:
            clock.hour = timePicker.hours[row%timePicker.hours.count]
        case 2:
            clock.minute = timePicker.seconds[row%timePicker.seconds.count]
        default:
            print("something wrong with title")
        }
    }
}

// set navigation bar and items
extension AlarmSettingTableViewController {
    func setNavBar() {
        let navBackground = UINavigationBarAppearance()
        navBackground.configureWithTransparentBackground()
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        navBar.standardAppearance = navBackground
        navBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        let navBarItem = UINavigationItem(title: "加入鬧鐘")
        navBarItem.setLeftBarButtonItems([UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(dismissPage))], animated: true)
        navBarItem.leftBarButtonItem?.tintColor = .orange
        navBarItem.setRightBarButton(UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(storeClock)), animated: true)
        navBarItem.rightBarButtonItem?.tintColor = .orange
        navBar.items?.append(navBarItem)
        view.addSubview(navBar)
    }
}

extension AlarmSettingTableViewController: ClockTitleViewControllerDelegate {
    func clockTitleViewController(_ controller: ClockTitleViewController, didEdited clockTitle: String) {
        clock.title = clockTitle
        titleLabel.text = clockTitle
    }
}

extension AlarmSettingTableViewController {
    func createNotification(_ time: Int) {
        print("notification is triggered")
        var trigger: UNTimeIntervalNotificationTrigger?
        var request: UNNotificationRequest!
        let content = UNMutableNotificationContent()
        content.title = "鬧鐘"
        content.body = "起床囉"
        content.sound = .default
        content.badge = 1
        
        if time > 0 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
            request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
        } else {
            request = UNNotificationRequest(identifier: "notification", content: content, trigger: nil)
        }
        UNUserNotificationCenter.current().add(request) { error in
            print("build notification successfully")
        }
    }
}

