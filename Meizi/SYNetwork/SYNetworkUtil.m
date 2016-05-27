//
//  SYNetworkUtil.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/24.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYNetworkUtil.h"
#import "SYBaseRequest.h"

void SYNetworkLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation SYNetworkUtil

+ (NSString *)md5StringWithString:(NSString *)string {
    if(string == nil || [string length] == 0) {
        return nil;
    } else {
        const char *value = [string UTF8String];
        unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
        NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
            [outputString appendFormat:@"%02x",outputBuffer[count]];
        }
        return outputString;
    }
}

+ (NSString *)methodStringWithRequest:(SYBaseRequest *)request {
    switch (request.requestMethod) {
        case SYRequestMethodGET:
            return @"GET";
            break;
        case SYRequestMethodPOST:
            return @"POST";
            break;
        case SYRequestMethodPUT:
            return @"PUT";
            break;
        case SYRequestMethodDELETE:
            return @"DELETE";
            break;
        case SYRequestMethodHEAD:
            return @"HEAD";
            break;
        case SYRequestMethodPATCH:
            return @"PATCH";
            break;
        default:
            return nil;
            break;
    }
}

+ (NSString *)parameterStringWithRequest:(SYBaseRequest *)request {
    id parameters = request.requestParameters;
    if ([parameters isKindOfClass:[NSDictionary class]] || [parameters isKindOfClass:[NSArray class]]) {
        NSError *error = nil;
        NSData *parametersData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            return [[NSString alloc] initWithData:parametersData encoding:NSUTF8StringEncoding];
        } else {
            return nil;
        }
    } else if ([parameters isKindOfClass:[NSString class]]) {
        return parameters;
    } else {
        return nil;
    }
}

+ (BOOL)isValidateJSONObject:(id)jsonObject withJSONObjectValidator:(id)jsonObjectValidator {
    if ([jsonObject isKindOfClass:[NSDictionary class]] && [jsonObjectValidator isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = jsonObject;
        NSDictionary *validator = jsonObjectValidator;
        BOOL result = YES;
        NSEnumerator *enumerator = [validator keyEnumerator];
        NSString *key = nil;
        while ((key = [enumerator nextObject]) != nil) {
            id value = dictionary[key];
            id format = validator[key];
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                result = [self isValidateJSONObject:value withJSONObjectValidator:format];
                if (!result) {
                    break;
                }
            } else {
                if ([value isKindOfClass:format] == NO && [value isKindOfClass:[NSNull class]] == NO) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    } else if ([jsonObject isKindOfClass:[NSArray class]] && [jsonObjectValidator isKindOfClass:[NSArray class]]) {
        NSArray *validatorArray = jsonObjectValidator;
        if (validatorArray.count > 0) {
            NSArray *array = jsonObject;
            NSDictionary *validator = jsonObjectValidator[0];
            for (id item in array) {
                BOOL result = [self isValidateJSONObject:item withJSONObjectValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([jsonObject isKindOfClass:jsonObjectValidator]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)cacheKeyWithRequest:(SYBaseRequest *)request {
    NSString *methodString = [SYNetworkUtil methodStringWithRequest:request];
    NSString *prarameterString = [SYNetworkUtil parameterStringWithRequest:request];
    NSString *parameterMD5String = [SYNetworkUtil md5StringWithString:prarameterString]?:@"";
    return [NSString stringWithFormat:@"%@:%@:%@", methodString, request.requestURLString, parameterMD5String];
}

@end
