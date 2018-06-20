//
//  BrightnessTableVC.swift
//  SteamClient1
//
//  Created by opto on 2018/6/12.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class BrightnessTableVC: UIViewController, GetResponseDataDelegate {
    
    @IBOutlet weak var setLevel1: UITextField!
    @IBOutlet weak var setLevel2: UITextField!
    @IBOutlet weak var setLevel3: UITextField!
    @IBOutlet weak var setLevel4: UITextField!
    @IBOutlet weak var setLevel5: UITextField!
    @IBOutlet weak var setLevel6: UITextField!
    @IBOutlet weak var setLevel7: UITextField!
    @IBOutlet weak var setLevel8: UITextField!
    @IBOutlet weak var setLevel9: UITextField!
    @IBOutlet weak var setLevel10: UITextField!
    
    @IBOutlet weak var getLevel1: UILabel!
    @IBOutlet weak var getLevel2: UILabel!
    @IBOutlet weak var getLevel3: UILabel!
    @IBOutlet weak var getLevel4: UILabel!
    @IBOutlet weak var getLevel5: UILabel!
    @IBOutlet weak var getLevel6: UILabel!
    @IBOutlet weak var getLevel7: UILabel!
    
    @IBOutlet weak var getLevel8: UILabel!
    @IBOutlet weak var getLevel9: UILabel!
    @IBOutlet weak var getLevel10: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var commandStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // set Level value :
        setLevel1.text = "10"
        setLevel2.text = "20"
        setLevel3.text = "30"
        setLevel4.text = "40"
        setLevel5.text = "50"
        setLevel6.text = "60"
        setLevel7.text = "70"
        setLevel8.text = "80"
        setLevel9.text = "90"
        setLevel10.text = "100"
        // init to ""
        getLevel1.text = ""
        getLevel2.text = ""
        getLevel3.text = ""
        getLevel4.text = ""
        getLevel5.text = ""
        getLevel6.text = ""
        getLevel7.text = ""
        getLevel8.text = ""
        getLevel9.text = ""
        getLevel10.text = ""
        
        // Set SPU Delegate
        spuMain.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setBrightnessTableBtn(_ sender: Any) {
        
      
        var chksum: UInt16 = 0
        var buf = [UInt8]()
        
       
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x0b)    // Command ID
        buf.append(0x00)    // Data Length = 2 bytes
        buf.append(0x0b)
        buf.append(UInt8(spuMain.spuID))   //Data: Spu id
        buf.append(UInt8(setLevel1.text!)!)   // Level 1
        buf.append(UInt8(setLevel2.text!)!)   // Level 2
        buf.append(UInt8(setLevel3.text!)!)   // Level 3
        buf.append(UInt8(setLevel4.text!)!)   // Level 4
        buf.append(UInt8(setLevel5.text!)!)   // Level 5
        buf.append(UInt8(setLevel6.text!)!)   // Level 6
        buf.append(UInt8(setLevel7.text!)!)   // Level 7
        buf.append(UInt8(setLevel8.text!)!)   // Level 8
        buf.append(UInt8(setLevel9.text!)!)   // Level 9
        buf.append(UInt8(setLevel10.text!)!)   // Level 10
        for i in 1...15 {
            chksum = chksum + UInt16(buf[i])
        }
        buf.append(UInt8(chksum / 256))
        buf.append(UInt8(chksum % 256))
        buf.append(0x04)
        //let data = NSData(bytes: buf, length: buf.count)
        //LogTextView.text = LogTextView.text! + String("\(data)") + String(":Get WiFi Server version\n")
        statusLabel.text = "Status : Set Brightness Level"
        print("\(buf)")
        spuMain.sendBytes(buf, 19)
      
    }
    
    @IBAction func getBrightnessTablebtn(_ sender: Any) {
        
        var chksum: UInt16 = 0
        var buf = [UInt8]()
       
        // check if in broadcast case
        var spuID = spuMain.spuID
        if spuMain.spuID == 0 {
            spuID = spuMain.getCmdSpuID
        }
        
        buf.append(0x01) // Start Code
        buf.append(0x65) // Group ID
        buf.append(0x0c)    // Command ID
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
        statusLabel.text = "Get Brightness Table"
        print("\(buf)")
        spuMain.sendBytes(buf, 9)
 
        
    }
    
    func didShowResponseDataOnVC(_ sender: SpuMainClass) {
        
       
        if sender.rcvData[2] == 0x0c && sender.rcvData[4] == 0x0b {
            //Get Brightness Table
            getLevel1.text = "\(sender.rcvData[6])"
            getLevel2.text = "\(sender.rcvData[7])"
            getLevel3.text = "\(sender.rcvData[8])"
            getLevel4.text = "\(sender.rcvData[9])"
            getLevel5.text = "\(sender.rcvData[10])"
            getLevel6.text = "\(sender.rcvData[11])"
            getLevel7.text = "\(sender.rcvData[12])"
            getLevel8.text = "\(sender.rcvData[13])"
            getLevel9.text = "\(sender.rcvData[14])"
            getLevel10.text = "\(sender.rcvData[15])"
            
            self.commandStatusLabel.text = "Get Brightness Table"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[2] == 0x0b && sender.rcvData[4] == 0x01 {
            //Set Brightness Table
            self.commandStatusLabel.text = "Set Brightness Table"
            self.statusLabel.text = "Response: OK"
            
        }
        else if sender.rcvData[1] == 0x15 && sender.rcvData[4] == 0x01 {
            //Error: NAK
            //self.commandStatusLabel.text = "Set Brightness Table"
            self.statusLabel.text = "Response: NAK"
            
        }
    }
   /*
    func textField(_ textField: UITextField,
                   
                   shouldChangeCharactersIn range: NSRange,
                   
                   replacementString string: String) -> Bool {
        
        let inverseSet = NSCharacterSet(
            
            charactersIn:"0123456789").inverted
        
        let components = string.components(separatedBy: inverseSet)
            
        
        
        let filtered = components.joined(separator: "")
        //限制只能输入数字，不能输入特殊字符
        /*
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        DispatchQueue.main.async {
            print("length: \(length)")
        }
        */
        
        return string == filtered
        
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
