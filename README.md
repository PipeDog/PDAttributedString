# PDAttributedString

Category of NSAttributedString, which provides a variety of string matching methods.

```
typedef NS_ENUM(NSUInteger, PDAttributedStringMatchType) {
    PDAttributedStringMatchTypeMatchOnce   = 0, ///< The first matching substring.
    PDAttributedStringMatchTypeUnmatchOnce = 1, ///< Unmatched substrings with matched once.
    PDAttributedStringMatchTypeMatchAll    = 2, ///< Match all substring.
    PDAttributedStringMatchTypeUnmatchAll  = 3, ///< Unmatched substrings with matched all.
};

NS_ASSUME_NONNULL_BEGIN

@protocol PDAttributedString <NSObject>

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
                              options:(NSRegularExpressionOptions)options
                            matchType:(PDAttributedStringMatchType)matchType;

- (NSAttributedString *)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
                                regex:(NSString *)regexString
                              options:(NSRegularExpressionOptions)options
                            matchType:(PDAttributedStringMatchType)matchType;

@end

@interface NSString (PDAttributedString) <PDAttributedString>

@end

@interface NSAttributedString (PDAttributedString) <PDAttributedString>

@end
```
