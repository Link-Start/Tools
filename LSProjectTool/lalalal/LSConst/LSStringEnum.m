//
//  LSStringEnum.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/21.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "LSStringEnum.h"

TCFilterIdentifier const TCFilterIdentifierNone      = @"";
TCFilterIdentifier const TCFilterIdentifierBaiXi     = @"baixi";
TCFilterIdentifier const TCFilterIdentifierNormal    = @"normal";
TCFilterIdentifier const TCFilterIdentifierZiRan     = @"ziran";
TCFilterIdentifier const TCFilterIdentifierYinghong  = @"yinghong";
TCFilterIdentifier const TCFilterIdentifierYunshang  = @"yunshang";
TCFilterIdentifier const TCFilterIdentifierChunzhen  = @"chunzhen";
TCFilterIdentifier const TCFilterIdentifierBailan    = @"bailan";
TCFilterIdentifier const TCFilterIdentifierYuanqi    = @"yuanqi";
TCFilterIdentifier const TCFilterIdentifierChaotuo   = @"chaotuo";
TCFilterIdentifier const TCFilterIdentifierXiangfen  = @"xiangfen";
TCFilterIdentifier const TCFilterIdentifierWhite     = @"white";
TCFilterIdentifier const TCFilterIdentifierLangman   = @"langman";
TCFilterIdentifier const TCFilterIdentifierQingxin   = @"qingxin";
TCFilterIdentifier const TCFilterIdentifierWeimei    = @"weimei";
TCFilterIdentifier const TCFilterIdentifierFennen    = @"fennen";
TCFilterIdentifier const TCFilterIdentifierHuaijiu   = @"huaijiu";
TCFilterIdentifier const TCFilterIdentifierLandiao   = @"landiao";
TCFilterIdentifier const TCFilterIdentifierQingliang = @"qingliang";
TCFilterIdentifier const TCFilterIdentifierRixi      = @"rixi";


@implementation LSStringEnum

- (instancetype)initWithIdentifier:(TCFilterIdentifier)identifier
                   lookupImagePath:(NSString *)lookupImagePath {
    if (self = [super init]) {
        _identifier = identifier;
        _lookupImagePath = lookupImagePath;
    }
    return self;
}

@end
