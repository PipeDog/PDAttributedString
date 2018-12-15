//
//  NSString+PDRanges.h
//  PDAttributedString
//
//  Created by liang on 2018/12/15.
//  Copyright © 2018 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PDRanges)

// By String
- (NSArray<NSValue *> *)rangesByOnceMatchString:(NSString *)aString;
- (NSArray<NSValue *> *)rangesByOnceUnmatchString:(NSString *)aString;
- (NSArray<NSValue *> *)rangesByAllMatchString:(NSString *)aString;
- (NSArray<NSValue *> *)rangesByAllUnmatchString:(NSString *)aString;

// By Regex
- (NSArray<NSValue *> *)rangesByOnceMatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options;
- (NSArray<NSValue *> *)rangesByOnceUnmatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options;
- (NSArray<NSValue *> *)rangesByAllMatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options;
- (NSArray<NSValue *> *)rangesByAllUnmatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options;

// By Range
- (NSArray<NSValue *> *)rangesOfMatchByRange:(NSRange)range;
- (NSArray<NSValue *> *)rangesOfUnmatchByRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
