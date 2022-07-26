//
//  ViewController.swift
//  clock
//
//  Created by Shien on 2022/7/11.
//

import UIKit


class ViewController: UIViewController {
    var timeZoneStrings = [String]()
    @IBOutlet weak var timeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func displayTime(id: String) -> String {
        let now = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: id)
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: now)
    }
    
    @IBAction func unwindToViewController(unwindSegue: UIStoryboardSegue) {
        let sourceController = unwindSegue.source as? TimeZonesTableViewController
        timeZoneStrings.append(sourceController!.filteredStrings[sourceController!.selectedRow])
        timeTableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TimeTableViewCell else {return TimeTableViewCell() }
        cell.locationLabel.text = timeZoneStrings[indexPath.row]
        cell.timeLabel.text = displayTime(id: timeZoneStrings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timeZoneStrings.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        timeZoneStrings.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
