//
//  SimpleViewController.m
//  XTUniversalTable
//
//  Created by 吾问 on 16/5/6.
//  Copyright © 2016年 X-Team. All rights reserved.
//

#import "SimpleViewController.h"
#import "XTUniversalTable.h"

@interface SimpleViewController () <XTUTProxyDataSource> {
    NSArray<id<XTUTSection>> *_sectons;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XTUTProxy *tableProxy;

@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableProxy = [[XTUTProxy alloc] initWithTableView:self.tableView];
    self.tableProxy.dataSource = self;
}

#pragma mark - XTUTProxyDataSource

- (NSArray<id<XTUTSection>> *)sections {
    if (!_sectons) {
        NSString *JSONPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
        NSData *JSONData = [NSData dataWithContentsOfFile:JSONPath];
        NSDictionary<NSString *, NSArray *> *JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
        NSMutableArray *sections = [NSMutableArray array];
        
        NSArray<NSString *> *sortedKeys = [[JSONObject allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
            return [key1 compare:key2];
        }];
     
        [sortedKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            // Rows
            NSMutableArray *cityRows = [NSMutableArray array];
            NSArray<NSDictionary *> *cities = JSONObject[key];
            [cities enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull city, NSUInteger idx, BOOL * _Nonnull stop) {
                XTUTRow *row = [XTUTRow rowWithIdentifier:@"cell"
                                              classString:@"UITableViewCell"
                                                     data:city];
                if (row) {
                    [cityRows addObject:row];
                }
            }];
            // Header
            XTUTSectionHeaderFooter *header = [XTUTSectionHeaderFooter headerWithHeight:20.0f title:key];
            // Section
            XTUTSection *section = [XTUTSection sectionWithRows:cityRows
                                                         header:header
                                                         footer:nil];
            [sections addObject:section];
        }];
        
        _sectons = sections;
    }
    return _sectons;
}

@end