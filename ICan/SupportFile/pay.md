#  支付文档

## 调起我行支付
## 原APP通过调用下面的URL可以唤起我行APP 
#### 参数说明  
payId 是你APP向你们后台获取到的订单支付ID 例如是88888888888
fromScheme 需要在你的APP的URLScheme 添加一个Scheme 用来支持我行APP在支付结束后 把支付结果通知到原APP（这个Scheme可以随意生成最好保持唯一性 例如icanmall）
```
icanchat://pay?type=pay&payId=88888888888&fromScheme=icanmall
```
## 支付结果回传
#### 参数说明
icanmall：原APP添加的Scheme
payId： 原APP传过来的订单支付ID
status： 0 支付失败 1 支付成功  2用户点击了取消按钮（这个情况不做处理） 
### 特别说明原APP收到之后做一个URL解码 才可以显示errorMsg  这个也可以根据status APP做具体的逻辑跳转或提示
```
icanmall://pay?type=pay&payId=88888888888&status=2&errorMsg=用户点击取消支付按钮
```
