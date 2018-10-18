//
//  ViewController.swift
//  DeleTextField
//
//  Created by mini on 2018/5/24.
//  Copyright © 2018年 miniYang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TaxInputViewDelegate {
    
    var taxInputView: TaxInputView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taxInputView = TaxInputView()
        taxInputView.delegate = self
        //taxInputView.activeColor = UIColor.init(red: 245.0/255, green: 106.0/255, blue: 32.0/255, alpha: 1.0)
        
        view.addSubview(taxInputView)
     
        taxInputView.frame = CGRect.init(x: 20, y: 100, width: view.frame.width - 40, height: 35)
    }
    
    func codeView(_ inputString: String) {
        print(inputString)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //codeView.registFirst()
        taxInputView.resignFirstResponder()
    }
    
    func taxInputViewCompleteInput(_ taxInputView: TaxInputView) {
        print(taxInputView.text)
    }

}

