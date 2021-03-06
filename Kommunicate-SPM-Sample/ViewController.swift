//
//  ViewController.swift
//  trialSPM
//
//  Created by k on 05/04/21.
//

import UIKit
import ApplozicCore
import ApplozicSwift
import Kommunicate

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        Kommunicate.logoutUser { (result) in
            switch result {
            case .success(_):
                self.activityIndicator.startAnimating()
                print("Logout success")
                self.dismiss(animated: true, completion: nil)
            case .failure( _):
                self.activityIndicator.startAnimating()
                print("Logout failure, now registering remote notifications(if not registered)")
                if !UIApplication.shared.isRegisteredForRemoteNotifications {
                    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                        if granted {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func launchConversation(_ sender: Any) {
        activityIndicator.startAnimating()
        Kommunicate.createAndShowConversation(from: self, completion: {
            error in
            self.view.isUserInteractionEnabled = true
            if error != nil {
                self.activityIndicator.stopAnimating()
                print("Error while launching")
            } else {
                self.activityIndicator.stopAnimating()
            }
        })
    }
}
