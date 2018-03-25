//
//  NSString+PDAttributedString.m
//  PDBaseLib
//
//  Created by liang on 2018/3/1.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "NSString+PDAttributedString.h"

@interface NSString (PDMatchString)

@end

@implementation NSString (PDMatchString)

// The elements in return array, [BOOL, NSRange]
- (NSArray<NSArray *> *)onceMatchComponentsByString:(NSString *)aString {
    if (![self containsString:aString]) {
        return @[];
    }
    NSString *selfCopy = [self copy];
    NSRange matchRange = [selfCopy rangeOfString:aString];
    
    NSRange frontRange = NSMakeRange(0, matchRange.location);
    NSRange rearRange  = NSMakeRange(matchRange.location + matchRange.length,
                                     selfCopy.length - (matchRange.location + matchRange.length));
    
    return @[@[@(NO),  [NSValue valueWithRange:frontRange]],
             @[@(YES), [NSValue valueWithRange:matchRange]],
             @[@(NO),  [NSValue valueWithRange:rearRange]]];
}

- (NSArray<NSArray *> *)onceMatchComponentsByRange:(NSRange)range {
    if (range.location > self.length || range.location + range.length > self.length) {
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSRange frontRange = NSMakeRange(0, range.location);
    NSRange rearRange  = NSMakeRange(range.location + range.length,
                                     selfCopy.length - (range.location + range.length));
    
    return @[@[@(NO),  [NSValue valueWithRange:frontRange]],
             @[@(YES), [NSValue valueWithRange:range]],
             @[@(NO),  [NSValue valueWithRange:rearRange]]];
}

- (NSArray<NSArray *> *)allMatchComponentsByString:(NSString *)aString {
    if (![self containsString:aString]) {
        return @[];
    }
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:aString options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (error) {
        NSLog(@"Regular expression builds fail, error = (%@).", error);
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSArray<NSTextCheckingResult *> *matchResults = [regex matchesInString:selfCopy options:NSMatchingReportProgress range:NSMakeRange(0, selfCopy.length)];
    if (!matchResults.count) return @[];
    
    NSMutableArray<NSArray *> *components = [NSMutableArray array];
    
    for (NSTextCheckingResult *element in matchResults) {
        NSRange range = element.range;
        [components addObject:@[@(YES), [NSValue valueWithRange:range]]];
    }
    return components;
}

- (NSArray<NSArray *> *)allUnmatchComponentsByString:(NSString *)aString {
    if (![self containsString:aString]) {
        NSString *selfCopy = [self copy];
        return @[@[@(YES), [NSValue valueWithRange:NSMakeRange(0, selfCopy.length)]]];
    }
    
    NSArray<NSArray *> *matchAllComponents = [self allMatchComponentsByString:aString];
    NSMutableArray<NSArray *> *unmatchAllComponents = [NSMutableArray array];
    
    NSString *selfCopy = [self copy];
    NSUInteger firstCharLoc = 0;
    NSUInteger lastCharLoc = selfCopy.length;
    
    for (NSUInteger i = 0; i < matchAllComponents.count; i += 1) {
        NSArray *element = matchAllComponents[i];
        NSRange matchRange = [element[1] rangeValue];
        
        if (i == 0) {
            NSRange unmatchRange = NSMakeRange(firstCharLoc, matchRange.location);
            [unmatchAllComponents addObject:@[@(NO), [NSValue valueWithRange:unmatchRange]]];
        }
        if (i == matchAllComponents.count - 1) {
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length, lastCharLoc - (matchRange.location + matchRange.length));
            [unmatchAllComponents addObject:@[@(NO), [NSValue valueWithRange:unmatchRange]]];
        }
        else {
            NSArray *nextElement = matchAllComponents[i + 1];
            NSRange nextMatchRange = [nextElement[1] rangeValue];
            
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length, nextMatchRange.location - (matchRange.location + matchRange.length));
            [unmatchAllComponents addObject:@[@(NO), [NSValue valueWithRange:unmatchRange]]];
        }
    }
    return unmatchAllComponents;
}

