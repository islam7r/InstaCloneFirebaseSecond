//
//  SettingsViewController.swift
//  InstaCloneFirebaseSecond
//
//  Created by Islam Rzayev on 12.03.24.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toMainVC", sender: nil)
        } catch{
            print("error")
        }
        
    }
    
}
