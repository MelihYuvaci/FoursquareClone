//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Melih Yuvacı on 24.04.2022.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        
    }

    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != ""{
            
            let user = PFUser()
            user.username=userNameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { success, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", meessageInput: error?.localizedDescription ?? "Error!")
                }else{
                    // Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(titleInput: "Error", meessageInput: "Username / Password")
        }
        
    }
    @IBAction func signInClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != ""{
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", meessageInput: error?.localizedDescription ?? "Error")
                }else{
                    //Segue
                   
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
        }else{
            makeAlert(titleInput: "Error", meessageInput: "Username / Password??")
        }
    }
    func makeAlert(titleInput:String,meessageInput:String){
        let alert = UIAlertController(title: titleInput, message: meessageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }

}