- (NSArray<NSArray *> *)onceMatchComponentsByRegexString:(NSString *)regexString {
    NSError *error;
    if (!regexString.length) return @[];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (error) {
        NSLog(@"Regular expression builds fail, error = (%@).", error);
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSArray<NSTextCheckingResult *> *matchResults = [regex matchesInString:selfCopy options:NSMatchingReportProgress range:NSMakeRange(0, selfCopy.length)];
    if (!matchResults.count) return @[];
    
    NSRange matchRange = matchResults.firstObject.range;
    NSRange frontRange = NSMakeRange(0, matchRange.location);
    NSRange rearRange  = NSMakeRange(matchRange.location + matchRange.length,
                                     selfCopy.length - (matchRange.location + matchRange.length));
    
    return @[@[@(NO),  [NSValue valueWithRange:frontRange]],
             @[@(YES), [NSValue valueWithRange:matchRange]],
             @[@(NO),  [NSValue valueWithRange:rearRange]]];
}

- (NSArray<NSArray *> *)allMatchComponentsByRegexString:(NSString *)regexString {
    if (!regexString.length) return @[];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (error) {
        NSLog(@"Regular expression builds fail, error = (%@).", error);
        return @[];
    }
    NSString *selfCopy = [self copy];
    
    NSArray<NSTextCheckingResult *> *matchResults = [regex matchesInString:selfCopy options:NSMatchingReportProgress range:NSMakeRange(0, selfCopy.length)];
    if (!matchResults.count) return @[];
    
    NSMutableArray<NSArray *> *components = [NSMutableArray array];
    
    for (NSTextCheckingResult *element in matchResults) {
        NSRange range = element.range;
        [components addObject:@[@(YES), [NSValue valueWithRange:range]]];
    }
    return components;
}

- (NSArray<NSArray *> *)allUnmatchComponentsByRegexString:(NSString *)regexString {
    NSArray<NSArray *> *matchAllComponents = [self allMatchComponentsByRegexString:regexString];
    if (!matchAllComponents.count) {
        NSString *selfCopy = [self copy];
        return @[@[@(YES), [NSValue valueWithRange:NSMakeRange(0, selfCopy.length)]]];
    }
    
    NSMutableArray<NSArray *> *unmatchAllComponents = [NSMutableArray array];
    
    NSString *selfCopy = [self copy];
    NSUInteger firstCharLoc = 0;
    NSUInteger lastCharLoc = selfCopy.length;
    
    for (NSUInteger i = 0; i < matchAllComponents.count; i += 1) {
        NSArray *element = matchAllComponents[i];
        NSRange matchRange = [element[1] rangeValue];
        
        if (i == 0) {
            NSRange unmatchRange = NSMakeRange(firstCharLoc, matchRange.location);
            [unmatchAllComponents addObject:@[@(NO), [NSValue valueWithRange:unmatchRange]]];
        }
        if (i == matchAllComponents.count - 1) {
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length, lastCharLoc - (matchRange.location + matchRange.length));
            [unmatchAllComponents addObject:@[@(NO), [NSValue valueWithRange:unmatchRange]]];
        }
        else {
            NSArray *nextElement = matchAllComponents[i + 1];
            NSRange nextMatchRange = [nextElement[1] rangeValue];
            
            NSRange unmatchRange = NSMakeRange(matchRange.location + matchRange.length, nextMatchRange.location - (matchRange.location + matchRange.length));
            [unmatchAllComponents addObject:@[@(NO), [NSValue valueWithRange:unmatchRange]]];
        }
    }
    return unmatchAllComponents;
}

@end

@implementation NSString (PDAttributedString)

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    return [attributedString setAttributes:attrs string:aString matchType:matchType];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    return [attributedString addAttributes:attrs string:aString matchType:matchType];
}

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    return [attributedString setAttributes:attrs range:range matchType:matchType];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    return [attributedString addAttributes:attrs range:range matchType:matchType];
}

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    return [attributedString setAttributes:attrs regex:regexString matchType:matchType];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    return [attributedString addAttributes:attrs regex:regexString matchType:matchType];
}

@end

