## 一、为什么要创建PisenKit项目
* <font color=black size=4>不重复造轮子</font>

> 项目之间、团队之间可以共享代码，减少不必要的重复劳动，提高开发效率。

* <font color=black size=4>技术沉淀</font>

> 让每一次的项目开发都有收获！养成经常思考、整理、优化代码的习惯，沉淀的不仅仅是代码量，更重要的是技术和经验！

* <font color=black size=4>提升公司软实力</font>

> 该公共库版权属于品胜公司，由iOS开发团队共同打造，待时机成熟后可以共享到开源平台，提升公司iOS开发团队的形象。
	
## 二、PisenKit维护规范

### 0. 提交代码流程

所有新功能代码都统一提交到develop分支，等稳定后再合并到master。即master只处理develop提交的合并请求，绝不处理其它分支提交的合并！其它开发中的项目如果要引用该库，请直接使用master！

#### 方法一：Fork + Merge Request（推荐）
优点：绝对不会出现重名的feature分支名。

第①步：识别可加入基础业务库的代码

第②步：fork当前源码到自己账户下，并clone到本地

	git clone http://192.168.27.208:8181/USER_NAME/iOS.PisenKit.git

第③步：切换到develop分支 

	git checkout develop   
	
第④步：规范化代码的命名、注释等信息，并根据功能放入合适的文件夹中

第⑤步：抽象出配置信息并统一规范入口

第⑥步：如果加入第三方库代码，必须写好对应的适配器，方便以后随时替换相同功能的第三方库

第⑦步：在demo中添加新功能的测试用例

第⑧步：将develop分支推送到服务器 

	git push origin develop

第⑨步：提交合并到源项目develop分支的请求（merge request），合并完成后会自动删除临时分支。


#### 方法二：在当前项目中提交
缺点：容易出现重名的feature分支名。

第①步：识别可加入基础业务库的代码

第②步：拉取项目源码 

	git clone http://192.168.27.208:8181/iOS/iOS.PisenKit.git

第③步：首先切换到develop分支 

	git checkout develop   
		
再新建功能分支 

	git branch feature_name

第④步：规范化代码的命名、注释等信息，并根据功能放入合适的文件夹中

第⑤步：抽象出配置信息并统一规范入口

第⑥步：如果加入第三方库代码，必须写好对应的适配器，方便以后随时替换相同功能的第三方库

第⑦步：在demo中添加新功能的测试用例

第⑧步：将新功能分支feature_name推送到服务器 

	git push origin feature_name

第⑨步：提交合并到develop分支的请求（merge request）
	
### 1. 维护时必须遵守的原则

为了不让PisenKit成为一个简单的代码容器，同时保证在代码不断增加的过程中不会影响库的稳定性、易用性、扩展性，因此在加入代码时务必遵守以下原则：

#### 业务无关性
> 保证在不修改任何源码的情况下直接适用于别的项目。

#### 代码原创性
> 鼓励创造更好的轮子。禁止直接将第三方代码甩进去的流氓行为！允许将常用的基础功能代码在规范化（命名、格式化、统一用法、注释）后加入基础库，或者只添加适配器代码调用第三方库。

#### 用法统一性
> 将封装好的功能提供统一风格的对外接口。比如参数配置的方式采用Delegate、Block、单例对象、Category重新同名方法、链式编程等。

#### 功能独立性
> 封装的功能尽量单一，减少对平级功能的依赖，目的是保证功能块能随时被更好的方案替换。

####功能可靠性
> 通过编写白盒测试用例来确保功能的可靠性。

### 2. 命名规范
* 目录结构

		- PisenKit.h		存放PisenKit常用模块的引用
		- PSKConstants.h	存放PisenKit中用到的常量、Block、枚举等的定义
		- PSKMacros.h		存放PisenKit中常用的宏定义，最主要是代码段简写
		+ PSKAdapter		统一管理第三方代码的适配器
			- PSKAdapter.h      常用适配器的引用
			+ PSKHUD            封装对MBProgressHUD调用的适配器
			+ PSKModel          封装对MJExtension调用的适配器
			+ PSKNetworking     封装对AFNetworking调用的适配器
			+ PSKWebImage       封装对SDWebImage调用的适配器
		+ PSKBase			对系统类的扩展
			- PSKBase.h			常用系统类扩展的引用
			+ Category          分类方式扩展系统库
				+ Foundation         扩展Foundation.framework中的常用库
				+ UIKit              扩展UIKit.framework中的常用库
			+ Inherit           继承方式扩展系统库
		+ PSKSingleton		单例类
		+ PSKUtils			静态方法类
		+ PSKView           自定义view
		+ PSKViewController viewController基类

		+ Demo              对基础库进行单元测试、功能演示的demo项目
		+ UnMerged          未合并的代码

