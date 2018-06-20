//
//  FunctionTableVC.swift
//  SteamClient1
//
//  Created by opto on 2018/6/5.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

class FunctionTableVC: UITableViewController {
    
    var tableList = [["Firmware Version","Brightness Level", "Brightness Table", "White Balance", "Gamma and Correction","Block Size and SPU Cascade","Test Pattern"],["Option"]]
    var titleSection = ["SPU Function","Option"]
    
    let fullSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableList[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idFunctionCell", for: indexPath)
       
        cell.textLabel?.text  = tableList[indexPath.section][indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "idSpuFirmwareSegue", sender: self)
            }
            else if indexPath.row == 1 {
                performSegue(withIdentifier: "idBrightnessSegue", sender: self)
            }
            else if indexPath.row == 2 {
                performSegue(withIdentifier: "idBrightnessTableSegue", sender: self)
            }
            else if indexPath.row == 3 {
                performSegue(withIdentifier: "idWhiteBalanceSegue", sender: self)
            }
            else if indexPath.row == 4 {
                performSegue(withIdentifier: "idGammaCorrectionSegue", sender: self)
            }
            else if indexPath.row == 5 {
                performSegue(withIdentifier: "idBlockSizeSegue", sender: self)
            }
            else if indexPath.row == 6 {
                performSegue(withIdentifier: "idTestPatternSegue", sender: self)
            }
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return titleSection[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
        if section == 0 {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
            titleLabel.textColor = UIColor.red
            titleLabel.textAlignment = .center
            titleLabel.text = "SPU Function"
            titleLabel.center = CGPoint(x: fullSize.width * 0.5, y: 20)
            myView.addSubview(titleLabel)
            
        }
        return myView
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
