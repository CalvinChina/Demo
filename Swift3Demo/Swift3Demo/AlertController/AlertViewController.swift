//
//  AlertViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ShowAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title:"你好",message:"你是最棒的",preferredStyle:UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title:"Cancel",style:.cancel){_ in
            print("this is so unbelivable!")
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title:"OK",style:.default){_ in
            print("点击了👌")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:{ () -> Void in
                        //your code here
                    })
    }
    
    
    @IBAction func ShowActionSheet(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle:UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })

    }
    
    
    @IBAction func AlertWithForm(_ sender: UIButton) {
        let alertController = UIAlertController(title:"123",message:"你是🐖么？",preferredStyle:.alert)
        let cancelAction = UIAlertAction(title:"不是",style:.cancel){_ in
            print("那你是🐶么")
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title:"你才是",style:.default){_ in
            
            print("you have pressed OK button");
            
            let userName = alertController.textFields![0].text
            let password = alertController.textFields![1].text
            
            self.doSomething(userName, password: password)
        }
        alertController.addAction(okAction)
        
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "userName"
            textField.isSecureTextEntry = false
        }
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
        }
        
        
        self.present(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
    }

    func doSomething(_ userName: String?, password: String?) {
        print("username: \(userName ?? "")  password: \(password ?? "")")
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
