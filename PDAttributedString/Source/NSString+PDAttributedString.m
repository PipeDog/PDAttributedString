//
//  NSString+PDAttributedString.m
//  PDBaseLib
//
//  Created by liang on 2018/3/1.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "NSString+PDAttributedString.h"

@interface NSString (_PDRanges)

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

@implementation NSString (_PDRanges)

#pragma mark - By Substring
- (NSArray<NSValue *> *)rangesByOnceMatchString:(NSString *)aString {
    if (![self containsString:aString]) {
        return @[];
    }
    NSString *selfCopy = [self copy];
    NSRange range = [selfCopy rangeOfString:aString options:NSLiteralSearch];
    
    return @[[NSValue valueWithRange:range]];
}

- (NSArray<NSValue *> *)rangesByOnceUnmatchString:(NSString *)aString {
    if (![self containsString:aString]) {
        return @[];
    }
    NSString *selfCopy = [self copy];
    NSRange range = [selfCopy rangeOfString:aString options:NSLiteralSearch];
    
    NSRange headRange = NSMakeRange(0, range.location);
    NSRange tailRange  = NSMakeRange(range.location + range.length,
                                     selfCopy.length - (range.location + range.length));
    return @[[NSValue valueWithRange:headRange],
             [NSValue valueWithRange:tailRange]];
}

- (NSArray<NSValue *> *)rangesByAllMatchString:(NSString *)aString {
    NSUInteger loc = 0;
    NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
    
    NSRange range = [self rangeOfString:aString];
    if (range.location == NSNotFound) {
        return [ranges copy];
    }
    
    NSString *tempString = [self copy];
    
    while (range.location != NSNotFound) {
        if (loc == 0) {
            loc += range.location;
        } else {
            loc += range.location + aString.length;
        }
        
        [ranges addObject:[NSValue valueWithRange:NSMakeRange(loc, aString.length)]];
        
        tempString = [tempString substringFromIndex:(range.location + range.length)];
        range = [tempString rangeOfString:aString];
    }
    return ranges;
}

- (NSArray<NSValue *> *)rangesByAllUnmatchString:(NSString *)aString {
    NSString *selfCopy = [self copy];
    
    if (![self containsString:aString]) {
        return @[[NSValue valueWithRange:NSMakeRange(0, selfCopy.length)]];
    }
    
    NSArray<NSValue *> *matchRanges = [self rangesByAllMatchString:aString];
    NSMutableArray<NSValue *> *unmatchRanges = [NSMutableArray array];
    
    NSUInteger firstCharLoc = 0;
    NSUInteger lastCharLoc = selfCopy.length;
    
    for (NSUInteger i = 0; i < matchRanges.count; i += 1) {
        NSRange matchRange = [matchRanges[i] rangeValue];
        
        if (i == 0) {
            NSRange unmatchRange = NSMakeRange(firstCharLoc, matchRange.location);
            [unmatchRanges addObject:[NSValue valueWithRange:unmatchRange]];
        }
        if (i == matchRanges.count - 1) {
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length, lastCharLoc - (matchRange.location + matchRange.length));
            [unmatchRanges addObject:[NSValue valueWithRange:unmatchRange]];
        }
        else {
            NSRange nextMatchRange = [matchRanges[i + 1] rangeValue];
            
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length, nextMatchRange.location - (matchRange.location + matchRange.length));
            [unmatchRanges addObject:[NSValue valueWithRange:unmatchRange]];
        }
    }
    return unmatchRanges;
}

#pragma mark - By Regex
- (NSArray<NSValue *> *)rangesByOnceMatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options {
    NSError *error;
    if (!regexString.length) return @[];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:options error:&error];
    if (error) {
        NSLog(@"Regular expression builds fail, error = (%@).", error);
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSArray<NSTextCheckingResult *> *matchResults = [regex matchesInString:selfCopy options:NSMatchingReportProgress range:NSMakeRange(0, selfCopy.length)];
    if (!matchResults.count) return @[];
    
    NSRange range = matchResults.firstObject.range;
    return @[[NSValue valueWithRange:range]];
}

