//
//  LoginViewController.swift
//  Parse Chat
//
//  Created by Akbar Mirza on 2/22/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var LogInButton: UIButton!
    
    // Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        signUp()
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        logIn()
    }
    
    func signUp() {
        // initialize PFUser
        let user = PFUser()
        
        // initialize username and password fields
        user.username = emailField.text!
        user.password = passwordField.text!
        
        user.signUpInBackground { (didSucceed: Bool, error: Error?) in
            // if there was no error
            if (error == nil) {
                // Hooray! Let them use the app now.
                
                print("SUCCESS: \(user.username) signed up!")
                
                let myAlert = self.createAlert(title: "Success!", message: "You can now log-in with those credentials")
                
            } else {
                
                let errorString = error?.localizedDescription
                
                // show the errorString somewhere and let the user try again
                let myAlert = self.createAlert(title: "Error", message: errorString!)
                
                self.present(myAlert, animated: true) {
                    
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
        }
        
    }
    
    func logIn() {
        
        // get username and password data
        let username = emailField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if (user != nil) {
                
                print("SUCCESS: \(username) logged in!")
                
                // do stuff after successful login
                self.performSegue(withIdentifier: "onSuccessfulLogin", sender: nil)
                
            } else {
                
                let errorString = error?.localizedDescription
                
                // show the errorString somewhere and let the user try again
                let myAlert = self.createAlert(title: "Error", message: errorString!)
                
                self.present(myAlert, animated: true) {
                    
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
        }
        
    }
    
    // creates an alertController and returns it
    func createAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            // handle cancel response here
            // doing nothing will dismiss the view
        }
        
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            // handle response here
            
        }
        
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        return alertController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
