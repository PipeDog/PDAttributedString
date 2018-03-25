//
//  ViewController.m
//  PDAttributedString
//
//  Created by liang on 2018/3/25.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "ViewController.h"
#import "NSString+PDAttributedString.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray<NSAttributedString *> *attributedStrings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableView Delegate && DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self sectionTitleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 0;
        
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    }
    cell.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f * indexPath.row + 0.1f];
    cell.textLabel.attributedText = [self textForSection:indexPath.section row:indexPath.row];
    cell.detailTextLabel.text = [self detailTextForRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)sectionTitleForSection:(NSInteger)section {
    NSArray<NSString *> *sectionTitles = @[@"Base on string",
                                           @"Base on range",
                                           @"Base on regex"];
    return sectionTitles[section];
}

- (NSString *)detailTextForRow:(NSInteger)row {
    NSArray<NSString *> *detailTexts = @[@"MatchOnce",
                                         @"UnmatchOne",
                                         @"MatchAll",
                                         @"UnmatchAll"];
    return detailTexts[row];
}

#pragma mark - Format AttributedString Method
- (NSAttributedString *)textForSection:(NSInteger)section row:(NSInteger)row {
    if (section == 0) {
        return [self textForSectionOne:(PDAttributedStringMatchType)row];
    } else if (section == 1) {
        return [self textForSectionSecond:(PDAttributedStringMatchType)row];
    } else if (section == 2) {
        return [self textForSectionThree:(PDAttributedStringMatchType)row];
    }
    return nil;
}

- (NSAttributedString *)textForSectionOne:(PDAttributedStringMatchType)matchType {
    NSString *text = @"Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great.";
    NSDictionary<NSAttributedStringKey, id> *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:20],
                                                      NSForegroundColorAttributeName: [UIColor brownColor],
                                                      NSUnderlineStyleAttributeName: @1};
    NSAttributedString *attributedText;
    
    if (matchType == PDAttributedStringMatchTypeMatchOnce) {
        attributedText = [text addAttributes:dict string:@"are not born with the great" matchType:PDAttributedStringMatchTypeMatchOnce];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchOnce) {
        attributedText = [text addAttributes:dict string:@"are not born with the great" matchType:PDAttributedStringMatchTypeUnmatchOnce];
    }
    else if (matchType == PDAttributedStringMatchTypeMatchAll) {
        attributedText = [text addAttributes:dict string:@"are not born with the great" matchType:PDAttributedStringMatchTypeMatchAll];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
        attributedText = [text addAttributes:dict string:@"are not born with the great" matchType:PDAttributedStringMatchTypeUnmatchAll];
    }
    return attributedText;
}

- (NSAttributedString *)textForSectionSecond:(PDAttributedStringMatchType)matchType {
    NSString *text = @"Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great.";
    NSDictionary<NSAttributedStringKey, id> *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:20],
                                                      NSForegroundColorAttributeName: [UIColor brownColor],
                                                      NSUnderlineStyleAttributeName: @1,
                                                      NSStrokeWidthAttributeName: @2,
                                                      NSStrokeColorAttributeName: [UIColor blackColor],
                                                      NSBackgroundColorAttributeName: [[UIColor redColor] colorWithAlphaComponent:0.5f]};
    NSAttributedString *attributedText;
    
    if (matchType == PDAttributedStringMatchTypeMatchOnce) {
        attributedText = [text addAttributes:dict range:NSMakeRange(10, 10) matchType:PDAttributedStringMatchTypeMatchOnce];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchOnce) {
        attributedText = [text addAttributes:dict range:NSMakeRange(10, 10) matchType:PDAttributedStringMatchTypeUnmatchOnce];
    }
    else if (matchType == PDAttributedStringMatchTypeMatchAll) {
        attributedText = [text addAttributes:dict range:NSMakeRange(10, 10) matchType:PDAttributedStringMatchTypeMatchAll];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
        attributedText = [text addAttributes:dict range:NSMakeRange(10, 10) matchType:PDAttributedStringMatchTypeUnmatchAll];
    }
    return attributedText;
}

- (NSAttributedString *)textForSectionThree:(PDAttributedStringMatchType)matchType {
    NSString *text = @"Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great. Great people are not born with the great, but in the process of growing up show its great.";
    NSDictionary<NSAttributedStringKey, id> *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:20],
                                                      NSForegroundColorAttributeName: [UIColor brownColor],
                                                      NSUnderlineStyleAttributeName: @1};
    NSAttributedString *attributedText;
    
    if (matchType == PDAttributedStringMatchTypeMatchOnce) {
        attributedText = [text addAttributes:dict regex:@"are not born with the great" matchType:PDAttributedStringMatchTypeMatchOnce];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchOnce) {
        attributedText = [text addAttributes:dict regex:@"are not born with the great" matchType:PDAttributedStringMatchTypeUnmatchOnce];
    }
    else if (matchType == PDAttributedStringMatchTypeMatchAll) {
        attributedText = [text addAttributes:dict regex:@"are not born with the great" matchType:PDAttributedStringMatchTypeMatchAll];
    }
    else if (matchType == PDAttributedStringMatchTypeUnmatchAll) {
        attributedText = [text addAttributes:dict regex:@"are not born with the great" matchType:PDAttributedStringMatchTypeUnmatchAll];
    }
    return attributedText;
}

@end
