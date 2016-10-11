//
//  CheckConnectivityViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/8.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class CheckConnectivityViewController: UIViewController {
    
    @IBOutlet weak var checkingLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        checkConnectivity()
    }
    
    func checkConnectivity(){
        print(Reachability.isConnectedToNetwork(),terminator:"")
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(title: "Alert", message: "Internet is not working", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: false, completion: nil)
            let okAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
                UIAlertAction in
                alert.dismiss(animated: false, completion: nil)
                self.checkConnectivity()
            }
            alert.addAction(okAction)
            checkingLabel.text = "UnConnected"
        }else {
            checkingLabel.text = "Connected"
        }
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
