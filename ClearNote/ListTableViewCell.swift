//
//  ListTableViewCell.swift
//  ClearNote
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
protocol TableViewCellDelegate {
    //刪除
    func toDoItemDeleted(todoItem : ToDoItem)
    //cell啟動編輯過程
    func cellDidBeginEditing(editingCell: ListTableViewCell)
    //cell提交編輯過程
    func cellDidEndEditing(editingCell: ListTableViewCell)
}
class ListTableViewCell: UITableViewCell,UITextFieldDelegate{
    //設定漸層
    let gradientLayer = CAGradientLayer()
    //設定起始觸碰點
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false
    var completeCancelOnDragRelease = false
    var delegate : TableViewCellDelegate?
    var toDoItem : ToDoItem?{
        didSet{
            label.text = toDoItem!.text
            label.strikeThrough = toDoItem!.completed
            itemCompleteLayer.isHidden = !label.strikeThrough
        }
    }
    var label : StrikeThroughText
    var itemCompleteLayer = CALayer()
   
    var tickLabel : UILabel!
    var crossLabel : UILabel!
    let kUICuesMargin : CGFloat = 10.0
    let kUICuesWidth : CGFloat = 50.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        label = StrikeThroughText(frame: CGRect.null)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
       
        func createCueLabel() -> UILabel{
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.backgroundColor = UIColor.clear
            return label
        }
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        gradientLayer.frame = self.bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
      
        //添加下滑手勢
        var recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        addSubview(label)
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .right
        addSubview(tickLabel)
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2717}"
        crossLabel.textAlignment = .left
        addSubview(crossLabel)
       
        //新增一個在完成時呈現綠色背景的圖層
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0).cgColor
        itemCompleteLayer.isHidden = true
        layer.insertSublayer(itemCompleteLayer, at: 0)
        
        label.delegate = self
        label.contentVerticalAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(recognizer : UIPanGestureRecognizer){
        if recognizer.state == .began{
            //當手勢開始時紀錄中心位置
            originalCenter = center
        }
        if recognizer.state == .changed{
            //translation:平移手勢在視圖的座標中平移
            let translation = recognizer.translation(in: self)
            //左右滑動
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            //左滑刪除，滑過半完成刪除
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            //右滑完成，滑過半設置完成
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
            completeCancelOnDragRelease = frame.origin.x > frame.size.width / 2.0
           
            let cueAlpha = fabs(frame.origin.x) / fabs(frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            //移動過半即變色
            tickLabel.textColor = completeOnDragRelease ? UIColor.green : UIColor.white
            crossLabel.textColor = deleteOnDragRelease ? UIColor.red : UIColor.white
   
        }
        if recognizer.state == .ended{
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease{
                if delegate != nil && toDoItem != nil{
                    //通知該項必須被刪除
                    delegate!.toDoItemDeleted(todoItem: toDoItem!)
                }
            }else if completeOnDragRelease{
                if toDoItem != nil{
                    //該項不能編輯
                    toDoItem!.completed = true
//                    label.strikeThrough = true
//                    itemCompleteLayer.isHidden = false
                    delegate!.cellDidEndEditing(editingCell: self)
                }
//                if label.strikeThrough == true && itemCompleteLayer.isHidden == false{
//                    label.strikeThrough = false
//                    itemCompleteLayer.isHidden = true
//                }
                //該項劃上一條線
                label.strikeThrough = true
                //該項顏色變綠色
                itemCompleteLayer.isHidden = false
                //未完成回到原來的位置
                UIView.animate(withDuration: 0.2) {
                    self.frame = originalFrame
                }
            }else{
                //如果未刪除就回到原來的位置
                UIView.animate(withDuration: 0.2) {
                    self.frame = originalFrame
                }
            }
        }
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer{
            let translation = panGestureRecognizer.translation(in: superview!)
            //如手勢移動垂直就false
            if fabs(translation.x) > fabs(translation.y){
                return true
            }
            return false
        }
        return false
    }
    let kLabelLeftMargin: CGFloat = 15.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        label.frame = CGRect(x: kLabelLeftMargin, y: 0, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0, width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0, width: kUICuesWidth, height: bounds.size.height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //在enter上關閉鍵盤
        textField.resignFirstResponder()
        textField.returnKeyType = UIReturnKeyType.done
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if toDoItem != nil {
            return !toDoItem!.completed
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if toDoItem != nil{
            toDoItem!.text = textField.text!
        }
        if delegate != nil{
            delegate!.cellDidEndEditing(editingCell: self)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if delegate != nil{
            delegate!.cellDidBeginEditing(editingCell: self)
        }
    }
    
}
    
