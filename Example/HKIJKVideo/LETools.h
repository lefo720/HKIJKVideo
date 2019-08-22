//
//  LETools.h
//  AFNetworking
//
//  Created by Lefo on 2019/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LETools : NSObject

/**
 判断字符串

 @param string String
 @return @"" || String
 */
NSString * checkNullStr(NSString *string);

/**
 将Dic中的"<null>"转换为@""

 @param myDic Dictionary
 @return Dictionary
 */
NSDictionary * checkNullDic(NSDictionary *myDic);

/**
 将Array中的"<null>"转换为""

 @param myArr Array
 @return Array
 */
NSArray * checkNullArr(NSArray *myArr);

@end

NS_ASSUME_NONNULL_END
