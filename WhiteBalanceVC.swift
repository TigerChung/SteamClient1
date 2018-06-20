//
//  WhiteBalanceVC.swift
//  SteamClient1
//
//  Created by opto on 2018/6/17.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class WhiteBalanceVC: UIViewController, GetResponseDataDelegate {

    @IBOutlet weak var setRedOn: UITextField!
    @IBOutlet weak var setGreenOn: UITextField!
    @IBOutlet weak var setBlueOn: UITextField!
    @IBOutlet weak var setRedOff: UITextField!
    @IBOutlet weak var setGreenOff: UITextField!
    @IBOutlet weak var setBlueOff: UITextField!
    
    @IBOutlet weak var getRedOn: UILabel!
    @IBOutlet weak var getGreenOn: UILabel!
    @IBOutlet weak var getBlueOn: UILabel!
    @IBOutlet weak var getRedOff: UILabel!
    @IBOutlet weak var getGreenOff: UILabel!
    @IBOutlet weak var getBlueOff: UILabel!
    
    @IBOutlet weak var commandStatusLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init value
        setRedOn.text = "255"
        setGreenOn.text = "255"
        setBlueOn.text = "255"
        setRedOff.text = "255"
        setGreenOff.text = "255"
        setBlueOff.text = "255"
        
        getRedOn.text = ""
        getGreenOn.text = ""
        getBlueOn.text = ""
        getRedOff.text = ""
        getGreenOff.text = ""
        getBlueOff.text = ""
        
        spuMain.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setWhiteBalanceBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x0f)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x07)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        buf.append(UInt8(setRedOff.text!)!)   // Level 1
        buf.append(UInt8(setGreenOff.text!)!)   // Level 2
        buf.append(UInt8(setBlueOff.text!)!)   // Level 3
        buf.append(UInt8(setRedOn.text!)!)   // Level 4
        buf.append(UInt8(setGreenOn.text!)!)   // Level 5
        buf.append(UInt8(setBlueOn.text!)!)   // Level 6
        for i in 1...11 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        print("\(buf)")
        spuMain.sendBytes(buf, 15)
        statusLabel.text = "Status : Set White Balance"
        
    }
    
    
    @IBAction func getWhiteBalanceBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x10)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x01)
        buf.append(UInt8(spuID))   //Data: Spu id
        for i in 1...5 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        statusLabel.text = "Get White Balance"
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
    }
    
    
    
    func didShowResponseDataOnVC(_ sender: SpuMainClass) {
    
        if sender.rcvData[2] == 0x10 && sender.rcvData[4] == 0x07 {
            //Get White Balance
            getRedOff.text = "\(sender.rcvData[6])"
            getGreenOff.text = "\(sender.rcvData[7])"
            getBlueOff.text = "\(sender.rcvData[8])"
            getRedOn.text = "\(sender.rcvData[9])"
            getGreenOn.text = "\(sender.rcvData[10])"
            getBlueOn.text = "\(sender.rcvData[11])"
            
            self.commandStatusLabel.text = "Get White Balance"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x0f && sender.rcvData[4] == 0x01 {
            //Set White Balance
            self.commandStatusLabel.text = "Set White Balance"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[1] == 0x15 && sender.rcvData[4] == 0x01 {
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
