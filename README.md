# BPushSDK-Unity3D-iOS

百度云推送 Unity 3D 第三方 iOS SDK

本文档介绍如何将百度云推送集成到 Unity 平台上，使得 iOS 平台下的 App 能够使用推送服务。

## Unity 版本要求

当前集成版本在 Unity 5.0 以上没有问题，4.x 版本未进行验证。

## 集成百度云推送 Unity3D iOS SDK

iOS 推送服务主要依赖于 Apple 自家的 APNs。开发者首先需要到 Apple 官网上为当前 App 注册推送证书，然后在客户端通过代码请求使用推送服务，用户允许后可获取一个叫 device token 的标识，用于标识这台设备。

然后就可以在服务端拿着 Apple 给你的推送证书与 APNs 建立 SSL 长连接进行消息推送，推送的消息内容称为 payload。

Payload 中包含了一条推送消息的所有信息，包括消息主体内容，这条消息要推送到的 deviceToken（设备）等。

### 制作 iOS 推送证书

有关证书制作的过程可以参考：[百度云推送 iOS 推送证书指导](http://push.baidu.com/doc/ios/api)

对于 iOS 推送的相关了解可参考：[百度云推送 iOS 推送简介](http://push.baidu.com/doc/ios/api)

### 在百度云推送官网注册 App

在使用百度云推送服务之前，还需要在官网上注册成为百度开发者并在云推送官网注册 App。注册 App 后即可进行管理该 App 的推送业务，在控制台可进行消息的推送，数据报表查看等一系列操作。

注册成功后，在控制台中上传刚才创建的开发证书和生产证书。

### 导入 SDK 到当前的 Unity 工程中

下载 Github 上 的 SDK 文件夹，将 Assets 下的 Code 文件夹直接复制到你当前 Unity 工程的 Assets 下。

将 `Assets/Plugin/IOS/`下的文件全部复制到你当前 Unity 工程中的 `Assets/Plugin/IOS/`下，因为 Unity 工程再转换到 iOS 工程时，会自动的将 `Plugin/IOS` 下的文件添加到 iOS 工程的依赖中。

#### 使用百度云推送

在上面的步骤中，我们已经正确地集成了百度云推送 Unity iOS SDK 到我们的工程中，现在介绍下如何使用 SDK 中的 API。

首先需要明白绑定和解绑的含义。

>   关于绑定和解除绑定，百度云推送的 SDK 中对应存在两条 API，即 bind 和 unbind 操作。bind 操作的实质是设备与百度的云推送服务发起请求，使得当前设备允许被推送，反之，unbind 的实质为解除当前设备的绑定，之后这台设备将不能被推送消息，除非再次绑定。
>  
>   绑定操作和解绑操作可以在程序运行的任意时期被调用，（前提是在初始化百度云推送服务时，使用了正确的 apikey 和 pushMode 参数。不过这些步骤需要在转换为 iOS 工程后进行，暂时不做）。
>  
>   常见的场景就是当用户登录后，做绑定请求，用户注销登录后，如果仍继续发送该用户相关的消息就不太合适了，这时做一次解绑操作即可。



下面是绑定与解除绑定的示例，如同前面提到的，绑定和解绑操作你可以在任何地方调用。

如同 SDK 中已经存在的 `BPushTest.cs` 脚本：

``` 
using UnityEngine;
using System.Collections;

public class BPushTest : MonoBehaviour {

	// 在脚本的初始化方法中，发起绑定请求
	void Start () {
		Debug.Log("Unity main object start");
		Debug.Log("bind channel");
		BPushSDKConector.baiduBindChannel();
		
        // 给当前设备添加一些 tags ，之后可以使用这些 tag 中的一个进行组播推送
		Debug.Log ("set tags");
		BPushSDKConector.baiduSetTags ("[\"well\",\"cheng\",\"ios\"]");
		
        // 发起解绑请求，之后将无法接收百度云推送的推送消息
		Debug.Log("unbind channel");
		BPushSDKConector.baiduUnBindChannel();
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	// recieve baidu push call back
	// 对于 SDK 的调用的结果都通过这些回调方法返回
    // 可以根据返回结果，经过判断后做一些业务相关的操作
    // 需要注意的是，这些回调方法都是通过 UnitySendMessage 方法回调，因此当前脚本绑定的 Game Object 必须名为 BPushBind
	void bindChannel(string jsonString) {
		Debug.Log ("bind: " + jsonString);
	}

	void unbindChannel(string jsonString) {
		Debug.Log ("unbindChannel: " + jsonString);
	}

	void getChannelId(string jsonString) {
		Debug.Log ("getChannelId: " + jsonString);
	}

	void listTags(string jsonString) {
		Debug.Log ("listTags: " + jsonString);
	}

	void setTags(string jsonString) {
		Debug.Log ("setTags: " + jsonString);
	}

	void delTags(string jsonString) {
		Debug.Log ("delTags: " + jsonString);
	}
}

```

对其他方法的调用也是如此，每条 API 都可以在任何时候被调用。

>   对于有返回值的方法调用，都是通过回调函数来获取返回值。BPushBind 这个标识符只是默认的设置，你也可以根据自己的需求到源码中去更改。

### 在 Unity 工程中进行配置

在导入完成之后，打开 Code 文件夹：

`BPushSDKConector.cs` 封装了所有可供 C# 调用的 API。

`BPushTest.cs`是示例文件，简单的介绍了如何使用 C# 调用百度云推送相关的接口，以及如何接收调用之后的返回值。 

将 `BPushTest.cs` 绑定到某个对象上，例如绑定到 Main Camera 或者新创建的空 Game Object，然后修改此 Game Object 的名字为 `BPushBind`

>  Unity 接收 Objective-C 的值通过 SendUnityMessage 函数实现，因此需要指定将消息发送到哪个Game Object。

### 将 Unity 工程导出为 iOS 工程

选择 `Unity -> File -> Build & settings` 打开转换窗口，选择 iOS 平台，同时勾选需要导出的 scenes，点击左下角的 Player Setting 按钮，在 `Bundle Identifier` 一项中填写注册 App 推送证书时创建的 Bundle ID。

>  这里填写的 BundleID 一定要与证书中的相对应。

然后点击 Build setting 窗口中的 build 按钮，选择保存目录以及保存为的文件夹名称即可转换完成。

### 配置导出的 iOS 工程

#### 添加集成推送所需的系统框架

SDK 运行还依赖一些系统库，需要添加到当前的 iOS 项目中。

鼠标选择当前的项目，在中间视图窗口中选择 target `Unity-iPhone`，然后在上面选择 General 栏目，往下滑动就能看到当前项目依赖的系统库，如图：

![当前 iOS 工程依赖的系统库](http://7vzucb.com1.z0.glb.clouddn.com/blog.customImage/Cocos2d/cocos-3.png)



检查 `Foundation.framework`、`CoreTelephony.framework`、`SystemConfiguration.framework` 库是否已经添加依赖。如果没有，点击下面的加号后搜索并依赖即可。

#### 设置 Library Search Path

App（target）依据 `Library search path`中的路径搜索自身依赖的库，如果这里没有设置正确，可能会发生 link 错误，具体为找不到对应的 symbol 。

在上面一步中，我们选择的是 General 栏目，现在切换到同级的 Build Setting 中，往下慢慢滑动，找到并选择 `Search Paths -> Library Search Paths`，双击右边的值，弹出选择界面，将 Unity 自动生成的路径中的 `""` 双引号去掉，否则无法编译成功。编辑之后的结果如下图所示：



#### 在 iOS 工程中添加请求开启推送功能的代码

打开当前 iOS 工程，在左侧项目导航栏中找到 `Class`文件夹并进入，选择 `AppController.mm` 文件。

在文件的应用程序初始化完成方法中添加下面的代码：

``` 
// 添加云推送 SDK 头文件
#import "BPush.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	...
	// if you wont use keyboard you may comment it out at save some memory
	[KeyboardDelegate Initialize];

  //-------------------- Push -----------------------------
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
    // 8.0
    UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  }else {
    // ~> 7.1
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
  }

  // 初始化 Push，需要注意区分 pushMode 参数，确定当前的推送环境
  [BPush registerChannel:launchOptions apiKey:@"在百度云推送官网上注册得到的 apikey" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:NO];

  return YES;
}
```

上面的方法做了一件事情，就是向系统请求开启消息推送功能，然后系统会弹出 alert 菜单询问用户是否允许此 App 进行消息推送。当用户进行处理后，iOS 8 以及之后的系统会回调下面的方法，你需要将下面的方法添加到 `AppController.mm` 文件中。

``` 
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
  // 此处可以根据 notificationSettings 参数判断应用当前所被允许的推送类型
  // 应用程序注册推送功能，以获取当前 App 的 deviceToken 
  [application registerForRemoteNotifications];
}
```

上面的方法调用后，系统将与 APNs 请求建立长连接，然后将当前 App 在该设备上的 deviceToken 回调给你。deviceToken 在 server 进行推送时，用来指定这条消息将要发送给哪台设备。

下面是获取 deviceToken 的回调方法，Unity 已经默认实现，你需要做如下修改：

``` 
// 当 deviceToken 获取成功时，系统会调用这条方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"current device token:%@",deviceToken);
    // 将 deviceToken 注册到百度云推送之后，就可以通过百度云推送进行消息推送
    [BPush registerDeviceToken:deviceToken];
}

// 当 deviceToken 获取失败时，这条方法被调用, 可以查看失败的具体原因
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"deviceToken 获取失败的原因：%@",error);
}
```



>   有一种特殊情况需要注意，有可能上面的两条方法都不会被调用，这是因为当前设备无法与 APNs 建立长连接，这时候你需要检查设备的网络状态。当 iOS 设备同时具备移动蜂窝网络和 WiFi 网络时，推送功能优先使用移动网络。

## 通过百度云推送控制台给设备进行推送

当在 Unity 中调用绑定请求并成功后，服务端会返回 channelID，标识唯一一台设备。需要在发送消息时指定 channelid 表示要发送给具体哪一台设备。

使用百度云推送进行消息推送时，一种是使用官网提供的控制台，另一种是使用官方提供的 server 端 API。相关的信息都可以在官网的文档中了解到：[百度云推送管理控制台](http://push.baidu.com/doc/console/guide)

## Trouble shooting

这里主要对一些常见问题进行说明，也欢迎各位提  issue。

百度云推送官网上已经有了一些相关的 issue ，[百度云推送 issue](http://push.baidu.com/issue/list/hot)

