//
//  LoginPUViewController.swift
//  Flash Chat iOS13
//
//  Created by Dylan Kuster on 5/2/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class LoginPUViewController: UIViewController
{
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var errorView: UIView!
    
    var error : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        errorView.layer.cornerRadius = 20
        showAnimate()
        updateErrorLabel(Error: error!)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25)
        {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton)
    {
        removeAnimate()
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations:
        {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        })
        { (finished) in
            if finished
            {
                self.view.removeFromSuperview()
            }
        }
    }
    
    func updateErrorLabel(Error : String)
    {
        errorLabel.text = Error
    }
    
}
