//
//  AppDelegate.m
//  PDAttributedString
//
//  Created by liang on 2018/3/25.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+PDRanges.h"

static NSString *const kTestString = @"Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great.";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self testRangesByString];
    [self testRangesByRegex];
    [self testRangesByRange];
    return YES;
}

- (void)testRangesByString {
    NSLog(@"\n===========================================================>\n");
    NSLog(@"\n======================== ByString =========================>\n");
    NSLog(@"\n===========================================================>\n");
    NSArray<NSValue *> *ranges0 = [kTestString rangesByOnceMatchString:@"great"];
    NSArray<NSValue *> *ranges1 = [kTestString rangesByOnceUnmatchString:@"great"];
    NSArray<NSValue *> *ranges2 = [kTestString rangesByAllMatchString:@"great"];
    NSArray<NSValue *> *ranges3 = [kTestString rangesByAllUnmatchString:@"great"];
    
    [self printRanges:ranges0 ofString:kTestString];
    [self printRanges:ranges1 ofString:kTestString];
    [self printRanges:ranges2 ofString:kTestString];
    [self printRanges:ranges3 ofString:kTestString];
}

- (void)testRangesByRegex {
    NSLog(@"\n===========================================================>\n");
    NSLog(@"\n======================== ByRegex =========================>\n");
    NSLog(@"\n===========================================================>\n");
    NSArray<NSValue *> *ranges0 = [kTestString rangesByOnceMatchRegexString:@"[t|h]" options:NSRegularExpressionDotMatchesLineSeparators];
    NSArray<NSValue *> *ranges1 = [kTestString rangesByOnceUnmatchRegexString:@"[t|h]" options:NSRegularExpressionDotMatchesLineSeparators];
    NSArray<NSValue *> *ranges2 = [kTestString rangesByAllMatchRegexString:@"[t|h]" options:NSRegularExpressionDotMatchesLineSeparators];
    NSArray<NSValue *> *ranges3 = [kTestString rangesByAllUnmatchRegexString:@"[t|h]" options:NSRegularExpressionDotMatchesLineSeparators];
    
    [self printRanges:ranges0 ofString:kTestString];
    [self printRanges:ranges1 ofString:kTestString];
    [self printRanges:ranges2 ofString:kTestString];
    [self printRanges:ranges3 ofString:kTestString];
}

- (void)testRangesByRange {
    NSLog(@"\n===========================================================>\n");
    NSLog(@"\n======================== ByRange =========================>\n");
    NSLog(@"\n===========================================================>\n");
    NSArray<NSValue *> *ranges0 = [kTestString rangesOfMatchByRange:NSMakeRange(0, 10)];
    NSArray<NSValue *> *ranges1 = [kTestString rangesOfMatchByRange:NSMakeRange(2, 10)];
    NSArray<NSValue *> *ranges2 = [kTestString rangesOfMatchByRange:NSMakeRange(10, kTestString.length)];
    
    NSArray<NSValue *> *ranges3 = [kTestString rangesOfUnmatchByRange:NSMakeRange(0, 10)];
    NSArray<NSValue *> *ranges4 = [kTestString rangesOfUnmatchByRange:NSMakeRange(2, 10)];
    NSArray<NSValue *> *ranges5 = [kTestString rangesOfUnmatchByRange:NSMakeRange(10, kTestString.length)];
    
    [self printRanges:ranges0 ofString:kTestString];
    [self printRanges:ranges1 ofString:kTestString];
    [self printRanges:ranges2 ofString:kTestString];
    [self printRanges:ranges3 ofString:kTestString];
    [self printRanges:ranges4 ofString:kTestString];
    [self printRanges:ranges5 ofString:kTestString];
}

- (void)printRanges:(NSArray<NSValue *> *)ranges ofString:(NSString *)aString {
    NSLog(@"\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    for (NSValue *rangeValue in ranges) {
        [self printSubstringOfString:aString byRange:[rangeValue rangeValue]];
    }
    NSLog(@"\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n\n");
}

- (void)printSubstringOfString:(NSString *)aString byRange:(NSRange)range {
    NSLog(@"range = %@, substr = %@", NSStringFromRange(range), [aString substringWithRange:range]);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
