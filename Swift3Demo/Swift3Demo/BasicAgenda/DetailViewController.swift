//
//  DetailViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/30.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var SubName: UILabel!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    
    @IBOutlet weak var EmailLabel: UILabel!
    
    var contact = Contact()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NameLabel.text = contact.name
        SubName.text = contact.subName
        PhoneLabel.text = contact.phone
        EmailLabel.text = contact.email
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
