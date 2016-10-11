//
//  TableListViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/30.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class TableListViewController: UITableViewController,NewContactDelegate{

    var contactArray = Array<Contact>()

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...50{
            let contact = Contact()
            contact .name = "Name\(i)"
            contact.subName = "SubName\(i)"
            contact.phone = "Phone\(i)"
            contact.email = "Email\(i)"
            contactArray.append(contact)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        let contact = contactArray[(indexPath as NSIndexPath).row]
        
        cell.textLabel!.text = contact.name + "" + contact.subName
        cell.tag = indexPath.row
        print("Cellnumber:\(indexPath.row)")
        
        return cell
    }
    
    
    internal func newContact(_ contact: Contact) {
        contactArray.append(contact)
        tableView.reloadData()
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
