//
//  ImageViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class ImageViewController: UIViewController , UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var allInPicture:UIImageView!
    
    @IBAction func senderClicked(sender: UIButton){
        let tempImage:UIImage = allInPicture.image!
        let controller = UIActivityViewController(activityItems:[tempImage] ,applicationActivities:nil)
    
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func album(sender:UIButton){
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.present(pickerC, animated: true, completion: nil)
    }
    
    @IBAction func userCamera(sender:UIButton){
        let pickerCamera = UIImagePickerController()
        pickerCamera.delegate = self
        pickerCamera.sourceType = UIImagePickerControllerSourceType.camera
        pickerCamera.mediaTypes = [kUTTypeImage as String]
        pickerCamera.showsCameraControls = true
        
        self.present(pickerCamera, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        allInPicture.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func image(image:UIImage , didFinishSvaingWithError error:NSErrorPointer?,contextInfo:UnsafeRawPointer){
        if(error != nil){
            print("ERROR IMAGE\(error.debugDescription)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
}
