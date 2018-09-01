# CodeField
常见的验证码输入组件

1. 支持1-6位验证码

2. 可以自定义验证码数量、item宽度

3. 代理方法返回输入内容，在输入完成后



###简单使用
```
//初始化方法
count:确定验证码的数量 最小1位  最多6位，可以做修改 
with:codeField的宽度  宽度会有默认值 不得小于30

let testView = YMCodeView.init(count: 6, with: 30.0)

//代理
testView.delegate = self

//代理方法
func codeView(_ inputString: String) {
        print(inputString)
 }

```
