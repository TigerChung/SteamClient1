//
//  BlockSizeAndDataBits.swift
//  SteamClient1
//
//  Created by opto on 2018/6/18.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class BlockSizeAndDataBits: UIViewController, GetResponseDataDelegate {
  

    @IBOutlet weak var setBlockSizeWidth: UILabel!
    @IBOutlet weak var setBlockSizeHeight: UILabel!
    
    @IBOutlet weak var getBlockSizeWidth: UILabel!
    @IBOutlet weak var getBlockSizeHeight: UILabel!
    @IBOutlet weak var setBlockSizeWidthStepper: UIStepper!
    @IBOutlet weak var setBlockSizeHeightStepper: UIStepper!
    
    @IBOutlet weak var setSPUAmount: UILabel!
    @IBOutlet weak var getSPUAmount: UILabel!
    @IBOutlet weak var setSPUAmountStepper: UIStepper!
    
    @IBOutlet weak var commandStatusLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBlockSizeWidth.text = "\(Int(setBlockSizeWidthStepper.value))"
        setBlockSizeHeight.text = "\(Int(setBlockSizeHeightStepper.value))"
        getBlockSizeWidth.text = ""
        getBlockSizeHeight.text = ""
        setSPUAmount.text = "\(Int(setSPUAmountStepper.value))"
        getSPUAmount.text = ""
        
        spuMain.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeBlockSizeWidthStepper(_ sender: Any) {
        setBlockSizeWidth.text = "\(Int(setBlockSizeWidthStepper.value))"
        
    }
    
    @IBAction func changeBlockSizeHeightStepper(_ sender: Any) {
        setBlockSizeHeight.text = "\(Int(setBlockSizeHeightStepper.value))"
        
    }
    
    @IBAction func changeSPUAmountStepper(_ sender: Any) {
        setSPUAmount.text = "\(Int(setSPUAmountStepper.value))"
    }
    
    
    @IBAction func setBlockSizeBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        var hVal = Int(Int(setBlockSizeWidthStepper.value) >> 8)
        var lVal = Int(Int(setBlockSizeWidthStepper.value) % 256)
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x19)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x05)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        
        buf.append(UInt8(hVal))  // Width High Byte
        
        buf.append(UInt8(lVal)) // Width Low Byte
        
        hVal = Int(Int(setBlockSizeHeightStepper.value) >> 8)
        lVal = Int(Int(setBlockSizeHeightStepper.value) % 256)
        buf.append(UInt8(hVal))   // Height High Byte
        buf.append(UInt8(lVal))  // Height Low Byte
        for i in 1...9 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        print("\(buf)")
        spuMain.sendBytes(buf, 13)
        statusLabel.text = "Status : Set Block Size"
        
    }
    
    @IBAction func getBlockSizeBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x1a)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x01)
        buf.append(UInt8(spuID))   //Data: Spu id
        for i in 1...5 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        statusLabel.text = "Get Block Size"
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
        
        
    }
    
    @IBAction func setSPUAmountBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x35)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x02)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        buf.append(UInt8(setSPUAmount.text!)!)   // SPU Amount
     
        for i in 1...6 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        print("\(buf)")
        spuMain.sendBytes(buf, 10)
        statusLabel.text = "Status : Set SPU Amount"
        
    }
    
    @IBAction func getSPUAmountBtn(_ sender: Any) {
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x36)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x01)
        buf.append(UInt8(spuID))   //Data: Spu id
        for i in 1...5 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        
        statusLabel.text = "Get SPU Amount"
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
        
    }
    
    func didShowResponseDataOnVC(_ sender: SpuMainClass) {
        
        if sender.rcvData[2] == 0x1a && sender.rcvData[4] == 0x05 {
            //Get Block Size
            var value = Int(sender.rcvData[6]) * 256 + Int(sender.rcvData[7])
            getBlockSizeWidth.text = "\(value)"
            value = Int(sender.rcvData[8]) * 256 + Int(sender.rcvData[9])
            getBlockSizeHeight.text = "\(value)"
            
            self.commandStatusLabel.text = "Get Block Size"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x19 && sender.rcvData[4] == 0x01 {
            //Set Block Size
            self.commandStatusLabel.text = "Set Block Size"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x36 && sender.rcvData[4] == 0x02 {
            //Get SPU Amount
            
            getSPUAmount.text = "\(Int(sender.rcvData[6]))"
            
            
            self.commandStatusLabel.text = "Get SPU Amount"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x35 && sender.rcvData[4] == 0x01 {
            //Set SPU Amount
            self.commandStatusLabel.text = "Set SPU Amount"
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
