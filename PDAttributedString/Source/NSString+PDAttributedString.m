//
//  NSString+PDAttributedString.m
//  PDBaseLib
//
//  Created by liang on 2018/3/1.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "NSString+PDAttributedString.h"

@implementation NSString (PDAttributedString)

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self];
    return [attributedString setAttributes:attrs string:aString matchType:matchType];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self];
    return [attributedString addAttributes:attrs string:aString matchType:matchType];
}

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self];
    return [attributedString setAttributes:attrs range:range matchType:matchType];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self];
    return [attributedString addAttributes:attrs range:range matchType:matchType];
}

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                              options:(NSRegularExpressionOptions)options
                            matchType:(PDAttributedStringMatchType)matchType {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self];
    return [attributedString setAttributes:attrs regex:regexString options:options matchType:matchType];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                              options:(NSRegularExpressionOptions)options
                            matchType:(PDAttributedStringMatchType)matchType {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self];
    return [attributedString addAttributes:attrs regex:regexString options:options matchType:matchType];
}

@end

@implementation NSAttributedString (PDAttributedString)

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSValue *> *ranges = [attributedString rangesByString:aString matchType:matchType];
    if (ranges.count == 0) return [attributedString copy];
    
    for (NSValue *rangeValue in ranges) {
        NSRange range = [rangeValue rangeValue];
        [attributedString setAttributes:attrs range:range];
    }
    return [attributedString copy];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSValue *> *ranges = [attributedString rangesByString:aString matchType:matchType];
    if (ranges.count == 0) return [attributedString copy];
    
    for (NSValue *rangeValue in ranges) {
        NSRange range = [rangeValue rangeValue];
        [attributedString addAttributes:attrs range:range];
    }
    return [attributedString copy];
}

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    if (range.location > self.length) range.length = self.length;
    
    NSArray<NSValue *> *ranges = [attributedString rangesByRange:range matchType:matchType];
    if (ranges.count == 0) return [attributedString copy];
    
    for (NSValue *rangeValue in ranges) {
        NSRange range = [rangeValue rangeValue];
        [attributedString setAttributes:attrs range:range];
    }
    return [attributedString copy];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    if (range.location > self.length) range.length = self.length;
    
    NSArray<NSValue *> *ranges = [attributedString rangesByRange:range matchType:matchType];
    if (ranges.count == 0) return attributedString;
    
    for (NSValue *rangeValue in ranges) {
        NSRange range = [rangeValue rangeValue];
        [attributedString addAttributes:attrs range:range];
    }
    return [attributedString copy];
}

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                              options:(NSRegularExpressionOptions)options
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSValue *> *ranges = [attributedString rangesByRegexString:regexString options:options matchType:matchType];
    if (ranges.count == 0) return [attributedString copy];
    
    for (NSValue *rangeValue in ranges) {
        NSRange range = [rangeValue rangeValue];
        [attributedString setAttributes:attrs range:range];
    }
    return [attributedString copy];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                              options:(NSRegularExpressionOptions)options
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSValue *> *ranges = [attributedString rangesByRegexString:regexString options:options matchType:matchType];
    if (ranges.count == 0) return [attributedString copy];
    
    for (NSValue *rangeValue in ranges) {
        NSRange range = [rangeValue rangeValue];
        [attributedString addAttributes:attrs range:range];
    }
    return [attributedString copy];
}

#pragma mark - Get Ranges Methods
- (NSArray<NSValue *> *)rangesByString:(NSString *)aString matchType:(PDAttributedStringMatchType)matchType {
    switch (matchType) {
        case PDAttributedStringMatchTypeMatchOnce: {
            return [self.string rangesByOnceMatchString:aString];
        }
        case PDAttributedStringMatchTypeUnmatchOnce: {
            return [self.string rangesByOnceUnmatchString:aString];
        }
        case PDAttributedStringMatchTypeMatchAll: {
            return [self.string rangesByAllMatchString:aString];
        }
        case PDAttributedStringMatchTypeUnmatchAll: {
            return [self.string rangesByAllUnmatchString:aString];
        }
        default: return @[];
    }
}

- (NSArray<NSValue *> *)rangesByRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options matchType:(PDAttributedStringMatchType)matchType {
    switch (matchType) {
        case PDAttributedStringMatchTypeMatchOnce: {
            return [self.string rangesByOnceMatchRegexString:regexString options:options];
        }
        case PDAttributedStringMatchTypeUnmatchOnce: {
            return [self.string rangesByOnceUnmatchRegexString:regexString options:options];
        }
        case PDAttributedStringMatchTypeMatchAll: {
            return [self.string rangesByAllMatchRegexString:regexString options:options];
        }
        case PDAttributedStringMatchTypeUnmatchAll: {
            return [self.string rangesByAllUnmatchRegexString:regexString options:options];
        }
        default: return @[];
    }
}

- (NSArray<NSValue *> *)rangesByRange:(NSRange)range matchType:(PDAttributedStringMatchType)matchType {
    switch (matchType) {
        case PDAttributedStringMatchTypeMatchOnce:
        case PDAttributedStringMatchTypeMatchAll: {
            return [self.string rangesOfMatchByRange:range];
        }
        case PDAttributedStringMatchTypeUnmatchOnce:
        case PDAttributedStringMatchTypeUnmatchAll: {
            return [self.string rangesOfUnmatchByRange:range];
        }
        default: return @[];
    }
}

@end
