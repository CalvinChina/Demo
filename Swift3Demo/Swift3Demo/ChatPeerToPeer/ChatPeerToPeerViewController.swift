//
//  ChatPeerToPeerViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/8.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit
import MultipeerConnectivity

// 多点连接 http://blog.csdn.net/phunxm/article/details/43450167

class ChatPeerToPeerViewController: UIViewController,MCSessionDelegate,MCBrowserViewControllerDelegate,UITextFieldDelegate{
    
    var browserVC:MCBrowserViewController!
    var advertiserAssistant:MCAdvertiserAssistant!
    var session:MCSession!
    var peerID:MCPeerID!
    
    @IBAction func button(_ sender:UIButton){
        showBrowserVC()
    }
    
    @IBOutlet weak var textBox:UITextView!
    @IBOutlet weak var sendText:UITextField!
    
    
    
    
    func showBrowserVC(){
        self.present(self.browserVC, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMultipeer()
        // Do any additional setup after loading the view.
    }
    
    func setUpMultipeer(){
        peerID = MCPeerID(displayName:UIDevice.current.name)
        session = MCSession(peer:peerID)
        session.delegate = self
        browserVC = MCBrowserViewController(serviceType:"chat",session:session)
        browserVC.delegate = self
        advertiserAssistant = MCAdvertiserAssistant(serviceType:"chat",discoveryInfo:nil,session:session)
        advertiserAssistant.start()
    }
    
    func sendMessage(){
        let message:NSString = self.sendText.text! as NSString
        self.sendText.text = ""
        let data:Data = message.data(using: String.Encoding.utf8.rawValue)!
        var error:NSError?
        do{
            try self.session.send(data, toPeers: self.session.connectedPeers, with:.unreliable)
        }
        catch let error1 as NSError{
            error = error1
        }
        print(error!)
        self.messageReception(message,peer:self.peerID)
    }
    
    func messageReception(_ message:NSString,peer:MCPeerID){
        var finalText:NSString
        if (peer == self.peerID) {
            finalText = "\nYo:\(message)"as NSString
        }else{
            finalText = "\n\(peer.displayName):\(message)" as NSString
        }
        self.textBox.text = self.textBox.text + (finalText as String)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendMessage()
        return true
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState){
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        DispatchQueue.main.async(execute: {self.messageReception(message!, peer: peerID)})
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID:MCPeerID){
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?){
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController){
        self.dismissBrowserVC()
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController){
        self.dismissBrowserVC()
    }
    

    func dismissBrowserVC(){
        self.browserVC.dismiss(animated: true, completion: nil) }
    
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
