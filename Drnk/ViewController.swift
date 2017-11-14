//
//  ViewController.swift
//  Drnk
//
//  Created by Caelin Jackson-King on 2017-11-13.
//  Copyright © 2017 Caelin Jackson-King. All rights reserved.
//

import UIKit

enum DrnkSpeeds: Int {
    case lightweight = 10
    case midweight = 8
    case heavyweight = 6
    case slav = 4
}

let speedNames: Dictionary<DrnkSpeeds, String> = [
    .lightweight: "Lightweight",
    .midweight: "Midweight",
    .heavyweight: "Heavyweight",
    .slav: "Slav",
]

class ViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var drnkButton: UIButton!
    var timer: Timer? = nil
    var curSpeed: Int = DrnkSpeeds.lightweight.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let progressBar = progressBar,
//        let messageLabel = messageLabel,
//        let drnkButton = drnkButton else {
//            return
//        }
        
        setupProgress()
    }

    @IBAction func drnkTouchUpInside(_ sender: Any) {
        setupProgress()
    }
    
    @IBAction func settingsTouchUpInside(_ sender: Any) {
        showChoices(of: [.lightweight, .midweight, .heavyweight, .slav])
    }
    
    func setupProgress(from percent: Float = 0.0) {
        timer?.invalidate()
        var timeSinceStart: Float = percent
        weak var weakSelf = self
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {(T) in
            guard let progressBar = weakSelf?.progressBar,
            let curSpeed = weakSelf?.curSpeed else {
                return
            }
            
            progressBar.progress = timeSinceStart / Float(curSpeed)
            timeSinceStart = timeSinceStart + 0.01
            if !(timeSinceStart < Float(curSpeed)) {
                T.invalidate()
            }
        })
    }
    
    func showChoices(of options: [DrnkSpeeds]) {
        let alertController = UIAlertController(title: "Select your tolerance",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        for drnkSpeed in options {
            weak var weakSelf = self
            alertController.addAction(UIAlertAction(title: speedNames[drnkSpeed],
                                          style: .default,
                                          handler: { (action) -> Void in
                weakSelf?.curSpeed = drnkSpeed.rawValue
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