@implementation NSAttributedString (PDAdd)

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSArray *> *components = [attributedString componentsByString:aString matchType:matchType];
    if (components.count == 0) return [attributedString copy];
    
    for (NSArray *matchInfo in components) {
        BOOL isMatch  = [matchInfo[0] boolValue];
        NSRange range = [matchInfo[1] rangeValue];
        
        if (matchType == PDAttributedStringMatchTypeMatchOnce) {
            if (isMatch) [attributedString setAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchOnce) {
            if (!isMatch) [attributedString setAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeMatchAll) {
            if (isMatch) [attributedString setAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
            if (!isMatch) [attributedString setAttributes:attrs range:range];
        }
    }
    return [attributedString copy];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSArray *> *components = [attributedString componentsByString:aString matchType:matchType];
    if (components.count == 0) return [attributedString copy];
    
    for (NSArray *matchInfo in components) {
        BOOL isMatch  = [matchInfo[0] boolValue];
        NSRange range = [matchInfo[1] rangeValue];
        
        if (matchType == PDAttributedStringMatchTypeMatchOnce) {
            if (isMatch) [attributedString addAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchOnce) {
            if (!isMatch) [attributedString addAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeMatchAll) {
            if (isMatch) [attributedString addAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
            if (!isMatch) [attributedString addAttributes:attrs range:range];
        }
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
    
    NSArray<NSArray *> *components = [self.string onceMatchComponentsByRange:range];
    if (components.count == 0) return [attributedString copy];
    
    for (NSArray *matchInfo in components) {
        BOOL isMatch   = [matchInfo[0] boolValue];
        NSRange _range = [matchInfo[1] rangeValue];
        
        if (matchType == PDAttributedStringMatchTypeMatchOnce ||
            matchType == PDAttributedStringMatchTypeMatchAll) {
            if (isMatch) [attributedString setAttributes:attrs range:_range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchOnce ||
                 matchType == PDAttributedStringMatchTypeUnmatchAll) {
            if (!isMatch) [attributedString setAttributes:attrs range:_range];
        }
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
    
    NSArray<NSArray *> *components = [self.string onceMatchComponentsByRange:range];
    if (components.count == 0) return attributedString;
    
    for (NSArray *matchInfo in components) {
        BOOL isMatch   = [matchInfo[0] boolValue];
        NSRange _range = [matchInfo[1] rangeValue];
        
        if (matchType == PDAttributedStringMatchTypeMatchOnce ||
            matchType == PDAttributedStringMatchTypeMatchAll) {
            if (isMatch) [attributedString addAttributes:attrs range:_range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchOnce ||
                 matchType == PDAttributedStringMatchTypeUnmatchAll) {
            if (!isMatch) [attributedString addAttributes:attrs range:_range];
        }
    }
    return [attributedString copy];
}

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSArray *> *components = [attributedString componentsByRegex:regexString matchType:matchType];
    if (components.count == 0) return [attributedString copy];
    
    for (NSArray *matchInfo in components) {
        BOOL isMatch  = [matchInfo[0] boolValue];
        NSRange range = [matchInfo[1] rangeValue];
        
        if (matchType == PDAttributedStringMatchTypeMatchOnce) {
            if (isMatch) [attributedString setAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchOnce) {
            if (!isMatch) [attributedString setAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeMatchAll) {
            if (isMatch) [attributedString setAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
            if (!isMatch) [attributedString setAttributes:attrs range:range];
        }
    }
    return [attributedString copy];
}

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                            matchType:(PDAttributedStringMatchType)matchType {
    NSMutableAttributedString *attributedString = [self mutableCopy];
    if (self.length == 0) return [attributedString copy];
    if (!attrs) return [attributedString copy];
    
    NSArray<NSArray *> *components = [attributedString componentsByRegex:regexString matchType:matchType];
    if (components.count == 0) return [attributedString copy];
    
    for (NSArray *matchInfo in components) {
        BOOL isMatch  = [matchInfo[0] boolValue];
        NSRange range = [matchInfo[1] rangeValue];
        
        if (matchType == PDAttributedStringMatchTypeMatchOnce) {
            if (isMatch) [attributedString addAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchOnce) {
            if (!isMatch) [attributedString addAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeMatchAll) {
            if (isMatch) [attributedString addAttributes:attrs range:range];
        }
        else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
            if (!isMatch) [attributedString addAttributes:attrs range:range];
        }
    }
    return [attributedString copy];
}

// Get components with different matchType.
- (NSArray<NSArray *> *)componentsByString:(NSString *)aString matchType:(PDAttributedStringMatchType)matchType {
    NSArray<NSArray *> *components = @[];
    
    if (matchType == PDAttributedStringMatchTypeMatchOnce ||
        matchType == PDAttributedStringMatchTypeUnmatchOnce) {
        components = [self.string onceMatchComponentsByString:aString];
    }
    else if (matchType == PDAttributedStringMatchTypeMatchAll) {
        components = [self.string allMatchComponentsByString:aString];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
        components = [self.string allUnmatchComponentsByString:aString];
    }
    return components;
}

- (NSArray<NSArray *> *)componentsByRegex:(NSString *)regexString matchType:(PDAttributedStringMatchType)matchType {
    NSArray<NSArray *> *components = @[];
    
    if (matchType == PDAttributedStringMatchTypeMatchOnce ||
        matchType == PDAttributedStringMatchTypeUnmatchOnce) {
        components = [self.string onceMatchComponentsByRegexString:regexString];
    }
    else if (matchType == PDAttributedStringMatchTypeMatchAll) {
        components = [self.string allMatchComponentsByRegexString:regexString];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
        components = [self.string allUnmatchComponentsByRegexString:regexString];
    }
    return components;
}

@end
