//
//  SignUpTableViewController.swift
//  TestApp
//
//  Created by Polina on 2/26/18.
//  Copyright © 2018 Polina. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    // MARK: - Alert
    
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
    
    // MARK: - Activity Indicator
    
    func dismissActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

    // MARK: - Actions
    
    @IBAction func signupButton(_ sender: Any) {
        
        view.addSubview(self.activityIndicator)
        
        if (nameTextField.text?.isEmpty)! ||
            (loginTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! {
            
            displayAlert(message: "Fill all the fields!")
            return
        }
        
        let postData = ["name" : nameTextField.text!,
                        "email" : loginTextField.text!,
                        "password" : passwordTextField.text!] as [String : String]
        
        let user = APIClient()
        
        user.signup(postData: postData) { (message)  in
            self.dismissActivityIndicator(activityIndicator: self.activityIndicator)
            self.displayAlert(message: message)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }


}
