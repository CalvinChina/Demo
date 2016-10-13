# YSCKit
- 以控件的形式封装大量的"胶水代码"，减少业务层的处理逻辑，同时暴露足够多的配置点来保证控件的灵活性。如YSCTextField、YSCTableView
- 推荐所有的UI都用XIB进行布局(不到万不得已不用代码创建UI控件)
- 终极目标：让Control层的核心业务逻辑不被大量的“胶水代码”和其它各种小逻辑所淹没

## Directory Structure
&nbsp;YSCKit            根目录<br/>
&nbsp;&nbsp;&nbsp;&nbsp;|__Categories   分类目录，扩展常用的系统类<br/>
&nbsp;&nbsp;&nbsp;&nbsp;|__External     第三方库目录<br/>
&nbsp;&nbsp;&nbsp;&nbsp;|__Helper       单例类和公共方法类目录<br/>
&nbsp;&nbsp;&nbsp;&nbsp;|__Model        模型基类目录<br/>
&nbsp;&nbsp;&nbsp;&nbsp;|__Views        常用view控件<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|__BaseView    基类view<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|__YSCControls 扩展系统控件功能<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|__YSCCustomViews  自定义view<br/>
&nbsp;&nbsp;&nbsp;&nbsp;|__ViewControllers        常用ViewController控件<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|__Base  基类ViewController<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|__YSCPhotoBrowseViewController  可无限浏览图片的图片查看器<br/>

## Summary
- 封装了APP开发过程中常用的功能，包括：网络请求、模型映射、本地缓存策略、宏定义、枚举类型、emoji表情符号等。
- 自定义了几个非常有用的view：
  * YSCInfiniteLoopView: 无限循环浏览，如banner展示
  * YSCTipsView：显示空列表/页面的提示信息
  * YSCPickerView：时间、日期、多维数组选择器
  * YSCTitleBarView：自定义导航条
  * YSCZoomScrollView：可缩放的图片浏览页，用于图片浏览器
  * YSCTextField：可在xib上设置数据的格式，自动检测键盘的类型、长度、以及合法性
  * YSCTextView：除了基本功能和YSCTextField类似以外，还能动态显示剩余字符数
  * YSCTableView：封装了列表的常用操作，支持<br/>
    (1). 多section的上拉加载更多、下拉刷新<br/>
    (2). GET、POST<br/>
    (3). 列表为空的提示信息<br/>
    (4). cell左右边界设置<br/>
    (5). 对数据进行缓存<br/>
    (6). 自定义任意单一确定的数据源<br/>
    (7). 动态设置header、cell、footer的高度<br/>
    (8). 支持多种header、cell、footer的注册<br/>
    (9). 兼容外部数据源(前提是必须和列表数据源类型一致)<br/>
    
## How to install
  git submodule add https://github.com/yangshengchaoios/YSCKit.git YOURPROJECT/YSCKit

## Demo
见 [YSCKitDemo](https://github.com/yangshengchaoios/YSCKitDemo)

## TODO

