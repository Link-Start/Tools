//
//  WBQRCodeVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QRCodeScanJumpType) {
    QRCodeScanJumpTypeDefult,
    QRCodeScanJumpTypeCustom,
};

typedef void(^scanResult)(NSString *result);

@interface WBQRCodeVC : UIViewController

@property (nonatomic, copy) scanResult scanResultBlock;
@property (nonatomic, assign) QRCodeScanJumpType jumpType;

@end
