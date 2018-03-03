//
//  LoginTableViewController.swift
//  TestApp
//
//  Created by Polina on 2/26/18.
//  Copyright © 2018 Polina. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        view.addSubview(self.activityIndicator)
        
        let login = loginTextField.text
        let password = passwordTextField.text
        
        if ((login?.isEmpty)! || (password?.isEmpty)!) {
            displayAlert(message: "All fields required to be filled")
            return
        }
        
        let postData = ["email" : loginTextField.text!,
                        "password" : passwordTextField.text!] as [String : String]
        
        let user = APIClient()
        
        user.login(postData: postData) { (message, success) in
        self.dismissActivityIndicator(activityIndicator: self.activityIndicator)
            if success {
                DispatchQueue.main.async {
                    let dataView = self.storyboard?.instantiateViewController(withIdentifier:
                        "DataViewController") as! DataViewController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = dataView
                }
            } else {
                self.displayAlert(message: message)
            }
        }
       
    }
    func dismissActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
    }
    
    func displayAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
