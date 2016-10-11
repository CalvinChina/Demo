//
//  CollectionViewViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/9.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class CollectionViewViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    let identifier:String = "CollectionCell"
    

     var items : NSArray = [UIImage(named:"image1.jpg")!,UIImage(named:"image2.jpg")!,UIImage(named:"image3.jpg")!,UIImage(named:"image4.jpg")!,UIImage(named:"image5.jpg")!,UIImage(named:"image6.jpg")!,UIImage(named:"image7.jpg")!,UIImage(named:"image8.jpg")!,UIImage(named:"image9.jpg")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
       // var img:UIImage? = UIImage(named:"image1")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = items.object(at: (indexPath as NSIndexPath).row%9) as? UIImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count * 5
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
