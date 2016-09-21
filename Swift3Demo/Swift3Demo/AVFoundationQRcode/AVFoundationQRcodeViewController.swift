//
//  AVFoundationQRcodeViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/20.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit
import AVFoundation

class AVFoundationQRcodeViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var previewView:UIView!
    
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureSession:AVCaptureSession!
    var metadataOutput:AVCaptureMetadataOutput!
    var videoDevice:AVCaptureDevice!
    var videoInput: AVCaptureDeviceInput!
    var running = false
    var sendUrl:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        if captureSession == nil {
            let alert = UIAlertController(title: "Camera required", message: "This device has no camera. Is this an iOS Simulator?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: false, completion: nil)
        }
        else {
            previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(previewLayer)
            NotificationCenter.default.addObserver(self, selector: #selector(startRunning), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(stopRunning), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startRunning(){
        if captureSession == nil {
            return
        }
        
        captureSession.startRunning()
        metadataOutput.metadataObjectTypes =
            metadataOutput.availableMetadataObjectTypes
        running = true
    }
    func stopRunning(){
        captureSession.stopRunning()
        running = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopRunning()
    }
    
    func setupCaptureSession(){
        
        if(captureSession != nil){
            return
        }
        videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if(videoDevice == nil){
            print("No camera on this device")
            return
        }
        
        captureSession = AVCaptureSession()
        videoInput = (try! AVCaptureDeviceInput(device: videoDevice) as AVCaptureDeviceInput)
        
        if(captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        metadataOutput = AVCaptureMetadataOutput()
        let metadataQueue = DispatchQueue(label: "com.example.QRCode.metadata", attributes: [])
        metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
        
        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        let elemento = metadataObjects.first as?
        AVMetadataMachineReadableCodeObject
        if(elemento != nil){
            print(elemento!.stringValue)
            sendUrl = elemento!.stringValue
        }
    }
    

}
