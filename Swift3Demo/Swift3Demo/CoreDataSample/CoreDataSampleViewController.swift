//
//  CoreDataSampleViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/10.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit
import CoreData

class CoreDataSampleViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var listView: UITableView!
    
    var result :NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context : NSManagedObjectContext = appDel.managedObjectContext
        // inert
        let celda = NSEntityDescription.insertNewObject(forEntityName: "Cell", into:  context)
        celda.setValue("Yoda Tux", forKey: "title")
        celda.setValue("Science Fiction", forKey: "subtitle")
        celda.setValue("yodaTux.png", forKey: "image")
        do {
            try context.save()
        } catch  {
            print("Error！")
        }
        
       // ResultType
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cell")
        request.returnsObjectsAsFaults = false
        result = try! context.fetch(request) as NSArray?
        if result!.count > 0 {
            for res in result! {
                print(res)
            }
        }
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle,reuseIdentifier:nil)
        let aux = result![(indexPath as NSIndexPath).row] as! NSManagedObject
        cell.textLabel!.text = aux.value(forKey: "title") as? String
        cell.detailTextLabel!.text = aux.value(forKey: "subtitle") as? String
        cell.imageView!.image = UIImage(named:aux.value(forKey: "image")as!String)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)-> String?  {
        return "TuxMania"
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
