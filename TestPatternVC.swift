//
//  TestPatternVC.swift
//  SteamClient1
//
//  Created by opto on 2018/6/18.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class TestPatternVC: UIViewController, GetResponseDataDelegate {

    @IBOutlet weak var getDisplayMode: UILabel!
    @IBOutlet weak var getPatternType: UILabel!
    
    @IBOutlet weak var commandStatusLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var patternMode: UInt8 = 0
    var patternType: UInt8 = 0
    let patternModeLabel = ["Normal","Display All","Fixed Pattern","Line Buffer"]
    let patternTypeLabel = ["Red","Green","Blue","PAT1","PAT2" ,"PAT3","PAT4","COL1","COL2","ROW1","ROW2","ID Address","Black","White","Panel ID"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDisplayMode.text = ""
        getPatternType.text = ""
        
        
        spuMain.delegate = self
        
    }

    @IBAction func setNormalMode(_ sender: Any) {
        patternMode = 0
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setDisplayAllMode(_ sender: Any) {
        patternMode = 1
        setTestPatternMode(patternMode, patternType)
        
    }
    
    @IBAction func setLineBufferMode(_ sender: Any) {
        patternMode = 3
        setTestPatternMode(patternMode, patternType)
        
    }
    
    @IBAction func setRedPatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 0
        setTestPatternMode(patternMode, patternType)
        
    }
    
    @IBAction func setGreenPatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 1
        setTestPatternMode(patternMode, patternType)
        
    }
    
    @IBAction func setBluePatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 2
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setPat1PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 3
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setPat2PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 4
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setPat3PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 5
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setPat4PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 6
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setCol1PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 7
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setCol2PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 8
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setRow1PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 9
        setTestPatternMode(patternMode, patternType)
    }
    
    
    @IBAction func setRow2PatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 10
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setIdPatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 11
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setBlackPatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 12
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setWhitePatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 13
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func setPanelIdPatternMode(_ sender: Any) {
        patternMode = 2
        patternType = 14
        setTestPatternMode(patternMode, patternType)
    }
    
    @IBAction func getTestPatternBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x1c)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x01)
        buf.append(UInt8(spuID))   //Data: Spu id
        for i in 1...5 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        statusLabel.text = "Get Test Pattern"
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
    }
    
    func setTestPatternMode(_ mode: UInt8, _ type: UInt8) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x1b)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x03)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        buf.append(UInt8(mode))   // Pattern Mode
        buf.append(UInt8(type))   // Pattern type
        
        for i in 1...7 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        print("\(buf)")
        spuMain.sendBytes(buf, 11)
        statusLabel.text = "Status : Set Test Pattern"
        
    }
    
    func didShowResponseDataOnVC(_ sender: SpuMainClass) {
        
        if sender.rcvData[2] == 0x1c && sender.rcvData[4] == 0x03 {
            //Get Text Pattern
            getDisplayMode.text = patternModeLabel[Int(sender.rcvData[6])]
            getPatternType.text = patternTypeLabel[Int(sender.rcvData[7])]
            
            
            self.commandStatusLabel.text = "Get Test Pattern"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x1b && sender.rcvData[4] == 0x01 {
            //Set Test Pattern
            self.commandStatusLabel.text = "Set Test Pattern"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[1] == 0x15 && sender.rcvData[4] == 0x01 {
            //Error: NAK
            //self.commandStatusLabel.text = "Set Brightness Table"
            self.statusLabel.text = "Response: NAK"
            
        }
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
