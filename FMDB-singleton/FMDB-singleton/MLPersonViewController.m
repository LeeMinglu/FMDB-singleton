//
//  MLPersonViewController.m
//  FMDB-singleton
//
//  Created by 李明禄 on 15/12/26.
//  Copyright © 2015年 SocererGroup. All rights reserved.
//

#import "MLPersonViewController.h"
#import "MLDBTools.h"

@interface MLPersonViewController ()<UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UITextField *corperationText;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *companyes;

@end

@implementation MLPersonViewController

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.corperationText.inputView = self.pickerView;
    
    [self loadCompanies];
}

//加载公司数据
- (void)loadCompanies {
    //从数据库加载
    [[MLDBTools sharedDBTools].queue inDatabase:^(FMDatabase *db) {
        //查询所有公司的数据
        FMResultSet *set = [db executeQuery:@"SELECT companyId,companyName FROM t_company"];
        
        //遍历查询结果
        NSMutableArray *arrayM = [NSMutableArray array];
        
        while ([set next]) {
            //从结果中取出公司的名称
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            
            NSInteger companyId = [set intForColumn:@"companyId"];
            NSString *companyName = [set stringForColumn:@"companyName"];
            
            [dictM setObject:@(companyId) forKey:@"companyId"];
            [dictM setObject:companyName forKey:@"companyName"];
            
            
            [arrayM addObject:dictM];
        }
        
        self.companyes = arrayM;
        
        // 让pickerView更新数据
        [self.pickerView reloadAllComponents];
    }];
    
}

//新建公司记录
- (IBAction)newCompany:(UIBarButtonItem *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入公司名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

#pragma mark alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击了%zd", buttonIndex);
    
    //0:取消按钮，1: 点击了确定按钮
    if (buttonIndex == 0) return;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (textField.text.length == 0) {
        return;
    }
    
    //保存公司数据
    [[MLDBTools sharedDBTools].queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO T_Company(companyName) VALUES (?)", textField.text];
        
        NSLog(@"保存成功");
        
        // 重新加载公司数据
        // 查询所有的公司数据
        FMResultSet *rs = [db executeQuery:@"select companyName from t_company"];
        
        // 遍历查询结果
        NSMutableArray *arrayM = [NSMutableArray array];
        while ([rs next]) {
            // 从结果中取出公司名称，提示，取查询结果最好用列名，不要用列数
            
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            
            NSInteger companyId = [rs intForColumn:@"companyId"];
            
            NSString *companyName = [rs stringForColumn:@"companyName"];
            
            [dictM setObject:@(companyId) forKey:@"companyId"];
            [dictM setObject:companyName forKey:@"companyName"];
            
            [arrayM addObject:dictM];
        }
        
        // 给数组设置数值
        self.companyes = arrayM;
        
        // 让pickerView更新数据
        [self.pickerView reloadAllComponents];
        
    }];


}

//保存个人记录
- (IBAction)savePerson:(UIButton *)sender {
    
    /*@"INSERT INTO T_Person (personName, age, phoneNo, companyId) VALUES (?, ?, ?, ?)", self.nameText.text, self.ageText.text, self.phoneText.text, companyNum */
    NSInteger companyId = self.corperationText.tag;
    NSNumber *companyNum = nil;
    
    if (companyId > 0) {
        companyNum = @(companyId);
    }
    
    [[MLDBTools sharedDBTools].queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO T_Person (personName, age, phoneNo, companyId) VALUES (?, ?, ?, ?)",self.nameText.text, self.ageText.text, self.phoneText.text, companyNum];
    }];
    
    NSLog(@"保存个人数据成功");
    
    if ([self.delegate respondsToSelector:@selector(personViewControllerDidClickSaveData)]) {
        [self.delegate personViewControllerDidClickSaveData];
        
    }
    
    //返回上级控制器
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark 实现pickerView的协议及数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.companyes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.companyes[row][@"companyName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // 记录选中的companyId
    self.corperationText.tag = [self.companyes[row][@"companyId"] intValue];

    self.corperationText.text = self.companyes[row][@"companyName"];
}





@end
