//
//  ListViewController.swift
//  ClearNote
//
//  Created by apple on 2018/10/8.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController,TableViewCellDelegate,UISearchDisplayDelegate{
    //Data
    var toDoItems = [ToDoItem]()
    
    let ud = UserDefaults.standard
    let pinchRecognizer = UIPinchGestureRecognizer()
    //test
    var userSettingColor = "red" //讀取當前設定的值

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)

        do
        {
            self.toDoItems = try [ToDoItem].readFromPersistence()
        }
        catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                print("找不到資料")
            }
            else
            {
                print("讀取資料失敗")
            }
        }
        if toDoItems.count < 1{
             toDoItems.append(ToDoItem(text: "下拉新增該事項"))
             toDoItems.append(ToDoItem(text: "右滑完成該事項"))
             toDoItems.append(ToDoItem(text: "左滑刪除該事項"))
        }
        pinchRecognizer.addTarget(self, action: #selector(handlePinch(recognizer:)))
        tableView.addGestureRecognizer(pinchRecognizer)
//        targetPathList = "\(NSHomeDirectory())/Documents/mylist.plist"
//        print(targetPathList)
//        let fileMgr = FileManager.default
//        if !fileMgr.fileExists(atPath: targetPathList){
//            let source = Bundle.main.path(forResource: "mylist", ofType: "plist")!
//            try? fileMgr.copyItem(atPath: source, toPath: targetPathList)
//        }
        
        tableView.rowHeight = 50.0
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "CELL")
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isEditing = true
        if let color = ud.object(forKey: "userColor") as? String {
            userSettingColor = color
            print(color);
        } else {
            print("not set");
        }

    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification)
    {
        do
        {
            try toDoItems.writeToPersistence()
        }
        catch let error
        {
            NSLog("Error writing to persistence: \(error)")
        }
    }
    func getData(){
        do
        {
            try toDoItems.writeToPersistence()
        }
        catch let error
        {
            NSLog("Error writing to persistence: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! ListTableViewCell
//        cell.textLabel?.backgroundColor = UIColor.clear

        let item = toDoItems[indexPath.row]
//        cell.textLabel?.text = item.text
        cell.selectionStyle = .none
        switch userSettingColor { //在Theme有寫了個UIViewController擴充，讓這裡可以直接使用 當然要直接copy過來也行 就不用多傳listLength
        case "white":
            cell.backgroundColor = whiteColorForIndex(index: indexPath.row)
            cell.label.textColor = UIColor.black
        case "black":
            cell.backgroundColor = blackColorForIndex(index: indexPath.row)
            
        case "red":
            cell.backgroundColor = redColorForIndex(index: indexPath.row, listLength: toDoItems.count)
        case "blue":
            cell.backgroundColor = blueColorForIndex(index: indexPath.row, listLength: toDoItems.count)
            cell.label.textColor = UIColor.black
        case "green":
            cell.backgroundColor = greenColorForIndex(index: indexPath.row, listLength: toDoItems.count)
            cell.label.textColor = UIColor.black
        case "yellow":
            cell.backgroundColor = yellowColorForIndex(index: indexPath.row)
            cell.label.textColor = UIColor.black
        case "purple":
            cell.backgroundColor = purpleColorForIndex(index: indexPath.row)
            cell.label.textColor = UIColor.black
        case "cyan":
            cell.backgroundColor = cyanColorForIndex(index: indexPath.row)
            cell.label.textColor = UIColor.black
        default:
            cell.backgroundColor = whiteColorForIndex(index: indexPath.row)
            cell.label.textColor = UIColor.black
        }
        cell.delegate = self
        cell.toDoItem = item
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let row = indexPath.row
////            mylist.remove(at: row)
////            (mylist as NSArray).write(toFile: targetPathList, atomically: true)
//            tableView.reloadData()
//            //tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    //換行
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to destinationIndex: IndexPath) {
        let tmp = toDoItems[fromIndexPath.row]
        toDoItems.remove(at: fromIndexPath.row)
        toDoItems.insert(tmp, at: destinationIndex.row)
        tableView.reloadData()
        getData()
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func cellDidBeginEditing(editingCell: ListTableViewCell){
//        let editingOffset = (tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat)
        let editingOffset = tableView.contentOffset.y - tableView.frame.origin.y
        let visibleCells = tableView.visibleCells as! [ListTableViewCell]
        for cell in visibleCells{
            UITableView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform(translationX: 0,y: editingOffset + 20.0)
                if cell !== editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    func cellDidEndEditing(editingCell: ListTableViewCell){
        let visibleCells = tableView.visibleCells as! [ListTableViewCell]
        for cell: ListTableViewCell in visibleCells{
            UITableView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform.identity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
        if editingCell.toDoItem!.text == "" {
            toDoItemDeleted(todoItem: editingCell.toDoItem!)
        }else{
            getData()
        }
    }
    //刪除
    func toDoItemDeleted(todoItem toDoItem : ToDoItem){
        let index = (toDoItems as NSArray).index(of: toDoItem)
        if index == NSNotFound{
            return
        }
        toDoItems.remove(at: index)
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: index, section: 0)
        //刪除動畫漸漸淡化
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .fade)
        getData()
        tableView.endUpdates()
    }
    //新增
    let placeHolderCell = ListTableViewCell(style: .default, reuseIdentifier: "CELL")
    var pullDownInProgress = false
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pullDownInProgress = scrollView.contentOffset.y <= 0.0
        if pullDownInProgress{
            tableView.insertSubview(placeHolderCell, at: 0)
        }
    }
    struct TouchPoints {
        var upper : CGPoint
        var lower : CGPoint
    }
    var upperCellIndex = -100
    var lowerCellIndex = -100
    //開始觸摸的位置
    var initialTouchPoints : TouchPoints!
    var pinchExceededRequiredDistance = false
    var pinchInProgress = false
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer){
        if recognizer.state == .began{
            pinchStarted(recognizer: recognizer)
        }
        if recognizer.state == .changed && pinchInProgress && recognizer.numberOfTouches == 2{
            pinchChanged(recognizer: recognizer)
        }
        if recognizer.state == .ended{
            pinchEnded(recognizer: recognizer)
        }
    }
    func pinchStarted(recognizer: UIPinchGestureRecognizer){
        initialTouchPoints = getNormalizedTouchPoints(recognizer: recognizer)
        upperCellIndex = -100
        lowerCellIndex = -100
        let visibleCells = tableView.visibleCells as! [ListTableViewCell]
        for i in 0..<visibleCells.count{
            let cell = visibleCells[i]
            if viewContainsPoint(view: cell, point: initialTouchPoints.upper){
                upperCellIndex = i
            }
            if viewContainsPoint(view: cell, point: initialTouchPoints.lower){
                lowerCellIndex = i
            }
        }
        if abs(upperCellIndex - lowerCellIndex) == 1{
            pinchInProgress = true
            let precedingCell = visibleCells[upperCellIndex]
            placeHolderCell.frame = precedingCell.frame.offsetBy(dx: 0.0, dy: tableView.rowHeight / 2.0)
            placeHolderCell.backgroundColor = precedingCell.backgroundColor
            tableView.insertSubview(placeHolderCell, at: 0)
        }
    }
    func pinchChanged(recognizer: UIPinchGestureRecognizer){
        let currentTouchPoints = getNormalizedTouchPoints(recognizer: recognizer)
        let upperDelta = currentTouchPoints.upper.y - initialTouchPoints.upper.y
        let lowerDelta = initialTouchPoints.lower.y - currentTouchPoints.lower.y
        let delta = -min(0, min(upperDelta, lowerDelta))
        let visibleCells = tableView.visibleCells as! [ListTableViewCell]
        for i in 0..<visibleCells.count{
            let cell = visibleCells[i]
            if i <= upperCellIndex{
                cell.transform = CGAffineTransform(translationX: 0, y: -delta)
            }
            if i >= lowerCellIndex{
                cell.transform = CGAffineTransform(translationX: 0, y: delta)
            }
        }
        let gapSize = delta * 2
        let cappedGapSize = min(gapSize, tableView.rowHeight)
        placeHolderCell.transform = CGAffineTransform(translationX: 1.0, y: cappedGapSize / tableView.rowHeight)
        placeHolderCell.label.text = gapSize > tableView.rowHeight ? "Release to add item" : "Pull to add item"
        placeHolderCell.alpha = min(1.0, gapSize / tableView.rowHeight)
        pinchExceededRequiredDistance = gapSize > tableView.rowHeight
    }
    func pinchEnded(recognizer: UIPinchGestureRecognizer){
        pinchInProgress = false
        placeHolderCell.transform = CGAffineTransform.identity
        placeHolderCell.removeFromSuperview()
        if pinchExceededRequiredDistance{
            pinchExceededRequiredDistance = false
            let visibleCells = self.tableView.visibleCells as! [ListTableViewCell]
            for cell in visibleCells{
                cell.transform = CGAffineTransform.identity
            }
            let indexOffset = Int(floor(tableView.contentOffset.y / tableView.rowHeight))
            toDoItemAddedAtIndex(index: (indexOffset + 1) + lowerCellIndex)
            
        }else{
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                let visibleCells = self.tableView.visibleCells as! [ListTableViewCell]
                for cell in visibleCells{
                    cell.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        }
    }
    func getNormalizedTouchPoints(recognizer: UIGestureRecognizer) -> TouchPoints {
        var pointOne = recognizer.location(ofTouch: 0, in: tableView)
        var pointTwo = recognizer.location(ofTouch: 1, in: tableView)
        if pointOne.y > pointTwo.y{
            let temp = pointOne
            pointOne = pointTwo
            pointTwo = temp
        }
        return TouchPoints(upper: pointOne, lower: pointTwo)
    }
    func viewContainsPoint(view: UIView,point: CGPoint) -> Bool{
        let frame = view.frame
        return (frame.origin.y < point.y) && (frame.origin.y + (frame.size.height) > point.y)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollViewContentOffsetY = scrollView.contentOffset.y
        if pullDownInProgress && scrollView.contentOffset.y <= 0.0{
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight + 38, width: tableView.frame.size.width, height: tableView.rowHeight)
            placeHolderCell.label.text = -scrollViewContentOffsetY > tableView.rowHeight ? "Release to add item" : "Pull to add item"
            placeHolderCell.alpha = min(1.0, -scrollViewContentOffsetY / tableView.rowHeight)
        }else{
            pullDownInProgress = false
        }
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight{
            toDoItemAdded()
        }
        pullDownInProgress = false
        placeHolderCell.removeFromSuperview()
    }
    func toDoItemAdded(){
        toDoItemAddedAtIndex(index: 0)
    }
    func toDoItemAddedAtIndex(index: Int){
        let toDoItem = ToDoItem(text: "")
        toDoItems.insert(toDoItem, at: index)
        tableView.reloadData()
        var editCell : ListTableViewCell
        let visibleCells = tableView.visibleCells as! [ListTableViewCell]
        for cell in visibleCells{
            if (cell.toDoItem === toDoItem){
                editCell = cell
                editCell.label.becomeFirstResponder()
                break
            }
        }
    }
}

