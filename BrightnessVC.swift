//
//  BrightnessVC.swift
//  SteamClient1
//
//  Created by opto on 2018/6/11.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class BrightnessVC: UIViewController, GetResponseDataDelegate {

    @IBOutlet weak var brightnessLevelValue: UILabel!
    @IBOutlet weak var setLevelStepper: UIStepper!
    
    @IBOutlet weak var sensorModeSwitch: UISwitch!
    
    @IBOutlet weak var sensorMode: UILabel!
    
    @IBOutlet weak var getLevelValue: UILabel!
    @IBOutlet weak var getSensorMode: UILabel!
   
    @IBOutlet weak var logTextView: UITextView!
    
    var setLevel = 1 // Level = 1 -- 10
    var setMode = 0 // 0 = "Manual", 1 = "Auto"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brightnessLevelValue.text = ""
        sensorMode.text = ""
        getLevelValue.text = ""
        getSensorMode.text = ""
        setLevel = Int(setLevelStepper.value)
        brightnessLevelValue.text =  "\(setLevel)"
        
        sensorMode.text = sensorModeSwitch.isOn ? "Auto" : "Manual"
        setMode = sensorModeSwitch.isOn ? 1 : 0
        // Set SPU Delegate
        spuMain.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeLevelStepper(_ sender: Any) {
        
        setLevel = Int(setLevelStepper.value)
        brightnessLevelValue.text =  "\(setLevel)"
        
    }
    
    
    
    
    @IBAction func changeSensorModeSwitch(_ sender: Any) {
        sensorMode.text = sensorModeSwitch.isOn ? "Auto" : "Manual"
        setMode = sensorModeSwitch.isOn ? 1 : 0
        
    }
    
    
    @IBAction func setBrightnessBtn(_ sender: Any) {
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
        buf.append(0x17)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x03)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        buf.append(UInt8(setMode))   //Sensor Mode
        buf.append(UInt8(setLevel-1))   //Brightness level
        for i in 1...7 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        //let data = NSData(bytes: buf, length: buf.count)
        //LogTextView.text = LogTextView.text! + String("\(data)") + String(":Get WiFi Server version\n")
        logTextView.text.append(":Set Brightness Level\n")
        print("\(buf)")
        spuMain.sendBytes(buf, 11)
        
    }
    
    
    @IBAction func getBrightnessBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x18)    // Command ID
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
        logTextView.text.append(":Get Brightness Level\n")
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
        
    }
    func didShowResponseDataOnVC(_ sender: SpuMainClass) {
        
        self.logTextView.text.append("Response: \(sender.rcvData)" + "\n")
        if sender.rcvData[2] == 0x18 && sender.rcvData[4] == 0x03 {
            //Get Brightness Level and Mode
            getSensorMode.text = sender.rcvData[6] == 0 ? "Manual" : "Auto"
            getLevelValue.text = "\(sender.rcvData[7] + 1)"
            self.logTextView.text.append("Response: OK" + "\n")
            
        }
        else if sender.rcvData[2] == 0x17 && sender.rcvData[4] == 0x01 {
            //Set Brightness OK
            self.logTextView.text.append("Response: OK" + "\n")
            
        }
        else if sender.rcvData[1] == 0x15 && sender.rcvData[4] == 0x01 {
            //Error: NAK
            //self.commandStatusLabel.text = "Set Brightness Table"
            //self.statusLabel.text = "Response: NAK"
            
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
