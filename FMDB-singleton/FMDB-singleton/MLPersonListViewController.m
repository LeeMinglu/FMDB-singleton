//
//  MLPersonListViewController.m
//  FMDB-singleton
//
//  Created by 李明禄 on 15/12/27.
//  Copyright © 2015年 SocererGroup. All rights reserved.
//

#import "MLPersonListViewController.h"
#import "MLPersonViewController.h"
#import "MLDBTools.h"

@interface MLPersonListViewController ()<MLPersonViewControllerDelegate>

@property (nonatomic, strong) NSArray *persons;

@end

@implementation MLPersonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPersons];
    
    NSLog(@"%@",NSHomeDirectory());
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.persons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"person" forIndexPath:indexPath];
    
    cell.textLabel.text = self.persons[indexPath.row][@"personName"];
    cell.detailTextLabel.text = self.persons[indexPath.row][@"companyName"];
    
    NSLog(@"%@",self.persons[indexPath.row][@"companyName"]);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MLPersonViewController *addPersonVC = segue.destinationViewController;
    addPersonVC.delegate = self;
}


-  (void)personViewControllerDidClickSaveData {
    [self loadPersons];
    [self.tableView reloadData];
}


- (void)loadPersons {
    //从数据库中获取数据；
    [[MLDBTools sharedDBTools].queue inDatabase:^(FMDatabase *db) {
       FMResultSet *resultSets = [db executeQuery:@"SELECT p.personName, c.companyName FROM T_Person p LEFT JOIN T_Company c ON c.companyId = p.companyId ORDER BY p.personName"];
        
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        while ([resultSets next]) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            NSString *personName = [resultSets stringForColumn:@"personName"];
            NSString *companyName = [resultSets stringForColumn:@"companyName"];
            
            if (companyName == nil) {
                companyName = @"";
            }
            
            [dictM setValue:personName forKey:@"personName"];
            [dictM setValue:companyName forKey:@"companyName"];
            
            [arrayM addObject:dictM];
        }
        
        self.persons = arrayM;
    }];
    
    
    
    //将数据加载到数据中；
    
    
    //加载tableView
    
}


@end
