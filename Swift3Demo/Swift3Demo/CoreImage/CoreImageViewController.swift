//
//  CoreImageViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/11.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit
import CoreImage

class CoreImageViewController: UIViewController {

    var sliderValue: Float = 0.0
    
      @IBOutlet weak var myImage: UIImageView!
    
    @IBAction func SepiaBtn(_ sender: AnyObject) {
        applyfilter(1)
    }
    
 
    @IBAction func Vignette(_ sender: AnyObject) {
        applyfilter(2)
    }
    
    
    @IBAction func invert(_ sender: UIButton) {
        applyfilter(3)
    }
    
    @IBAction func photo(_ sender: UIButton) {
        applyfilter(4)
    }
    
    @IBAction func perspective(_ sender: UIButton) {
        applyfilter(5)
    }
    
    @IBAction func gaussian(_ sender: UIButton) {
        applyfilter(6)
    }
    
    @IBAction func slider(_ sender: UISlider) {
        sliderValue = sender.value
    }
    
    func applyfilter(_ numberFilter: Int) {
        
        let filePath : String = Bundle.main.path(forResource: "imageCore", ofType: "jpg")!
        let fileUrl : URL = URL (fileURLWithPath: filePath as String)
        let inputImage : CIImage = CIImage (contentsOf: fileUrl)!
        
        switch numberFilter {
        case 1:
            let filter = CIFilter(name: "CISepiaTone")
            //var filter : CIFilter = CIFilter (name: "CISepiaTone")
            filter!.setValue(inputImage, forKey: kCIInputImageKey)
            filter!.setValue(sliderValue, forKey: "InputIntensity")
            let outputImage : CIImage = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let img : UIImage = UIImage (ciImage: outputImage)
            myImage.image = img
        case 2:
            let filter : CIFilter = CIFilter (name: "CIVignette")!
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(sliderValue, forKey: "InputRadius")
            filter.setValue(sliderValue, forKey: "InputIntensity")
            let outputImage : CIImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
            let img : UIImage = UIImage (ciImage: outputImage)
            myImage.image = img
        case 3:
            let filter : CIFilter = CIFilter (name: "CIColorInvert")!
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            let outputImage : CIImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
            let img : UIImage = UIImage (ciImage: outputImage)
            myImage.image = img
        case 4:
            let filter : CIFilter = CIFilter (name: "CIPhotoEffectMono")!
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            let outputImage : CIImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
            let img : UIImage = UIImage (ciImage: outputImage)
            myImage.image = img
        case 5:
            let filter : CIFilter = CIFilter (name: "CIPerspectiveTransform")!
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            let outputImage : CIImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
            let img : UIImage = UIImage (ciImage: outputImage)
            myImage.image = img
        case 6:
            let filter : CIFilter = CIFilter (name: "CIGaussianBlur")!
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            let outputImage : CIImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
            let img : UIImage = UIImage (ciImage: outputImage)
            myImage.image = img
        default:
            print("test")
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
