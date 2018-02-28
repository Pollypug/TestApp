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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let login = loginTextField.text
        let password = passwordTextField.text
        
        if ((login?.isEmpty)! || (password?.isEmpty)!) {
            displayAlert(message: "All fields required to be filled")
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        
        let baseUrl = URL(string: "https://apiecho.cf/api/login/")
        var request = URLRequest(url: baseUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postData = ["email" : loginTextField.text!,
                        "password" : passwordTextField.text!] as [String : String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayAlert(message: "Try again.")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error:Error?) in
            
            self.dismissActivityIndicator(activityIndicator: activityIndicator)
            
            if error != nil {
                self.displayAlert(message: "Could not perform this request1.")
                print("error = \(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJson = json {
                    if let userData = parseJson["data"] as? NSDictionary {
                        let accessToken = userData["access_token"] as? String
                        print(accessToken!)
                        if (accessToken?.isEmpty)! {
                        self.displayAlert(message: "Could not perform this request2.")
                        return
                    }
                        
                        let saveSuccessfuly: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                        
                    DispatchQueue.main.async {
                        let dataView = self.storyboard?.instantiateViewController(withIdentifier:
                            "DataViewController") as! DataViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = dataView
                    }
                    }
                    
                }
                else {
                    self.displayAlert(message: "Could not perform this request3.")
                }
            } catch {
                self.dismissActivityIndicator(activityIndicator: activityIndicator)
                self.displayAlert(message: "Could not perform this request4.")
                print(error)
            }
        }
        
        task.resume()
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
