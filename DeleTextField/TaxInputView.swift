//
//  TaxInputView.swift
//  AKCreditScore
//
//  Created by WangChongyang on 2018/6/19.
//

import UIKit

@objc protocol TaxInputViewDelegate {
    
    @objc optional func taxInputViewDidChange(_ taxInputView: TaxInputView)
    
    @objc optional func taxInputViewBeginInput(_ taxInputView: TaxInputView)
    
    @objc optional func taxInputViewEndInput(_ taxInputView: TaxInputView)
    
    @objc optional func taxInputViewCompleteInput(_ taxInputView: TaxInputView)
    
}

class TaxInputView: UIView, UIKeyInput {
    
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private var _keyboardType: UIKeyboardType?
    
    var keyboardType: UIKeyboardType {
        
        get { return .numberPad }
        
        set {}
        
    }
    
    private lazy var numberSet = CharacterSet(charactersIn: "0123456789").inverted
    
    var taxNum: Int = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var gapWidth: CGFloat = 30 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var textAttr: [NSAttributedStringKey: Any] {
        return [.font : font, .foregroundColor: textColor]
    }
        
    private lazy var cursorAnimation: CABasicAnimation = {
       
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue = 1.0
        
        animation.toValue =  0.0
        
        animation.autoreverses = true
        
        animation.duration = 0.5
        
        animation.repeatCount = MAXFLOAT
        
        animation.isRemovedOnCompletion = false
        
        animation.fillMode = kCAFillModeForwards
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        return animation
        
    }()
    
    private let cursorView = UIView()
    
    private var _font: UIFont?
    
    private var _textColor: UIColor?
    
    private var _activeColor = UIColor.init(red: 255.0/255, green: 153.0/255, blue: 51/255, alpha: 1.0)
    
    private var _defaultColor = UIColor.black  //UIColor.init(red: 239.0/255, green: 239.0/255, blue: 244.0/255, alpha: 1.0)
    
    var font: UIFont {
        
        get {
            return _font ?? UIFont.systemFont(ofSize: 14)
        }
        
        set {
            _font = newValue
        }
        
    }
    
    var textColor: UIColor {
        
        get {
            return _textColor ?? .black
        }
        
        set {
            _textColor = newValue
        }
        
    }
    
    var activeColor: UIColor {
        
        get {
            return _activeColor
        }
        
        set {
            
            _activeColor = newValue
            
            cursorView.backgroundColor = newValue
            
        }
        
    }
    
    var text = ""
    
    weak var delegate: TaxInputViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        cursorView.backgroundColor = activeColor
        
        cursorView.layer.add(cursorAnimation, forKey: "cursor")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        delegate?.taxInputViewBeginInput?(self)
        setNeedsDisplay()
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        delegate?.taxInputViewEndInput?(self)
        setNeedsDisplay()
        return super.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isFirstResponder {
            becomeFirstResponder()
        }
    }
    
    // MARK: UIKeyInput
    var hasText: Bool {
        return text.count > 0
    }
    
    func insertText(_ text: String) {
        
        if self.text.count < taxNum  {
            
            let aText =  text.components(separatedBy: numberSet).joined(separator: "")
            
            if text == aText {
                
                self.text.append(text)
                
                delegate?.taxInputViewDidChange?(self)
                
                if self.text.count == taxNum {
                    delegate?.taxInputViewCompleteInput?(self)
                }
                
                setNeedsDisplay()
                
            }
            
        }
        
    }
    
    func deleteBackward() {
        
        if text.count > 0 {
            
            text.removeLast()
            
            delegate?.taxInputViewDidChange?(self)
            
            setNeedsDisplay()
            
        }
        
    }
    
    // MARK: draw
    override func draw(_ rect: CGRect) {
        
        cursorView.removeFromSuperview()
        
        let height = rect.height
        
        let rectWidth: CGFloat = 30.0
        
        let y = height - 0.5
        
        let color = _defaultColor.cgColor
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(0.5)
        context?.setFillColor(color)
        
        var startPoint: CGPoint
        
        var endPoint: CGPoint
        
        let characterCount = text.count
        
        for i in 0..<taxNum {
            
           
                
            startPoint = CGPoint(x: CGFloat(i) * (rectWidth + gapWidth), y: y)
            
            endPoint = CGPoint(x: startPoint.x + rectWidth, y: y)
            
            
            if isFirstResponder {
                
                context?.setStrokeColor(characterCount == i ? activeColor.cgColor : color)
                
                // 当文字个数小于最大值时添加光标
                if characterCount < taxNum {
                    
                    let x = rectWidth / 2 + CGFloat(characterCount) * (rectWidth + gapWidth)
                    
                    cursorView.frame = CGRect(x: x, y: 8, width: 2, height: height - CGFloat(16))
                    
                    addSubview(cursorView)
                    
                }
                
            }else {
                
                context?.setStrokeColor(color)
                
            }
            
            context?.move(to: startPoint)
            
            context?.addLine(to: endPoint)
            
            context?.drawPath(using: .stroke)
            
            // 绘制文字
            if characterCount > 0, i < characterCount {
                
                let idx = text.index(text.startIndex, offsetBy: i)
                let str = String(text[idx]) as NSString
                
                var drawIndex = i
                
                if drawIndex >= 9, drawIndex < taxNum {
                    drawIndex = drawIndex + 1
                }
                
                let strSize = str.size(withAttributes: textAttr)
                
                let x = CGFloat(drawIndex) * (rectWidth + gapWidth) + (rectWidth - strSize.width) / 2
                let rect = CGRect(x: x, y: 8, width: strSize.width, height: height - CGFloat(16))
                
                str.draw(in: rect, withAttributes: textAttr)
                
            }
            
        }
        
    }
    
}
