//
//  ToneSettingTableViewController.swift
//  clock
//
//  Created by Shien on 2022/7/15.
//

import UIKit

class ToneSettingTableViewController: UITableViewController {

    @IBOutlet weak var songNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    @IBSegueAction func showMedia(_ coder: NSCoder) -> MusicViewController? {
        let controller = MusicViewController(coder: coder)
        controller?.delegate = self
        return controller
    }
    
}

extension ToneSettingTableViewController: MusicViewControllerDelegate {
    func musicViewController(_ controller: MusicViewController, with title: String) {
        songNameLabel.text = title
    }
}


extension ToneSettingTableViewController {
    func setNavigationBar() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        let bar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        bar.standardAppearance = barAppearance
        bar.tintColor = .white
        let barItem = UINavigationItem(title: "提示聲")
        barItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(dismissPage))
        barItem.leftBarButtonItem?.tintColor = .orange
        bar.items?.append(barItem)
        bar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.addSubview(bar)
    }
    
    @objc func dismissPage() {
        self.dismiss(animated: true)
    }
}
