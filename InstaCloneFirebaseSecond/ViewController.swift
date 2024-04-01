//
//  ViewController.swift
//  InstaCloneFirebaseSecond
//
//  Created by Islam Rzayev on 12.03.24.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        if(emailText.text != "" && passwordText.text != ""){
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if(error != nil){
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedCell", sender: nil)
                }
            }
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if (emailText.text != "" && passwordText.text != ""){
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error)in
                
                if(error != nil){
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedCell", sender: nil)
                }
            }
        }else{
           makeAlert(titleInput: "Error", messageInput: "Username or Password is incorrect")
        }
    }
    
    
    
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    
}

