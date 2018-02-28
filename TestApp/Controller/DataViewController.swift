//
//  DataViewController.swift
//  TestApp
//
//  Created by Polina on 2/26/18.
//  Copyright © 2018 Polina. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class DataViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fetchTextButton(_ sender: Any) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        
        let baseUrl = URL(string: "http://netua.ru/handlers/test.php")
        var request = URLRequest(url: baseUrl!)
        request.httpMethod = "GET"
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error:Error?) in
            
            if error != nil {
                self.displayAlert(message: "Could not perform this request1.")
                print("error = \(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJson = json {
                    
                    DispatchQueue.main.async {
                        let msg: String? = parseJson["data"] as? String
                        print(msg!)
                    }
                    
                } else {
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
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        
        let baseUrl = URL(string: "https://apiecho.cf/api/logout/")
        var request = URLRequest(url: baseUrl!)
        request.httpMethod = "POST"
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        request.addValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error:Error?) in
            
            //self.dismissActivityIndicator(activityIndicator: activityIndicator)
            
            if error != nil {
                self.displayAlert(message: "Could not perform this request1.")
                print("error = \(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJson = json {
                    let result = parseJson["success"] as? Bool
                    let dataString = parseJson["data"] as? String
                    if result! {
                        print("logout")
                        print(dataString!)
                        KeychainWrapper.standard.removeObject(forKey: "accessToken")
                        
                        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginTableViewController") as! LoginTableViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = loginView
                    } else {
                        self.displayAlert(message: "Cannot log out. Try later.")
                    }
                    
                    DispatchQueue.main.async {
                        let dataView = self.storyboard?.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = dataView
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

extension DataViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        
        return cell
    }
}

