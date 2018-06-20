//
//  FirmwareVersionVC.swift
//  SteamClient1
//
//  Created by opto on 2018/6/4.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class FirmwareVersionVC: UIViewController, GetResponseDataDelegate{

    @IBOutlet weak var spuVersionLabel: UILabel!
    @IBOutlet weak var tbuVersionLabel: UILabel!
   
    @IBOutlet weak var sensorVersionLabel: UILabel!
    @IBOutlet weak var sbuVersionLabel: UILabel!
    
    @IBOutlet weak var wifiVersionlabel: UILabel!
    
    @IBOutlet weak var getWiFiButton: UIButton!
    @IBOutlet weak var getSPUVersionButton: UIButton!
    
    
    
    @IBOutlet weak var logTextView: UITextView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    //let spuMain = SpuMainClass()
  
    @IBAction func getWifiVersionBtn(_ sender: Any) {
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
        logTextView.text.append(":Get WiFi Server version\n")
        print("\(buf)")
        spuMain.sendBytes(buf, 8)
        
    }
    
    
    
    
    @IBAction func getSpuVersionBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x00)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x01)
        
        buf.append(UInt8(spuID))   //Data: Spu id
        for i in 1...5 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        //let data = NSData(bytes: buf, length: buf.count)
        //LogTextView.text = LogTextView.text! + String("\(data)") + String(":Get WiFi Server version\n")
        logTextView.text.append(":Get SPU Firmware version\n")
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWiFiButton.titleLabel?.textAlignment = .center
        getSPUVersionButton.titleLabel?.textAlignment = .center
        wifiVersionlabel.text = ""
        spuVersionLabel.text = ""
        tbuVersionLabel.text = ""
        sensorVersionLabel.text = ""
        sbuVersionLabel.text = ""
        logTextView.text = ""
        spuMain.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didShowResponseDataOnVC(_ sender: SpuMainClass) {
        myLabel.text = String("Response No: " + "\(sender.responseCount)")
        logTextView.text.append("Response: \(sender.rcvData)" + "\n")
        if sender.rcvData[2] == 0 && sender.rcvData[4] == 0x15 {
            //Get SPU firmware Version
            var ver = ""
            var year: Int = Int(sender.rcvData[8]) + 1990
            ver = "\(sender.rcvData[6]).\(sender.rcvData[7])  \(year)-\(sender.rcvData[9])-\(sender.rcvData[10])"
            spuVersionLabel.text = ver
            //Get TBU firmware Version
            year = Int(sender.rcvData[13]) + 1990
            ver = "\(sender.rcvData[11]).\(sender.rcvData[12])  \(year)-\(sender.rcvData[14])-\(sender.rcvData[15])"
            tbuVersionLabel.text = ver
            //Get Sensor firmware Version
            year = Int(sender.rcvData[18]) + 1990
            ver = "\(sender.rcvData[16]).\(sender.rcvData[17])  \(year)-\(sender.rcvData[19])-\(sender.rcvData[20])"
            sensorVersionLabel.text = ver
            //Get SBU firmware Version
            year = Int(sender.rcvData[23]) + 1990
            ver = "\(sender.rcvData[21]).\(sender.rcvData[22])  \(year)-\(sender.rcvData[24])-\(sender.rcvData[25])"
            sbuVersionLabel.text = ver
        }
        else if sender.rcvData[2] == 0xd2 && sender.rcvData[4] == 0x05 {
            //Get WiFi firmware Version
            var spuVer = ""
            let year: Int = Int(sender.rcvData[7]) + 1990
            spuVer = "\(sender.rcvData[5]).\(sender.rcvData[6])  \(year)-\(sender.rcvData[8])-\(sender.rcvData[9])"
            wifiVersionlabel.text = spuVer
            
        }
        
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
