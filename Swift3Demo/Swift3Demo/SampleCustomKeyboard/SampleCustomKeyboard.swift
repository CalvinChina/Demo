//
//  SampleCustomKeyboard.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/12.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class SampleCustomKeyboard: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    func centerButton(_: AnyObject){
        let text = "🐩"
        let proxy = self.textDocumentProxy as UIKeyInput
        proxy.insertText(text)
    }
    
    func pushButton(_ :AnyObject){
        let launch = ":-)))))))))"
        let proxy = self.textDocumentProxy as UIKeyInput
        proxy.insertText(launch)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewXib = UINib(nibName:"SampleCustomKeyboard",bundle:nil)
        self.view = viewXib.instantiate(withOwner: self, options: nil)[0] as!UIView
        for tempView  in self.view.subviews {
            if tempView .isKind(of: UIButton.self){
                let w = tempView as! UIButton
                if w.currentTitle == "Center"{
                    w.addTarget(self, action:#selector(centerButton(_:)), for: .touchUpInside)
                }else{
                    w.addTarget(self, action:#selector(pushButton(_:)), for: .touchUpInside)
                }
            }
        }
        print("NSLog can't be seen in xcode console. See README")
        
        self.nextKeyboardButton = UIButton(type:.system)
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard?", comment: "Title for 'Next Keyboard' button"), for: UIControlState())
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])

        // Do any additional setup after loading the view.
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: UIControlState())
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
