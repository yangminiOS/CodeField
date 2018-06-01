//
//  DTextField.swift
//  DeleTextField
//
//  Created by mini on 2018/5/24.
//  Copyright © 2018年 miniYang. All rights reserved.
//

import UIKit

class YMCodeTextField: UITextField {
    
    weak var keyInputDelegate: keyInputTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if(keyInputDelegate != nil) {
            
            keyInputDelegate?.deleBackward()
        }
    }
}

protocol keyInputTextFieldDelegate: class {
     func deleBackward()
}
