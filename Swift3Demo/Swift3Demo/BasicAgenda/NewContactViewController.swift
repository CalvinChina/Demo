//
//  NewContactViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/30.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

protocol NewContactDelegate {
    func newContact(_ contact:Contact)
}

class NewContactViewController: UIViewController {
    @IBOutlet weak var NameTextField: UITextField!

    @IBOutlet weak var SubNameTextField: UITextField!
    
    @IBOutlet weak var PhoneTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    var delegate:NewContactDelegate?
    
    
    @IBAction func SaveBtnClicked(_ sender: AnyObject) {
        let contact = Contact()
        contact.name = NameTextField.text!
        contact.subName = SubNameTextField.text!
        contact.phone = PhoneTextField.text!
        contact.email = EmailTextField.text!
        
        delegate?.newContact(contact)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func CancelBtnClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
