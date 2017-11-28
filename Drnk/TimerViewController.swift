//
//  ViewController.swift
//  Drnk
//
//  Created by Caelin Jackson-King on 2017-11-13.
//  Copyright © 2017 Caelin Jackson-King. All rights reserved.
//

import UIKit

enum DrnkSpeeds: String {
    case lightweight
    case midweight
    case heavyweight
    case crazy
}

let timeLimits: Dictionary<DrnkSpeeds, TimeInterval> = [
    .lightweight: 10,
    .midweight: 8,
    .heavyweight: 6,
    .crazy: 4,
]

let updateInterval: TimeInterval = 0.015

class TimerViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var drnkButton: UIButton!
    var timer: Timer? = nil
    var timeLimit: TimeInterval = timeLimits[.lightweight] ?? 10
    var timeDrinking: Float = 0.0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
    }

    // MARK: Actions
    @IBAction func drnkTouchUpInside(_ sender: Any) {
        startTimer()
    }
    
    @IBAction func settingsTouchUpInside(_ sender: Any) {
        showChoices(of: [.lightweight, .midweight, .heavyweight, .crazy])
    }
    
    // MARK: Effects
    func startTimer(from percent: Float = 0.0) {
        timer?.invalidate()
        var timeSinceStart: TimeInterval = TimeInterval(percent * Float(timeLimit))
        weak var weakSelf = self
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: {(T) in
            guard let strongSelf = weakSelf,
                strongSelf.update(with: timeSinceStart, of: strongSelf.timeLimit),
                timeSinceStart < strongSelf.timeLimit else {
                    T.invalidate()
                    return
            }
            
            timeSinceStart = timeSinceStart + updateInterval
        })
    }
    
    func update(with timeSinceStart: TimeInterval, of total: TimeInterval) -> Bool {
        guard let messageLabel = self.messageLabel,
            let progressBar = self.progressBar else {
            return false
        }
        
        progressBar.progress = Float(timeSinceStart / timeLimit)
        let timeLeft = max(timeLimit - timeSinceStart, 0)
        messageLabel.text = String(format: "%.2f", timeLeft)
        
        return true
    }
    
    func showChoices(of options: [DrnkSpeeds]) {
        let alertController = UIAlertController(title: "Select your tolerance",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        for drnkSpeed in options {
            weak var weakSelf = self
            alertController.addAction(UIAlertAction(title: drnkSpeed.rawValue,
                                          style: .default,
                                          handler: { (action) -> Void in
                                            weakSelf?.timeLimit = timeLimits[drnkSpeed] ?? 10
                                            weakSelf?.startTimer(from: 1.0)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

