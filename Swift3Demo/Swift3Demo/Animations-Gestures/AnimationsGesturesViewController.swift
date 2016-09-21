//
//  AnimationsGesturesViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class AnimationsGesturesViewController: UIViewController {
    
    @IBOutlet weak var loadImage: UIImageView!

    var frames:NSArray?
    var dieCenter:CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image1 = UIImage(named:"penguin_walk01")!
        let image2 = UIImage(named:"penguin_walk02")!
        let image3 = UIImage(named:"penguin_walk03")!
        let image4 = UIImage(named:"penguin_walk04")!
        
        let frames:[UIImage] = [image1,image2,image3,image4]
        loadImage.animationDuration = 0.15
        loadImage.animationRepeatCount = 2
        loadImage.animationImages = frames
        
        let swipeGestureRight = UISwipeGestureRecognizer(target:self ,action:#selector(walkRight(_:)))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action:#selector(walkLeft(_:)))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeGestureLeft)
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(jump(_:)))
        view.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target:self, action:#selector(longPre(_:)))
        view.addGestureRecognizer(longPress)
        
        // Do any additional setup after loading the view.
    }
    
    func walkLeft(_ swipe:UIGestureRecognizer){
        
        if loadImage.center.x > view.frame.size.width {
            loadImage.center = CGPoint(x:0 ,y:loadImage.center.y)
        }
        loadImage.transform = CGAffineTransform.identity
        loadImage.startAnimating()
        // 在闭包中需要加self.
        UIView.animate(withDuration: 0.6) {_ in
            self.loadImage.center = CGPoint(x:self.loadImage.center.x + 30 ,y:self.loadImage.center.y)
        }
        
    }
    
    func walkRight(_ swipe:UIGestureRecognizer){
        if loadImage.center.x < 0.0 {
            loadImage.center = CGPoint(x:view.frame.size.width ,y:loadImage.center.y)
        }
        // 左右颠倒
        loadImage.transform = CGAffineTransform(scaleX: -1.0 ,y: 1.0)
        loadImage.startAnimating()
        // 在闭包中需要加self.
        UIView.animate(withDuration: 0.6) {_ in
            self.loadImage.center = CGPoint(x:self.loadImage.center.x - 30 ,y:self.loadImage.center.y)
        }
    }
    func jump(_ tap:UIGestureRecognizer){
        loadImage.startAnimating()
        UIView.animate(withDuration: 0.25, animations: {_ in
            self.loadImage.center = CGPoint(x:self.loadImage.center.x,y:self.loadImage.center.y - 50)
            }) { (true) in
            self.jumpBack()
        }
    }
    
    private func jumpBack(){
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.loadImage.center = CGPoint(x: self.loadImage.center.x, y: self.loadImage.center.y + 50)
        })
    }
    
    func longPre(_ send: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.33, animations: { () -> Void in
            self.dieCenter = self.loadImage.center
            self.loadImage.center = CGPoint(x: self.loadImage.center.x, y: self.view.frame.size.height)
            }, completion: { (finished: Bool) -> Void in
                self.longPressBack()
        })
    }
    
    func longPressBack() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.loadImage.center = self.dieCenter!
        })
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
