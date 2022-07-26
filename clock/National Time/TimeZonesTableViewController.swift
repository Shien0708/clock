//
//  TimeZonesTableViewController.swift
//  clock
//
//  Created by Shien on 2022/7/11.
//

import UIKit

class TimeZonesTableViewController: UITableViewController {
    var filteredStrings = [String]()
    let timeZoneStrings = NSTimeZone.knownTimeZoneNames
    var selectedRow = 0
    let searchBar = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredStrings = timeZoneStrings
        setSearchBar()
    }
    
    func setSearchBar() {
        searchBar.automaticallyShowsCancelButton = false
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.hidesNavigationBarDuringPresentation = false
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredStrings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var configuration = UIListContentConfiguration.cell()
        configuration.text = filteredStrings[indexPath.row]
        cell.contentConfiguration = configuration as UIContentConfiguration
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepared")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        searchBar.dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension TimeZonesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let string = searchController.searchBar.text, string.isEmpty
            != true {
            filteredStrings = timeZoneStrings.filter { timeZone in
                return timeZone.contains(string)
            }
        } else {
            filteredStrings = timeZoneStrings
        }
        tableView.reloadData()
    }
}
