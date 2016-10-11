//
//  CoreAnimation1ViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/9.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class CoreAnimation1ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var original = true
    
    @IBAction func animate(_ sender: AnyObject) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint:CGPoint(x: imageView.frame.midX, y: imageView.frame.midY))
        animation.toValue = NSValue(cgPoint:CGPoint(x: imageView.frame.midX, y: 340))
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = 1.0
        imageView.layer.add(animation, forKey: "position")
    }
    
    
    // 形变
    @IBAction func animate2(_ sender: AnyObject) {
        
        if original {
            let animation = CABasicAnimation(keyPath:"position")
            animation.toValue = NSValue(cgPoint:CGPoint(x:160,y:200))
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            
            let resizeAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.toValue = NSValue(cgSize:CGSize(width:240,height:60))
            resizeAnimation.fillMode = kCAFillModeForwards
            resizeAnimation.isRemovedOnCompletion = false
            
            imageView.layer.add(animation, forKey: "position")
            imageView.layer.add(resizeAnimation, forKey:"bounds.size")

            original = false
        }else{
        
            let animation:CABasicAnimation! = CABasicAnimation(keyPath:"position")
            animation.fromValue = NSValue(cgPoint:CGPoint(x: 160, y: 200))
            
            //EXAMPLE2
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            let resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.fromValue = NSValue(cgSize:CGSize(width: 240, height: 60))
            
            //EXAMPLE2
            resizeAnimation.fillMode = kCAFillModeForwards
            resizeAnimation.isRemovedOnCompletion = false
            imageView.layer.add(animation, forKey: "position")
            imageView.layer.add(resizeAnimation, forKey: "bounds.size")
            
            original = true
        }
    }
    
    var original2 = true
    
    @IBAction func animation3(_ sender: AnyObject) {
        if original2 {
            
            let animation:CABasicAnimation! = CABasicAnimation(keyPath:"position")
            animation.toValue = NSValue(cgPoint:CGPoint(x: 160, y: 200))
            
            //SAMPLE2
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            let resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.toValue = NSValue(cgSize:CGSize(width: 240, height: 60))
            
            //SAMPLE2
            resizeAnimation.fillMode = kCAFillModeForwards
            resizeAnimation.isRemovedOnCompletion = false
            
            UIView.animate(withDuration: 5.0, animations: {
                self.imageView.alpha = 0.0
            }) { (value:Bool) in
                self.imageView.alpha = 1.0
                self.imageView.layer.add(animation, forKey: "position")
                self.imageView.layer.add(resizeAnimation, forKey: "bounds.size")
            }
            original2 = false
            
        }else{
            let animation:CABasicAnimation! = CABasicAnimation(keyPath:"position")
            animation.fromValue = NSValue(cgPoint:CGPoint(x: 160, y: 200))
            
            //SAMPLE2
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            let resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.fromValue = NSValue(cgSize:CGSize(width: 240, height: 60))
            
            //SAMPLE2
            resizeAnimation.fillMode = kCAFillModeForwards
            resizeAnimation.isRemovedOnCompletion = false
            imageView.layer.add(animation, forKey: "position")
            imageView.layer.add(resizeAnimation, forKey: "bounds.size")
            
            original2 = true
        }
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
