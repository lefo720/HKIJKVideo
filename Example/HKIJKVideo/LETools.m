//
//  LETools.m
//  AFNetworking
//
//  Created by Lefo on 2019/8/14.
//

#import "LETools.h"

@implementation LETools

NSString * checkNullStr(NSString *string)
{
    
    return checkValue(string);
}

NSDictionary * checkNullDic(NSDictionary *myDic)
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = checkValue(obj);
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
    
}



//将NSDictionary中的Null类型的项目转化成@""
NSArray * checkNullArr(NSArray *myArr)
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        obj = checkValue(obj);
        [resArr addObject:obj];
    }
    return resArr;
}





id checkValue(id myObj)
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return checkNullDic(myObj);
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return checkNullArr(myObj);
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return myObj;
    }
    else if(myObj == [NSNull null] )
    {
        return @"";
    }
    return myObj;
}



@end
