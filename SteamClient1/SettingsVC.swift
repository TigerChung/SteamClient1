//
//  SettingsVC.swift
//  SteamClient1
//
//  Created by opto on 2018/4/14.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit


class SettingsVC: UIViewController {
    
    
    
    @IBOutlet weak var ipHost: UITextField!
    
    @IBOutlet weak var ipPort: UITextField!
    @IBOutlet weak var myText: UITextField!
    
    @IBOutlet weak var setSpuIdLabel: UILabel!
    @IBOutlet weak var setSpuIdStepper: UIStepper!
    @IBOutlet weak var spuIdLabel: UILabel!
    @IBOutlet weak var getSPUIDValue: UILabel!
    @IBOutlet weak var getSPUIDStepper: UIStepper!
    
    
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var NetworkConnectButton: UIButton!
    @IBOutlet weak var LogTextView: UITextView!
    
    
   // let spuMain = SpuMainClass()
    /*
    // 將　 iStream, oStream 宣告為global變數
    //var spuStream = Stream()
    var iStream: InputStream? = nil
    var oStream: OutputStream? = nil
     */
    
    var myNetworkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (myNetworkReachabilityManager?.isReachable) != false {
          isNetworkReachable =  true
         /*
          let _ = Stream.getStreamsToHost(withName: self.ipHost.text!, port: Int(self.ipPort.text!)!, inputStream: &(self.iStream), outputStream: &(self.oStream) )
          self.iStream?.open()
          self.oStream?.open()
        */
        }
        guard let ip = ipHost.text, let port = Int(ipPort.text!) else {
            print("Ip or port value is wrong")
            return
            
        }
        hostIp = ip
        hostPort = port
        spuMain.spuID = Int(setSpuIdStepper.value)
        setSpuIdLabel.text = "\(spuMain.spuID)"
        spuMain.getCmdSpuID = Int(getSPUIDStepper.value)
        getSPUIDValue.text = "\(spuMain.getCmdSpuID)"
        checkGetCommandSpuIdLabel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //connect(&(self.iStream), &(self.oStream))
        setNetworkConnectionButtonEnabled(enabled: isNetworkReachable)
    }
    
    func setNetworkConnectionButtonEnabled(enabled: Bool)-> Void {
        NetworkConnectButton.isEnabled = enabled
        disconnectButton.isEnabled = !enabled
        
    }
    
    func checkGetCommandSpuIdLabel() {
        if spuMain.spuID != 0 {
            spuIdLabel.isHidden = true
            getSPUIDValue.isHidden = true
            getSPUIDStepper.isHidden = true
        }
        else {
            spuIdLabel.isHidden = false
            getSPUIDValue.isHidden = false
            getSPUIDStepper.isHidden = false
            
        }
        
    }
    
    @IBAction func disconnectClick(_ sender: UIButton) {
        spuMain.close()
        setNetworkConnectionButtonEnabled(enabled: isNetworkReachable)
    }
    
    @IBAction func connectClick(_ sender: Any) {
        
        print("Ip or port value is ok")
        spuMain.connect(ipServer: hostIp, portServer: hostPort)
        /*
        DispatchQueue.global().async {
            self.receiveData(available: { (string,cnt) in
                //let data = Data(bytes: string, count: cnt)
                //let data = UnsafeMutablePointer<UInt8>.allocate(capacity: cnt)
                //var data = Array(repeating: UInt8(0), count: cnt)
                let data = string.dropLast(string.count - cnt)
                
                self.responseCount += 1
                
                DispatchQueue.main.async {
                    self.myLabel.text = String("Response No: " + "\(self.responseCount)")
                    self.LogTextView.text.append("Response: \(data)" + "\n")
                }
                if cnt <= 0 {
                    self.spuMain.close()
                }
                //data.deallocate()
                
            })
        }
 */
        setNetworkConnectionButtonEnabled(enabled: !isNetworkReachable)
        //connect(&(self.iStream), &(self.oStream))
        //spuMain.connectToServer(ipServer: self.ipHost.text!, portServer: Int(self.ipPort.text!)!)
        //NetworkConnectButton.isEnabled = false
        /*
        let _ = Stream.getStreamsToHost(withName: ipHost.text!, port: Int(ipPort.text!)!, inputStream: &iStream, outputStream: &oStream )
        iStream?.open()
        oStream?.open()
        */
        /*
        DispatchQueue.global().async {
            self.receiveData(available: { (string) in
                DispatchQueue.main.async {
                    self.myLabel.text = string
                }
            })
        }
        */
    }
    
    
    
    
    /*
    func connect(_ inStream: inout InputStream?, _ outStream: inout OutputStream?){
        let _ = Stream.getStreamsToHost(withName: self.ipHost.text!, port: Int(self.ipPort.text!)!, inputStream: &inStream, outputStream: &outStream )
        inStream?.open()
        outStream?.open()
        
        
    }
 */
    
    
    @IBAction func sendClick(_ sender: Any) {
        if spuMain.isConnected == false {
           NetworkConnectButton.isEnabled = true
        }
        if let text = myText.text {
            spuMain.send(text)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSpuIdStepper(_ sender: Any) {
        spuMain.spuID = Int(setSpuIdStepper.value)
        setSpuIdLabel.text = "\(spuMain.spuID)"
        checkGetCommandSpuIdLabel()
    }
    
    @IBAction func changeGetSpuIdStepper(_ sender: Any) {
        spuMain.getCmdSpuID = Int(getSPUIDStepper.value)
        getSPUIDValue.text = "\(spuMain.getCmdSpuID)"
    }
    
}


