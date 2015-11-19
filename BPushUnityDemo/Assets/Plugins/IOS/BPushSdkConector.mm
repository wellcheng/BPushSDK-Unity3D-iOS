//
//  BPushSdkConector.m
//  UnityConnect
//
//  Created by WellCheng on 15/11/17.
//  Copyright © 2015年 chengwei06. All rights reserved.
//

#import "BPushSdkConector.h"
#import "BPush.h"
#import "BPushErrorHandle.h"

// define the custom method for Unity
#if defined(__cplusplus)
extern "C" {
#endif
    /**
     *  objective-C 调用 Unity 中的函数
     *
     *  @param className  类名，指 Unity 场景中哪一个 Game Object 接收方法的调用
     *  @param methodName 方法名，调用 Game Object 的哪一个方法
     *  @param param      传入的参数
     */
    void UnitySendMessage( const char * className, const char * methodName, const char * param );
    
    /**
     *  将 CString 类型的字符串转换为 NSString 类型
     *
     *  @param string 需要转换的字符串内容
     *
     *  @return 返回 NSString 类型的字符串
     */
    extern NSString* _CreateNSString(const char *string);
#if defined(__cplusplus)
}
#endif


#if defined(__cplusplus)
extern "C" {
#endif
    /**
     *  将 CString 类型的字符串转换为 NSString 类型
     */
    NSString * CreateNSString(const char *string) {
        if (string) {
            return [NSString stringWithUTF8String:string];
        } else {
            return @"";
        }
    }
    
    /**
     *  当前类的实例，用于 Objective-C 和 Unity 相互调用的桥接
     */
    static BPushSdkConector *_sdkConector = nil;
    
    //  供 Unity 3D 调用的方法 ，Unity can invoke follow interface for iOS SDK
    /**
     *  向百度云推送服务器绑定当前设备，使该设备可以接受推送消息
     */
    void bindChannel() {
        if (!_sdkConector) {
            _sdkConector = [[BPushSdkConector alloc] init];
        }
        [_sdkConector bindChannel];
    }
    
    /**
     *  向百度云推送服务器请求解除当前设备，使该设备无法接收推送消息
     */
    void unbindChannel() {
        if (!_sdkConector) {
            _sdkConector = [[BPushSdkConector alloc] init];
        }
        [_sdkConector unbindChannel];
    }
    
    /**
     *  获取当前设备的 channelid，此值唯一标识一台设备，用于在百度云服务端进行消息推送时指定设备
     */
    void getChannelId() {
        if (!_sdkConector) {
            _sdkConector = [[BPushSdkConector alloc] init];
        }
        [_sdkConector getChannelId];
    }
    
    /**
     *   获取在百度云推送服务器上注册的 appid ，可用于查看当前设备的推送功能归属在哪个 app 下
     */
    void getAppId() {
        if (!_sdkConector) {
            _sdkConector = [[BPushSdkConector alloc] init];
        }
        [_sdkConector getAppId];
    }
    
    /**
     *   显示当前设备所有已经绑定的 tag
     */
    void listTags() {
        if (!_sdkConector) {
            _sdkConector = [[BPushSdkConector alloc] init];
        }
        [_sdkConector listTags];
    }
    
    /**
     *   向百度云推送发送设置 tag 的请求，设置成功后该设备将绑定指定的 tag，且该设备将能收到对应 tag 的组播推送
     *
     *  @param tagsJsonString: tag 数组的 json 字符串, 数组元素为字符串类型
     */
    void setTags(const char *tagsJsonString) {
        if (!_sdkConector) {
            _sdkConector = [[BPushSdkConector alloc] init];
        }
        [_sdkConector setTags:CreateNSString(tagsJsonString)];
    }
    
    /**
     *  向百度云推送发送删除 tag 的请求，设置成功后该设备将删除指定的 tag，且该设备将不再收到对应 tag 的组播推送
     *
     *  @param tagsJsonString tag 数组的 json 字符串, 数组元素为字符串类型
     */
    void delTags(const char *tagsJsonString) {
        if (!_sdkConector) {
            _sdkConector = [[BPushSdkConector alloc] init];
        }
        [_sdkConector delTags:CreateNSString(tagsJsonString)];
    }
    
    
#if defined(__cplusplus)
}
#endif


@implementation BPushSdkConector
/**
 *  Objective-C 通过此接口发送数据给 Unity
 *
 *  @param messageName 方法名
 *  @param dict        数据字典
 */
+ (void)sendU3dMessage:(NSString *)messageName jsonParam:(NSString *)jsonString {
    UnitySendMessage("BPushBind", [messageName UTF8String], [jsonString UTF8String]);
}

//- (void)SDKInit {
//    // TODO: init
//
//}

- (void)bindChannel {
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        NSString *jsonString = [BPushErrorHandle errorHandleWithResult:result error:error];
        [BPushSdkConector sendU3dMessage:NSStringFromSelector(@selector(bindChannel)) jsonParam:jsonString];
    }];
}

- (void)unbindChannel {
    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
        NSString *jsonString = [BPushErrorHandle errorHandleWithResult:result error:error];
        [BPushSdkConector sendU3dMessage:NSStringFromSelector(@selector(unbindChannel)) jsonParam:jsonString];
    }];
}

- (void)getChannelId {
    NSString *jsonString = [BPushErrorHandle errorHandleWithString:[BPush getChannelId]];
    [BPushSdkConector sendU3dMessage:NSStringFromSelector(@selector(getChannelId)) jsonParam:jsonString];
}

- (void)getAppId {
    NSString *jsonString = [BPushErrorHandle errorHandleWithString:[BPush getAppId]];
    [BPushSdkConector sendU3dMessage:NSStringFromSelector(@selector(getAppId)) jsonParam:jsonString];
}

- (void)listTags {
    [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
        NSString *jsonString = [BPushErrorHandle errorHandleWithResult:result error:error];
        [BPushSdkConector sendU3dMessage:NSStringFromSelector(@selector(listTags)) jsonParam:jsonString];
    }];
}

- (void)setTags:(NSString *)tagJsonString {
    [BPush setTags:[tagJsonString JSONValue] withCompleteHandler:^(id result, NSError *error) {
        NSString *jsonString = [BPushErrorHandle errorHandleWithResult:result error:error];
        [BPushSdkConector sendU3dMessage:NSStringFromSelector(@selector(setTags)) jsonParam:jsonString];
    }];
}

- (void)delTags:(NSString *)tagJsonString {
    [BPush delTags:[tagJsonString JSONValue] withCompleteHandler:^(id result, NSError *error) {
        NSString *jsonString = [BPushErrorHandle errorHandleWithResult:result error:error];
        [BPushSdkConector sendU3dMessage:NSStringFromSelector(@selector(delTags)) jsonParam:jsonString];
    }];
}

@end
