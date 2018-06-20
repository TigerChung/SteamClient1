//
//  SpuMainClass.swift
//  SteamClient1
//
//  Created by opto on 2018/5/18.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import Foundation
import UIKit

// Global Variable
var hostIp: String = ""
var hostPort: Int = 23

class SpuMainClass {
    // 將　 iStream, oStream 宣告為global變數
    //var spuStream = Stream()
    var inStream: InputStream? = nil
    var outStream: OutputStream? = nil
    var isConnected: Bool = false
    var responseCount: Int = 0
    var spuID = 1
    var getCmdSpuID = 1
    var rcvData = [UInt8]()
    var delegate: GetResponseDataDelegate?
    
    
    func connect(ipServer: String, portServer: Int) {
        let _ = Stream.getStreamsToHost(withName: ipServer, port: portServer, inputStream: &(inStream), outputStream: &(outStream) )
        inStream?.open()
        outStream?.open()
        isConnected = true
        DispatchQueue.global().async {
            self.receiveData(available: { (string,cnt) in
                //let data = Data(bytes: string, count: cnt)
                //let data = UnsafeMutablePointer<UInt8>.allocate(capacity: cnt)
                //var data = Array(repeating: UInt8(0), count: cnt)
                let data = string.dropLast(string.count - cnt)
                
                self.responseCount += 1
                self.rcvData.removeAll()
                for i in (0...data.count-1) {
                  self.rcvData.append(data[i])
                }
                
                
                DispatchQueue.main.async {
                    //pageVC.myLabel.text = String("Response No: " + "\(self.responseCount)")
                    //pageTV.text.append("Response: \(data)" + "\n")
                    print("Response: \(self.rcvData)")
                    self.didShowDataOnPage()
                    
                }
                
                if cnt <= 0 {
                    self.close()
                }
                //data.deallocate()
                
            })
        }
        
    }
    func didShowDataOnPage(){
        delegate?.didShowResponseDataOnVC(self)
    }
    
    func close() {
        inStream?.close()
        outStream?.close()
        isConnected = false
        
    }
    func receiveData(available: (_ string: [UInt8],_ cnt: Int) -> Void ){
        var buf = Array(repeating: UInt8(0), count: 1024)
        if inStream == nil {
            return
            
        }
        while true {
            if let n = inStream?.read(&buf, maxLength: 1024)  {
                if n > 0 && n <= 1024 {
                    //let data = Data(bytes: buf, count: n)
                    //let string = String(data: data, encoding: .ascii)
                    available(buf,n)
                    
                }
                else {
                    print("No data received!")
                    
                    
                }
            }
            
        }
    }
    
    func send(_ string: String){
        var buf = Array(repeating: UInt8(0), count: 1024)
        let data = string.data(using: .utf8 )!
        
        data.copyBytes(to: &buf, count: data.count )
        outStream?.write(buf, maxLength: data.count)
        
    }
    
    func sendBytes(_ cmdBytes: [UInt8], _ cnt: Int){
        //var buf = Array(repeating: UInt8(0), count: 1024)
        //let data = string.data(using: .utf8 )!
        //for let i in 0..<cnt {
        
        //}
        //cmdBytes.copyBytes(to: &buf, count: cnt )
        if isConnected == false {
           connect(ipServer: hostIp, portServer: hostPort)
        }
        outStream?.write(cmdBytes, maxLength: cnt)
        
    }
}
