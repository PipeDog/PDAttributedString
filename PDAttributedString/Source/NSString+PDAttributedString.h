//
//  NSString+PDAttributedString.h
//  PDBaseLib
//
//  Created by liang on 2018/3/1.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PDAttributedStringMatchType) {
    PDAttributedStringMatchTypeMatchOnce   = 0, ///< The first matching substring.
    PDAttributedStringMatchTypeUnmatchOnce = 1, ///< Unmatched substrings with matched once.
    PDAttributedStringMatchTypeMatchAll    = 2, ///< Match all substring.
    PDAttributedStringMatchTypeUnmatchAll  = 3, ///< Unmatched substrings with matched all.
};

NS_ASSUME_NONNULL_BEGIN

@protocol PDAttributedStringProtocol <NSObject>

// The key can refer to the <<< NSAttributedString.h >>> in <<< UIKit >>>.
- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType;

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                               string:(NSString *)aString
                            matchType:(PDAttributedStringMatchType)matchType;

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType;

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                range:(NSRange)range
                            matchType:(PDAttributedStringMatchType)matchType;

- (NSAttributedString *)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                            matchType:(PDAttributedStringMatchType)matchType;

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                            matchType:(PDAttributedStringMatchType)matchType;

@end

@interface NSString (PDAttributedString) <PDAttributedStringProtocol>

@end

@interface NSAttributedString (PDAdd) <PDAttributedStringProtocol>

@end

NS_ASSUME_NONNULL_END
