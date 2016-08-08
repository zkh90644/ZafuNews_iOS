# ZafuNews_iOS
---
- 数据来源：来自 http://news.zafu.edu.cn/ 通过Ji对数据进行解析。
- 使用第三方库：
	- CoreTabPage，自行封装的页面切换框架，详情可见[这里](https://github.com/zkh90644/coreTabPage)
	- SnapKit，AutoLayout的封装库，主要用于多机型界面的匹配
	- SQLite.swift，数据持久层框架
	- Alamofire，网络层框架
	- AlamofireImage，图片加载框架（是Alamofire的extension）
	- SwiftyJSON，Ji，数据解析框架（Ji用于抓取到的内容信息，SwiftJSON用于解析天气返回的JSON数据）
	- SwiftQRCode，二维码生成框架
	- ESPullToRefresh，（UITableView的extension）下拉刷新，上拉加载
	- 友盟统计、分享等第三方框架SDK
	
效果图：
