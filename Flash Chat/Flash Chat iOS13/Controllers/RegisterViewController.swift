//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController
{

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            Auth.auth().createUser(withEmail: email, password: password)
            { authResult, error in
                if let e = error
                {
                    self.showError(error : e as NSError)
                }
                
                else
                {
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
    func showError(error : NSError)
    {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: K.registrationPUID) as! RegistrationPUViewController
        popoverVC.warning = error.localizedDescription
        self.addChild(popoverVC)
        popoverVC.view.frame = self.view.frame
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParent: self)
    }
    
}