* 类名
		
		1. 自定义类命名规范：PSKXxxxx
		2. category类命名规范：SYSTEM_CLASS (PisenKit)
		3. 封装静态方法的类：PSKXxxxUtil、PSKXxxxHelper
		4. 单例类：PSKXxxxManager

* 方法名

		1. 创建单例的标准代码：
		+ (instancetype)sharedInstance {
			static dispatch_once_t pred = 0;
			__strong static id _sharedObject = nil;
			dispatch_once(&pred, ^{
				_sharedObject = [[self alloc] init];
			});
			return _sharedObject;
		}
		2. 私有方法前面加下划线’_’ 
		3. category方法前必须有前缀’psk_’

* 文件头注释

		必不可少的要素：类名、包名、作者、创建日期、版权信息。如:
		//
		//  PSKXxxx.m
		//  PisenKit
		//
		//  Created by AUTHOR on DATE.
		//  Copyright © 2016年 pisen. All rights reserved.

### 3. 版本管理
* master
		
		规范、稳定、可靠的代码库，在master上打tag
		
* develop
		
		当前项目的开发分支，待项目完成后合并到master

### 4. 子模块的用法
添加子模块 

	git submodule add http://192.168.27.208:8181/software-department-2/iOS.PisenKit.git TARGET_PATH

初始化子模块

	git submodule init
	git submodule update
	
更新子模块 

	git submodule foreach git pull --rebase
	
## 三、注释规范

为了更好兼容工具appledoc或doxygen以自动生成文档，在书写注释时注意使用以下命令：

		/**
		 * @brief 带字符串参数的方法.
		 *
		 * 详细描述或其他.
		 * 
		 * @param  value1 值.
		 * @param  value2 值.
		 *
		 * @return 返回value.
		 *
		 * @exception NSException 可能抛出的异常.
		 * 
		 * @see someMethod
		 * @warning 警告: appledoc中显示为蓝色背景, Doxygen中显示为红色竖条.
		 * @bug 缺陷: appledoc中显示为黄色背景, Doxygen中显示为绿色竖条.
		 */ 
		 
* 注释中添加实例代码：

		/**
 		 * 示例代码:
		 *
		 *		int sum = 0;
		 * 		for(int i= 0; i < 10; i++) {
		 *     	sum += i;
		 * 		}
		 */
		 
* 带参数的宏注释：

		/**
		 * @brief	最小值 （参数宏, 仅Doxygen）.
		 *			
		 * 详细描述或其他.
		 * 
		 * @param     a     值a.
		 * @param     b     值b.
		 *
		 * @return    返回两者中的最小值.
		 */
		#define min(a,b)    ( ((a)<(b)) ? (a) : (b) )
		
* 函数指针与块函数注释：

		/**
		 * @brief    动作块函数.
		 *
		 * 详细描述或其他.
		 * 
		 * @param     sender     发送者.
		 * @param     userdata     自定义数据.
		 */
		typedef void (^ActionHandler)(id sender, id userdata);

* 无序列表：

		/**
		 * 无序列表:
		 *
		 * - abc
		 * - xyz
		 * - rgb
		 */

* 有序列表：

		/**
		 * 有序列表:
		 *
		 * 1. first.
		 * 2. second.
		 * 3. third.
		 */


* 多级列表：

		/**
		 * 多级列表:
		 *
		 * - xyz
		 *    - x
		 *    - y
		 *    - z
		 * - rgb
		 *    - red
		 *        1. first.
		 *            1. alpha.
		 *            2. beta.
		 *        2. second.
		 *        3. third.
		 *    - green
		 *    - blue
		 */

* 添加链接：
	
		/**
 		 * [Doxygen](http://www.stack.nl/~dimitri/doxygen/)
 		 */
	
	
## 四、调用第三方库的代码如何加入PisenKit

注意几点：
> 1. 加入的第三方库随时可以替换但不能修改调用方的代码
> 
> 2. 通过Adapter模式解耦第三方库的调用方式
> 
> 3. 有两种适配方式：对象适配(封装实例化对象)、类适配(继承)
> 
> 4. PSKXxxAdapterManager负责创建Adapter;PSKXxxxAdapter负责调用第三方库的代码

下面举例说明：


