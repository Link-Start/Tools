//
//  LSStringEnum.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/21.
//  Copyright © 2021 Link-Start. All rights reserved.
//

/**
 NS_STRING_ENUM  用法：
 
 */

#import <Foundation/Foundation.h>
//NS_Assume_Nonnull_Begin
NS_ASSUME_NONNULL_BEGIN
                                  //NS_EXTENSIBLE_STRING_ENUM
                                  //NS_Extensible_String_Enum
typedef NSString * TCFilterIdentifier NS_STRING_ENUM;//NS_String_Enum

extern TCFilterIdentifier const TCFilterIdentifierNone;
extern TCFilterIdentifier const TCFilterIdentifierBaiXi;
extern TCFilterIdentifier const TCFilterIdentifierNormal;
extern TCFilterIdentifier const TCFilterIdentifierZiRan;
extern TCFilterIdentifier const TCFilterIdentifierYinghong;
extern TCFilterIdentifier const TCFilterIdentifierYunshang;
extern TCFilterIdentifier const TCFilterIdentifierChunzhen;
extern TCFilterIdentifier const TCFilterIdentifierBailan;
extern TCFilterIdentifier const TCFilterIdentifierYuanqi;
extern TCFilterIdentifier const TCFilterIdentifierChaotuo;
extern TCFilterIdentifier const TCFilterIdentifierXiangfen;
extern TCFilterIdentifier const TCFilterIdentifierWhite;
extern TCFilterIdentifier const TCFilterIdentifierLangman;
extern TCFilterIdentifier const TCFilterIdentifierQingxin;
extern TCFilterIdentifier const TCFilterIdentifierWeimei;
extern TCFilterIdentifier const TCFilterIdentifierFennen;
extern TCFilterIdentifier const TCFilterIdentifierHuaijiu;
extern TCFilterIdentifier const TCFilterIdentifierLandiao;
extern TCFilterIdentifier const TCFilterIdentifierQingliang;
extern TCFilterIdentifier const TCFilterIdentifierRixi;


/**
 Apple官方的做法

 .h 文件中 -------------
 typedef NSString *KLTypeStr NS_STRING_ENUM;
foundation_export 
 FOUNDATION_EXPORT KLTypeStr const KLTypeStringRed;
 FOUNDATION_EXPORT KLTypeStr const KLTypeStringGreen;
 FOUNDATION_EXPORT KLTypeStr const KLTypeStringOrange;

 .m 文件中 --------------
 NSString * const KLTypeStringRed = @"红色";
 NSString * const KLTypeStringGreen = @"绿色";
 NSString * const KLTypeStringOrange = @"橘色";

 */
/// 日期 格式化字符串

typedef NSString * DateFormatString NS_STRING_ENUM;
FOUNDATION_EXPORT DateFormatString const DateFormatYYYYMMDDTHHMMSSSSSZZZ;
FOUNDATION_EXPORT DateFormatString const DateFormatYYYYMMDDTHHMMSSSSS;
FOUNDATION_EXPORT DateFormatString const DateFormatYYYYMMDDTHHMMSS;
FOUNDATION_EXPORT DateFormatString const DateFormatYYYYMMDDHHMMSS;
FOUNDATION_EXPORT DateFormatString const DateFormatYYYYMMDDHHMM;
FOUNDATION_EXPORT DateFormatString const DateFormatYYYYMMDD;
FOUNDATION_EXPORT DateFormatString const DateFormatYYYYMM;
FOUNDATION_EXPORT DateFormatString const DateFormatMMDD;
FOUNDATION_EXPORT DateFormatString const DateFormatHHMMSS;
FOUNDATION_EXPORT DateFormatString const DateFormatHHMM;
FOUNDATION_EXPORT DateFormatString const DateFormatMMSS;

static NSString *yyyyMMddTHHmmssSSSzzz = @"yyyy-MM-dd'T'HH:mm:ss.SSSzzz";
static NSString *yyyyMMddTHHmmssSSS = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
static NSString *yyyyMMddHHmmss = @"yyyy-MM-dd HH:mm:ss";
static NSString *yyyyMMddHHmm = @"yyyy-MM-dd HH:mm";





@interface LSStringEnum : NSObject

@property (readonly, nonatomic) TCFilterIdentifier identifier;
@property (readonly, nonatomic) NSString *lookupImagePath;

@end

NS_ASSUME_NONNULL_END
