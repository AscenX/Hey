# Hey

这是我的毕业设计。
刚开始确定这个课题的时候是因为以前有稍微研究过一些XMPP协议，在这个基础上做起来应该不难。然后开始选技术的时候还有半年，我想为什么不从更底层做起呢！那就不用XMPP，当时接触过相关的即时通讯技术还有WebSocket，那为什么直接从更底层的Socket开始封装呢
服务端就用Go语言吧，用来做IM服务器和HTTP服务器都很好。


### 技术选型

既然是基于Socket，iOS端我并不准备中C语言的Socket开发封装起，而是使用一个第三方库[CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket)。XMPP的iOS framework也是从这个库开始封装。而Go语言的IM服务端则直接使用原生开发即可，无论是UDP还是TCP都已经封装的很好。

HTTP服务器使用的框架是[Gin](https://github.com/gin-gonic/gin)，已经相当成熟，可以用于大型服务端的开发了。

关于传输的数据格式，XMPP使用的是XML，但是体积太大，冗余过多不必要的数据，考虑了很久好像也没必要自己封装二进制的数据格式，我用的是Google的protocol buffer。HTTP服务器还是使用JSON。

我还需要存储客户端的IP地址，由于需要快速读写，我使用的是[Redis](https://redis.io/)。

AccessToken验证方式使用的是[JSON Web Token](https://jwt.io/)（JWT)


### 实现思路

我的想法是使用UDP Socket来传输数据，至于为什么使用UDP呢，一开始的想法是UDP比TCP快，虽然可能会丢包但是可以试着优化。关于使用UDP来做IM这个想法也被一些大神喷过，但是这都是我自己的想法，就这样做着先。

使用UDP会丢包，所以我想需要一个回执机制，接收端收到了消息后就给发送端发送一个回执，这个回执包括这条消息的ID，如果发送方过一段时间还没有接受到回执的时候则重新发送。而且这个回执还不能丢，所以我使用TCP来发送回执。

UDP是无连接性的，还是要使用TCP来连接服务端，表明登录状态。所以TCP的作用是连接和发送回执。

具体思路是当客户端登录和重新连接的时候，客户端使用UDP Socket绑定端口，然后使用TCP Socket来发送UDP 地址给服务端，服务端把用户的ID和UDP地址存进Redis，等发送方发送的消息包含接收端的用户ID，服务端再从Redis取出接收方的UDP地址进行转发。

发送图片我是这样实现的，我会把图片上传到七牛云，发图片的URL来发送，接收端只需要使用URL来加载图片即可


### 架构

关于整个APP的流程如下

![](http://7xsnb0.com1.z0.glb.clouddn.com/2017-06-23-072550.jpg)

关于iOS端，使用了MVVM设计模式结合RAC，在Controller里面只需要组合一下视图和布局，绑定数据即可，把处理数据和大部分逻辑都放在了ViewModel里面，结构还算清晰。

关于数据管理，我使用了一个Redux思想的全局数据调度中心，实现了单向数据流，数据的持久化等。数据持久化用到了FMDB。但是大部分代码是一个大神写的，很屌。

### 效果和下一步

目前实现传输文字和图片，好友添加还是在后台添加（前端还没做），动态模块等。

登录
![](http://7xsnb0.com1.z0.glb.clouddn.com/2017-06-23-073418.jpg)

通讯录
![](http://7xsnb0.com1.z0.glb.clouddn.com/2017-06-23-073437.jpg)

详细资料
![](http://7xsnb0.com1.z0.glb.clouddn.com/2017-06-23-073506.jpg)

个人资料
![](http://7xsnb0.com1.z0.glb.clouddn.com/2017-06-23-073521.jpg)

聊天界面
![](http://7xsnb0.com1.z0.glb.clouddn.com/2017-06-23-073758.jpg)


### 感谢一下开源技术

- SDAutoLayout
- YYWebImage
- ReactiveObjC
- AFNetworking
- Protobuf
- CocoaAsyncSocket
- Qiniu
- UICKeyChainStore
- TZImagePickerController
- SVProgressHUD
- DateTools
- MLEmojiLabel
- MJRefresh
- Mantle
- FMDB
- FMDBMigrationManager
- MTLFMDBAdapter

