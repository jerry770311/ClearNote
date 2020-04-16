//
//  ThemesViewController.swift
//  ClearNote
//
//  Created by apple on 2018/10/8.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ThemesViewController: UITableViewController {
    //Data
    var themesList = [String]()
    var targetPathThemes : String!
    let ud = UserDefaults.standard
    var userSettingThemesColor = "white"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        targetPathThemes = "\(NSHomeDirectory())/Documents/themeslist.plist"
        print(targetPathThemes)
        let fileMgr = FileManager.default
        if !fileMgr.fileExists(atPath: targetPathThemes){
            let source = Bundle.main.path(forResource: "themeslist", ofType: "plist")!
            try? fileMgr.copyItem(atPath: source, toPath: targetPathThemes)
        }
        
        tableView.rowHeight = 50.0
        tableView.register(ThemesTableViewCell.self, forCellReuseIdentifier: "CELL")
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        themesList = NSArray(contentsOfFile: targetPathThemes) as! [String]
        self.tableView.reloadData()
        if let color = ud.object(forKey: "userColor") as? String{
            userSettingThemesColor = color
            print(color)
        }else{
            print("Not set")
        }
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return themesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! ThemesTableViewCell

        let data = themesList[indexPath.row]
        cell.textLabel?.text = data
        
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
//        cell.backgroundColor = redColorForIndex(index: indexPath.row,listLength: themesList.count)
//        cell.textLabel?.textColor = UIColor.white
        switch userSettingThemesColor {
        case "white":
            cell.backgroundColor = whiteColorForIndex(index: indexPath.row)
            cell.textLabel?.textColor = UIColor.black
            
        case "black":
            cell.backgroundColor = blackColorForIndex(index: indexPath.row)
            cell.textLabel?.textColor = UIColor.white
    
        case "red":
            cell.backgroundColor = redColorForIndex(index: indexPath.row, listLength: themesList.count)
            cell.textLabel?.textColor = UIColor.white
            
        case "blue":
            cell.backgroundColor = blueColorForIndex(index: indexPath.row, listLength: themesList.count)
            cell.textLabel?.textColor = UIColor.black
            
        case "green":
            cell.backgroundColor = greenColorForIndex(index: indexPath.row, listLength: themesList.count)
            cell.textLabel?.textColor = UIColor.black
            
        case "yellow":
            cell.backgroundColor = yellowColorForIndex(index: indexPath.row)
            cell.textLabel?.textColor = UIColor.black
            
        case "purple":
            cell.backgroundColor = purpleColorForIndex(index: indexPath.row)
            cell.textLabel?.textColor = UIColor.black
        case "cyan":
            cell.backgroundColor = cyanColorForIndex(index: indexPath.row)
            cell.textLabel?.textColor = UIColor.black
        default:
            cell.backgroundColor = redColorForIndex(index: indexPath.row, listLength: themesList.count)
            cell.textLabel?.textColor = UIColor.white
            
        }

        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none{
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        switch indexPath.row {
        case 0:
            let dataCount = themesList.count
            for i in 0...dataCount{
                let yourIndex = NSIndexPath(item: i, section: 0)
                let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                cell?.backgroundColor = whiteColorForIndex(index: i)
                cell?.textLabel?.textColor = UIColor.black
                // 點白色存white 名稱叫userColor
                ud.set("white", forKey: "userColor")
                ud.synchronize() // 存檔
            }

        case 1:
                let dataCount = themesList.count
                for i in 0...dataCount{
                    let yourIndex = NSIndexPath(item: i, section: 0)
                    let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                    cell?.backgroundColor = blackColorForIndex(index: i)
                    cell?.textLabel?.textColor = UIColor.white
                    ud.set("black", forKey: "userColor")
                    ud.synchronize()
                }
        case 2:
            let dataCount = themesList.count
            for i in 0...dataCount{
                let yourIndex = NSIndexPath(item: i, section: 0)
                let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                cell?.backgroundColor = redColorForIndex(index: i,listLength: themesList.count)
                cell?.textLabel?.textColor = UIColor.white
                ud.set("red", forKey: "userColor")
                ud.synchronize()
            }
        case 3:
            let dataCount = themesList.count
            for i in 0...dataCount{
                let yourIndex = NSIndexPath(item: i, section: 0)
                let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                cell?.backgroundColor = blueColorForIndex(index: i,listLength: themesList.count)
                cell?.textLabel?.textColor = UIColor.black
                ud.set("blue", forKey: "userColor")
                ud.synchronize()
            }
        case 4:
            let dataCount = themesList.count
            for i in 0...dataCount{
                let yourIndex = NSIndexPath(item: i, section: 0)
                let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                cell?.backgroundColor = greenColorForIndex(index: i,listLength: themesList.count)
                cell?.textLabel?.textColor = UIColor.black
                ud.set("green", forKey: "userColor")
                ud.synchronize()
            }
        case 5:
            let dataCount = themesList.count
            for i in 0...dataCount{
                let yourIndex = NSIndexPath(item: i, section: 0)
                let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                cell?.backgroundColor = yellowColorForIndex(index: i)
                cell?.textLabel?.textColor = UIColor.black
                ud.set("yellow", forKey: "userColor")
                ud.synchronize()
            }
        case 6:
            let dataCount = themesList.count
            for i in 0...dataCount{
                let yourIndex = NSIndexPath(item: i, section: 0)
                let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                cell?.backgroundColor = purpleColorForIndex(index: i)
                cell?.textLabel?.textColor = UIColor.black
                ud.set("purple", forKey: "userColor")
                ud.synchronize()
            }
        case 7:
            let dataCount = themesList.count
            for i in 0...dataCount{
                let yourIndex = NSIndexPath(item: i, section: 0)
                let cell = tableView.cellForRow(at: yourIndex as IndexPath)
                cell?.backgroundColor = cyanColorForIndex(index: i)
                cell?.textLabel?.textColor = UIColor.black
                ud.set("cyan", forKey: "userColor")
                ud.synchronize()
            }
        default:
            break
        }
    }
    //選取符號
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none{
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension UIViewController {
    //白色
    func whiteColorForIndex(index: Int) -> UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //黑色
    func blackColorForIndex(index: Int) -> UIColor {
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    //紅色，並帶入目前列表長度
    func redColorForIndex(index: Int, listLength: Int) -> UIColor {
        let itemCount = listLength - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
    }
    func blueColorForIndex(index: Int, listLength: Int) -> UIColor {
        let itemCount = listLength - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.0, green: color, blue: 1.0, alpha: 1.0)
    }
    func greenColorForIndex(index: Int, listLength: Int) -> UIColor {
        let itemCount = listLength - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.0, green: 1.0, blue: color, alpha: 1.0)
    }
    func yellowColorForIndex(index: Int) -> UIColor {
        return UIColor.yellow
    }
    func purpleColorForIndex(index: Int) -> UIColor{
        return UIColor.purple
    }
    func cyanColorForIndex(index: Int) -> UIColor{
        return UIColor.cyan
    }
}
