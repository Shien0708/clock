//
//  ClockTitleViewController.swift
//  clock
//
//  Created by Shien on 2022/7/13.
//

import UIKit

protocol ClockTitleViewControllerDelegate {
    func clockTitleViewController(_ controller: ClockTitleViewController, didEdited clockTitle: String)
}

class ClockTitleViewController: UIViewController {
    var delegate: ClockTitleViewControllerDelegate?
    @IBOutlet weak var titleTextField: UITextField!
    var clockTitle = "鬧鐘"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        self.isModalInPresentation = true
        titleTextField.text = clockTitle
        titleTextField.becomeFirstResponder()
    }
    
    func setNavigationBar() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        navBar.standardAppearance = barAppearance
        let barItem = UINavigationItem(title: "標籤")
        barItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(buttonTapped))
        barItem.leftBarButtonItem?.tintColor = .orange
        navBar.items?.append(barItem)
        view.addSubview(navBar)
    }

    @objc func buttonTapped() {
        if let title = titleTextField.text, title.isEmpty == false {
            delegate?.clockTitleViewController(self.self, didEdited: title)
        } else {
            delegate?.clockTitleViewController(self.self, didEdited: "鬧鐘")
        }
        
        self.dismiss(animated: true)
    }
   
}
