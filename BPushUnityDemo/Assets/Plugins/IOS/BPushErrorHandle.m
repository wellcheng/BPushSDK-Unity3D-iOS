//
//  BPushErrorHandle.m
//  HelloWorldDemo
//
//  Created by WellCheng on 15/10/13.
//
//

#import "BPushErrorHandle.h"

@implementation BPushErrorHandle


+ (NSString *)errorHandleWithResult:(id)result error:(NSError *)error {
    NSString *jsonString = nil;
    if (error) {
        jsonString = [@{@"error":[error localizedDescription]} bv_jsonStringWithPrettyPrint:NO];
    }else {
        jsonString = [(NSDictionary *)result bv_jsonStringWithPrettyPrint:NO];
    }
    return jsonString;
}
+ (NSString *)errorHandleWithString:(NSString *)string {
    NSString *jsonString = nil;
    if (!string || [string isEqualToString:@""]) {
        // 值不存在或者为空
        jsonString = [@{@"error": @"result does not exist or is empty"} bv_jsonStringWithPrettyPrint:NO];
    }else {
        jsonString = [@{@"result": string} bv_jsonStringWithPrettyPrint:NO];
    }
    return jsonString;
}
@end
