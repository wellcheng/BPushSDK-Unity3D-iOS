//
//  BPushSdkConector.h
//  UnityConnect
//
//  Created by WellCheng on 15/11/17.
//  Copyright © 2015年 chengwei06. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPushSdkConector : NSObject
- (void)bindChannel;
- (void)unbindChannel;
- (void)getChannelId;
- (void)getAppId;
- (void)listTags;
- (void)setTags:(NSString *)tagJsonString;
- (void)delTags:(NSString *)tagJsonString;
@end
