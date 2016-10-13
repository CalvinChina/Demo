//
//  KeyboardTestViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/12.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class KeyboardTestViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var testTF: UITextField!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTF.delegate = self
        


    

        // Do any additional setup after loading the view.
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        self.present(SKeyboard, animated: true) {
//            
//        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        SKeyboard.dismiss(animated: true , completion: nil)
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
