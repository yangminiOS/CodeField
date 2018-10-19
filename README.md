# CodeField
常见的验证码输入组件

1. 支持位验证码

2. 可以自定义验证码数量、item宽度

3. 代理方法返回输入内容，在输入完成后



###简单使用
```
//初始化方法
taxInputView = TaxInputView()
taxInputView.delegate = self
view.addSubview(taxInputView) 
taxInputView.frame = CGRect.init(x: 20, y: 100, width: view.frame.width - 40, height: 35)


//代理方法

 @objc optional func taxInputViewDidChange(_ taxInputView: TaxInputView)
    
 @objc optional func taxInputViewBeginInput(_ taxInputView: TaxInputView)
    
 @objc optional func taxInputViewEndInput(_ taxInputView: TaxInputView)
    
 @objc optional func taxInputViewCompleteInput(_ taxInputView: TaxInputView)
```

