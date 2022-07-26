//
//  MusicViewController.swift
//  clock
//
//  Created by Shien on 2022/7/18.
//

import UIKit
import MediaPlayer
protocol MusicViewControllerDelegate {
    func musicViewController(_ controller: MusicViewController, with title: String)
}

class MusicViewController: UIViewController {
    var delegate: MusicViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        showMediaController()
    }
    
    func showMediaController() {
        let  controller = MPMediaPickerController()
        controller.delegate = self
        present(controller, animated: true)
    }
}

extension MusicViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        delegate.musicViewController(self, with: (mediaItemCollection.items.last?.title)!)
        mediaPicker.dismiss(animated: true)
        self.dismiss(animated: true)
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
        self.dismiss(animated: true)
    }
}
