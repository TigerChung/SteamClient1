//
//  ViewController.swift
//  SteamClient1
//
//  Created by opto on 2018/4/14.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var ipHost: UITextField!
    
    @IBOutlet weak var ipPort: UITextField!
    @IBOutlet weak var myText: UITextField!
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var NetworkConnectButton: UIButton!
    @IBOutlet weak var LogTextView: UITextView!
    // 將　 iStream, oStream 宣告為global變數
    //var spuStream = Stream()
    var iStream: InputStream? = nil
    var oStream: OutputStream? = nil
    var responseCount: Int = 0
    var myNetworkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (myNetworkReachabilityManager?.isReachable) != false {
          isNetworkReachable =  true
          let _ = Stream.getStreamsToHost(withName: self.ipHost.text!, port: Int(self.ipPort.text!)!, inputStream: &(self.iStream), outputStream: &(self.oStream) )
          self.iStream?.open()
          self.oStream?.open()
        
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
                //data.deallocate()
                
            })
          }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //connect(&(self.iStream), &(self.oStream))
        setNetworkConnectionButtonEnabled(enabled: !isNetworkReachable)
    }
    
    func setNetworkConnectionButtonEnabled(enabled: Bool)-> Void {
        NetworkConnectButton.isEnabled = enabled
        
    }
    
    @IBAction func connectClick(_ sender: Any) {
        //connect(&(self.iStream), &(self.oStream))
        let _ = Stream.getStreamsToHost(withName: ipHost.text!, port: Int(ipPort.text!)!, inputStream: &iStream, outputStream: &oStream )
        iStream?.open()
        oStream?.open()
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
    
    @IBAction func getWiFiVersion(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
       /*
        buf.append(0x01) // Start Code
        buf[1]=101  // Group ID
        buf[2]=0    // Command ID
        buf[3]=0    // Data Length = 2 bytes
        buf[4]=1
        buf[5]=1    //Data: Spu id
        */
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0xd2)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x00)
   //     buf.append(0x01)   //Data: Spu id
        for i in 1...4 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        //let data = NSData(bytes: buf, length: buf.count)
        //LogTextView.text = LogTextView.text! + String("\(data)") + String(":Get WiFi Server version\n")
        LogTextView.text.append(":Get WiFi Server version\n")
        print("\(buf)")
        sendBytes(buf, 8)
        
    }
    
    
    func connect(_ inStream: inout InputStream?, _ outStream: inout OutputStream?){
        let _ = Stream.getStreamsToHost(withName: self.ipHost.text!, port: Int(self.ipPort.text!)!, inputStream: &inStream, outputStream: &outStream )
        inStream?.open()
        outStream?.open()
        
        
    }
    func receiveData(available: (_ string: [UInt8],_ cnt: Int) -> Void ){
        var buf = Array(repeating: UInt8(0), count: 1024)
        if iStream == nil {
            return
            
        }
        while true {
            if let n = iStream?.read(&buf, maxLength: 1024)  {
                if n > 0 && n <= 1024 {
                  //let data = Data(bytes: buf, count: n)
                    //let string = String(data: data, encoding: .ascii)
                    available(buf,n)
                }
            }
        }
    }
    
    func send(_ string: String){
        var buf = Array(repeating: UInt8(0), count: 1024)
        let data = string.data(using: .utf8 )!
        
        data.copyBytes(to: &buf, count: data.count )
        oStream?.write(buf, maxLength: data.count)
        
    }
    
    func sendBytes(_ cmdBytes: [UInt8], _ cnt: Int){
        //var buf = Array(repeating: UInt8(0), count: 1024)
        //let data = string.data(using: .utf8 )!
        //for let i in 0..<cnt {
            
        //}
        //cmdBytes.copyBytes(to: &buf, count: cnt )
        oStream?.write(cmdBytes, maxLength: cnt)
        
    }
    
    @IBAction func sendClick(_ sender: Any) {
        if let text = myText.text {
            send(text)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


