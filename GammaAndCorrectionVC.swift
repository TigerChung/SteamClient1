//
//  GammaAndCorrectionVC.swift
//  SteamClient1
//
//  Created by opto on 2018/6/18.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class GammaAndCorrectionVC: UIViewController, GetResponseDataDelegate {

    @IBOutlet weak var setGammaValue: UILabel!
    @IBOutlet weak var getGammaValue: UILabel!
    
    @IBOutlet weak var setColorCorrectionLabel: UILabel!
    @IBOutlet weak var getColorCorrectionLabel: UILabel!
    
    @IBOutlet weak var commandStatusLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet weak var setGammaStepper: UIStepper!
    
    @IBOutlet weak var setColorCorrectionSwitch: UISwitch!
    
    let gammaValue = ["1.0","1.6","1.7","1.8","1.9","2.0","2.1","2.2","2.3","2.4","2.5","2.6","2.7","2.8","2.9","3.0"]
                      
                      
    override func viewDidLoad() {
        super.viewDidLoad()

        setGammaValue.text = gammaValue[Int(setGammaStepper.value)]
        getGammaValue.text = ""
        setColorCorrectionLabel.text = setColorCorrectionSwitch.isOn ? "On" : "Off"
        getColorCorrectionLabel.text = ""
        
        spuMain.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeGammaStepper(_ sender: Any) {
        setGammaValue.text = gammaValue[Int(setGammaStepper.value)]
    }
    
    @IBAction func changeColorCorrectionswitch(_ sender: Any) {
        setColorCorrectionLabel.text = setColorCorrectionSwitch.isOn ? "On" : "Off"
    }
    
    @IBAction func setGammaBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x11)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x02)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        buf.append(UInt8(setGammaStepper.value))   // Gamma Index
        
        for i in 1...6 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        print("\(buf)")
        spuMain.sendBytes(buf, 10)
        statusLabel.text = "Status : Set Gamma Value"
    }
    
    @IBAction func getGammaBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x12)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x01)
        buf.append(UInt8(spuID))   //Data: Spu id
        for i in 1...5 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        statusLabel.text = "Get Gamma Value"
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
        
    }
    
    @IBAction func setColorCorrection(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x1d)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x02)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        buf.append(UInt8(setColorCorrectionSwitch.isOn ? 1 : 0))   // Color Correction
        
        for i in 1...6 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        print("\(buf)")
        spuMain.sendBytes(buf, 10)
        statusLabel.text = "Status : Set Color Correction"
        
    }
    
    
    @IBAction func getColorCorrection(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x1e)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x01)
        buf.append(UInt8(spuID))   //Data: Spu id
        for i in 1...5 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        statusLabel.text = "Get Color Correction"
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
        
    }
    
    func didShowResponseDataOnVC(_ sender: SpuMainClass) {
        
        if sender.rcvData[2] == 0x12 && sender.rcvData[4] == 0x02 {
            //Get Gamma Value
            getGammaValue.text = gammaValue[Int(sender.rcvData[6])]
            
            self.commandStatusLabel.text = "Get Gamma Value"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x11 && sender.rcvData[4] == 0x01 {
            //Set Gamma Value
            self.commandStatusLabel.text = "Set Gamma Value"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x1e && sender.rcvData[4] == 0x02 {
            //Get Color Correction
            getColorCorrectionLabel.text = sender.rcvData[6] == 0 ? "Off" : "On"
           
            self.commandStatusLabel.text = "Get Color Correction"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x1d && sender.rcvData[4] == 0x01 {
            //Set Color Correction
            self.commandStatusLabel.text = "Set Color Correction"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x15 && sender.rcvData[4] == 0x01 {
            //Error: NAK
            //self.commandStatusLabel.text = "Set Brightness Table"
            self.statusLabel.text = "Response: NAK"
            
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