- (NSArray<NSValue *> *)rangesByOnceUnmatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options {
    NSError *error;
    if (!regexString.length) return @[];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:options error:&error];
    if (error) {
        NSLog(@"Regular expression builds fail, error = (%@).", error);
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSArray<NSTextCheckingResult *> *matchResults = [regex matchesInString:selfCopy options:NSMatchingReportProgress range:NSMakeRange(0, selfCopy.length)];
    if (!matchResults.count) return @[];
    
    NSRange range = matchResults.firstObject.range;
    NSRange headRange = NSMakeRange(0, range.location);
    NSRange tailRange  = NSMakeRange(range.location + range.length,
                                     selfCopy.length - (range.location + range.length));
    
    return @[[NSValue valueWithRange:headRange],
             [NSValue valueWithRange:tailRange]];
}

- (NSArray<NSValue *> *)rangesByAllMatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options {
    if (!regexString.length) return @[];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:options error:&error];
    if (error) {
        NSLog(@"Regular expression builds fail, error = (%@).", error);
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSArray<NSTextCheckingResult *> *matchResults = [regex matchesInString:selfCopy options:NSMatchingReportProgress range:NSMakeRange(0, selfCopy.length)];
    if (!matchResults.count) return @[];
    
    NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
    
    for (NSTextCheckingResult *element in matchResults) {
        NSRange range = element.range;
        [ranges addObject:[NSValue valueWithRange:range]];
    }
    return ranges;
}

- (NSArray<NSValue *> *)rangesByAllUnmatchRegexString:(NSString *)regexString options:(NSRegularExpressionOptions)options {
    NSArray<NSValue *> *matchRanges = [self rangesByAllMatchRegexString:regexString options:options];
    if (!matchRanges.count) {
        NSString *selfCopy = [self copy];
        return @[[NSValue valueWithRange:NSMakeRange(0, selfCopy.length)]];
    }
    
    NSMutableArray<NSValue *> *unmatchRanges = [NSMutableArray array];
    
    NSString *selfCopy = [self copy];
    NSUInteger firstCharLoc = 0;
    NSUInteger lastCharLoc = selfCopy.length;
    
    for (NSUInteger i = 0; i < matchRanges.count; i += 1) {
        NSRange matchRange = [matchRanges[i] rangeValue];
        
        if (i == 0) {
            NSRange unmatchRange = NSMakeRange(firstCharLoc, matchRange.location);
            [unmatchRanges addObject:[NSValue valueWithRange:unmatchRange]];
        }
        if (i == matchRanges.count - 1) {
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length,
                                               lastCharLoc - (matchRange.location + matchRange.length));
            [unmatchRanges addObject:[NSValue valueWithRange:unmatchRange]];
        }
        else {
            NSRange nextMatchRange = [matchRanges[i + 1] rangeValue];
            
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length, nextMatchRange.location - (matchRange.location + matchRange.length));
            [unmatchRanges addObject:[NSValue valueWithRange:unmatchRange]];
        }
    }
    return unmatchRanges;
}

#pragma mark - By Range
- (NSArray<NSValue *> *)rangesOfMatchByRange:(NSRange)range {
    if (range.location > self.length || range.location + range.length > self.length) {
        return @[];
    }
    return @[[NSValue valueWithRange:range]];
}

- (NSArray<NSValue *> *)rangesOfUnmatchByRange:(NSRange)range {
    if (range.location > self.length || range.location + range.length > self.length) {
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSRange headRange = NSMakeRange(0, range.location);
    NSRange tailRange  = NSMakeRange(range.location + range.length,
                                     selfCopy.length - (range.location + range.length));
    
    return @[[NSValue valueWithRange:headRange],
             [NSValue valueWithRange:tailRange]];
}

@end

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
