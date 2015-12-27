//
//  MLPersonViewController.h
//  FMDB-singleton
//
//  Created by 李明禄 on 15/12/26.
//  Copyright © 2015年 SocererGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MLPersonViewControllerDelegate <NSObject>

- (void)personViewControllerDidClickSaveData;

@end

@interface MLPersonViewController : UITableViewController

@property (nonatomic, weak) id<MLPersonViewControllerDelegate> delegate;

@end
