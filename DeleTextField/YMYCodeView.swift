//
//  YMCodeView.swift
//  DeleTextField
//
//  Created by mini on 2018/5/24.
//  Copyright © 2018年 miniYang. All rights reserved.
//

import UIKit

public class YMCodeView: UIView, keyInputTextFieldDelegate, UITextFieldDelegate {
    
    var delegate: YMCodeViewDelegate?
    
    var defaultColor = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 244.0/255, alpha: 1.0)
    var heightColor = UIColor.init(red: 245.0/255, green: 106.0/255, blue: 32.0/255, alpha: 1.0)
    var lineErrorColor = UIColor.init(red: 236.0/255, green: 0.0, blue: 26.0/255, alpha: 1.0)
    //item  的数量
    public var itemCount: Int = 5
    //item  的宽度
    public var itemWith: CGFloat = 30.0
    //item 到父视图的左右间隙  默认是0
    public var margin_LR: CGFloat = 0.0
    //item 的宽度
    public var titleSize:CGFloat = 20.0
    
    var textFields: [YMCodeTextField] = []
    var lines: [UIView] = []
    var firstTextField: YMCodeTextField?
    var firstLine: UIView?
    var index: Int = 0
    var isLastFill: Bool = false
    var inputString: String = ""

    public convenience  init(count: Int, with: CGFloat = 0) {
        
        self.init()
        if(count < 1 || count > 6) {
            
            itemCount = 6
        }else {
            
            itemCount = count
        }
        
        if(with <= 0){
            itemWith = 30.0
        }else {
            itemWith = with
        }
        
        configTextField(itemCount)
    }
    
    func configTextField(_ count: Int) {
        
        for _ in 0..<count {
            let textField = YMCodeTextField.init()
            textField.keyInputDelegate = self
            textField.delegate = self
            textFields.append(textField)
            addSubview(textField)
            textField.isEnabled = false
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.font = UIFont.systemFont(ofSize: titleSize)
            textField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
            
            let line = UIView.init()
            line.backgroundColor = defaultColor
            lines.append(line)
            addSubview(line)
        }
        firstTextField = textFields.first
        firstLine = lines.first
        
    }
    
    public override func layoutSubviews() {
        
        let spaceing: CGFloat = (bounds.width - itemWith * CGFloat(itemCount) - 2*margin_LR)/CGFloat(itemCount - 1)
        
        for i in 0..<itemCount {
            
            let line: UIView = lines[i]
            let field: UITextField = textFields[i]
            let height = bounds.height - CGFloat(1)
            let itmeX:CGFloat = margin_LR + (itemWith + spaceing) * CGFloat(i)
            let fieldFrame = CGRect.init(x: itmeX, y: 0, width: itemWith, height: height)
            
            let lineFrame = CGRect.init(x: itmeX, y: height, width: itemWith, height: 1)
            line.frame = lineFrame
            field.frame = fieldFrame
        }
    }
    
    @objc func textFieldChange(_ textField: UITextField) {
        
        if(textField.text!.count > 1) {
            //let endIndex = textField.text!.index(textField.text!.startIndex, offsetBy: 1)
            textField.text = "\(textField.text!.first!)"
        }
        textField.isEnabled = false
        firstTextField = textFields[index]
        firstTextField?.isEnabled = true
        firstTextField?.becomeFirstResponder()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string.count > 0) {
            inputString = inputString.appending(string)
            
            if(index == (itemCount - 1)) {
                if(delegate != nil) {
                    delegate?.codeView(inputString)
                }
                isLastFill = true
                index += 1
                let line = lines[index]
                line.backgroundColor = heightColor
                firstLine = line
            }
            
        }
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        firstLine?.backgroundColor = heightColor
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        let tempIndex: Int = textFields.index(of: textField as! YMCodeTextField) ?? 0
        
        let line = lines[tempIndex]
        
        line.backgroundColor = defaultColor
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        firstTextField?.isEnabled = true
        firstTextField?.becomeFirstResponder()
        firstLine?.backgroundColor = heightColor
    }
    
    
    //激活状态
    func beComeFirst() {
        
        firstTextField?.isEnabled = true
        firstTextField?.becomeFirstResponder()
        firstLine?.backgroundColor = heightColor
    }
    
    //静默状态
    func registFirst() {
        
        firstTextField?.resignFirstResponder()
        firstLine?.backgroundColor = defaultColor
    }
    
    //错误码  下划线显示的颜色
    public func linesErrorColor() {
        for line in lines {
            line.backgroundColor = lineErrorColor
        }
    }
    
    //真确的情况下 下划线的颜色
    func linesDefaultColor() {
        for line in lines {
            line.backgroundColor = defaultColor
        }
    }
    
    
    
}

protocol YMCodeViewDelegate :class {
    func codeView(_ inputString: String)
}


extension YMCodeView {
    
    func deleBackward() {
        
        //如果是最后一个 field
        if(isLastFill) {
            isLastFill = false
            firstTextField?.isEnabled = true
            firstTextField?.becomeFirstResponder()
            firstTextField?.text = ""
            
        }else if(index >= 1){
            //let line = lines[index]
            //line.backgroundColor = defaultColor
            firstTextField?.isEnabled = false
            index -= 1
            firstTextField = textFields[index]
            firstLine = lines[index]
            firstTextField?.isEnabled = true
            firstTextField?.text = ""
            firstTextField?.becomeFirstResponder()
        }
        
        if(inputString.count >= 1) {
            let endIndex = inputString.index(before: inputString.endIndex)
            let tempString = String(inputString[inputString.startIndex..<endIndex])
            inputString = tempString
            
            if(delegate != nil) {
                delegate?.codeView(inputString)
            }
        }
    }
}
