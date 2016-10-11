//
//  URLViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/18.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class URLViewController: UIViewController ,UIWebViewDelegate{

    @IBOutlet weak var myURL: UITextField!
    
    @IBOutlet weak var webView2:UIWebView!
    
    @IBAction func send(sender:UIButton){
        let url:URL = URL(string:myURL.text!)!
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func load(sender:UIButton){
//        let requst = URLRequest(url:URL(string:myURL.text!)!)
//        self.webView2.loadRequest(requst)
        
       // nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle
        
        // 跳转AlerViewcontroller
//        let alertVC:AlertViewController = AlertViewController(nibName:"AlertViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(alertVC, animated: true)
        
        // 跳转AlerViewcontroller
//        let animate:AnimationsGesturesViewController = AnimationsGesturesViewController(nibName:"AnimationsGesturesViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(animate, animated: true)

        
//        let collVC:CollisionQuartzCoreViewController = CollisionQuartzCoreViewController(nibName:"CollisionQuartzCoreViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(collVC, animated: true)
        

//        let AVFVC:AVFoundationQRcodeViewController = AVFoundationQRcodeViewController(nibName:"AVFoundationQRcodeViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(AVFVC, animated: true)
        
//        let caleadarVC = CalendarViewController(nibName:"CalendarViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(caleadarVC, animated: true)
//        
//        let chatVC = ChatPeerToPeerViewController(nibName:"ChatPeerToPeerViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(chatVC, animated: true)

        
//        let chatVC = CheckConnectivityViewController(nibName:"CheckConnectivityViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(chatVC, animated: true)
        
//        let chatVC = CoreAnimation1ViewController(nibName:"CoreAnimation1ViewController",bundle:Bundle.main)
//        self.navigationController?.pushViewController(chatVC, animated: true)
        
        let coreVc = CoreDataSampleViewController(nibName:"CoreDataSampleViewController",bundle:Bundle.main)
        self.navigationController?.pushViewController(coreVc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView2.delegate = self
        
        //1. Load web site into my web view
        
        let myURL = URL(string: "http://www.swiftdeveloperblog.com");
        let myURLRequest:URLRequest = URLRequest(url: myURL!);
        webView2.loadRequest(myURLRequest);
        
        
        
        
        //        // Do any additional setup after loading the view, typically from a nib.
        //        let url = NSURL (string: "http://www.google.com");
        //        let request = NSURLRequest(URL: url!);
        //        webView2.loadRequest(request);
        
        //        myURL.text = "http://carlosbutron.es/"
        //        webView2.delegate = self
        //        let request = NSURLRequest(URL: NSURL(string: myURL.text!)!)
        //        self.webView2.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
        
        
        return true
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
