//
//  CollisionQuartzCoreViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/19.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class CollisionQuartzCoreViewController: UIViewController,UICollisionBehaviorDelegate {

    @IBOutlet weak var gravity: UIButton!
    @IBOutlet weak var push: UIButton!
    @IBOutlet weak var attachment: UIButton!

    var collision:UICollisionBehavior!
    
    var animator = UIDynamicAnimator()
    
    var attachmentBehavior: UIAttachmentBehavior? = nil
    
    @IBAction func gravityClick(_ sender :UIButton){
        animator.removeAllBehaviors()
        let gravity_t = UIGravityBehavior(items:[self.gravity,self.push,self.attachment])
        animator.addBehavior(gravity_t)
        collision = UICollisionBehavior(items:[self.gravity ,self.push,self.attachment])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    @IBAction func push(_ sender:AnyObject){
        animator.removeAllBehaviors()
        let push_t = UIPushBehavior(items:[self.gravity,self.push,self.attachment], mode:.instantaneous)
        push_t.magnitude = 2
        animator.addBehavior(push_t)
        collision = UICollisionBehavior(items:[self.gravity ,self.push,self.attachment])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    
    @IBAction func attachment(_ sender:AnyObject){
        animator.removeAllBehaviors()
        let anchorPoint = CGPoint(x:self.attachment.center.x ,y:self.attachment.center.y)
        attachmentBehavior = UIAttachmentBehavior(item:self.attachment ,attachedToAnchor:anchorPoint)
        attachmentBehavior!.frequency = 0.5
        attachmentBehavior!.damping = 2
        attachmentBehavior!.length = 20
        animator.addBehavior(attachmentBehavior!)
        collision = UICollisionBehavior(items:[self.gravity ,self.push,self.attachment])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    @IBAction func handleAttachment(_ sender: UIPanGestureRecognizer) {
        if((attachmentBehavior) != nil){
            attachmentBehavior!.anchorPoint = sender.location(in: self.view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: self.view)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let max: CGRect = UIScreen.main.bounds
        let snap1 = UISnapBehavior(item: self.gravity, snapTo: CGPoint(x: max.size.width/2, y: max.size.height/2 - 50))
        let snap2 = UISnapBehavior(item: self.push, snapTo: CGPoint(x: max.size.width/2, y: max.size.height/2 ))
        let snap3 = UISnapBehavior(item: self.attachment, snapTo: CGPoint(x: max.size.width/2, y: max.size.height/2 + 50))
        snap1.damping = 1
        snap2.damping = 2
        snap3.damping = 4
        animator.addBehavior(snap1)
        animator.addBehavior(snap2)
        animator.addBehavior(snap3)
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
