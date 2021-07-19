//
//  NSString+LSCategory.m
//  LSProjectTool
//
//  Created by Xcode on 16/10/10.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "NSString+LSCategory.h"

#import <CommonCrypto/CommonDigest.h> //MD5加密

@implementation NSString (LSCategory)

/// 判断是否为空
- (BOOL)isNotEmpty {
    return (![(NSNull *)self isEqual:[NSNull null]]
            && [self isKindOfClass:[NSString class]]
            && self.length > 0);
}

/// 去除字符串空格和回车字符
- (NSString *)trimWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/// 是否包含字符
/// set 字符集
/// YES, 包含; Otherwise
- (BOOL)containsCharacterSet:(NSCharacterSet *)set {
    NSRange rang = [self rangeOfCharacterFromSet:set];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/// 是否包含字符串
/// string 字符串
/// YES, 包含; Otherwise
- (BOOL)containsString:(NSString *)string {
    NSRange rang = [self rangeOfString:string];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/// 查找指定字符串出现的次数
- (NSInteger)countOccurencesOfString:(NSString*)searchString {
    NSInteger strCount = [self length] - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / [searchString length];
}


/// 获取字符数量
- (int)wordsCount {
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++) {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

//通过分别计算中文和其他字符来计算长度
- (NSUInteger)getContentLength:(NSString*)content {
    size_t length = 0;
    for (int i = 0; i < [content length]; i++) {
        unichar ch = [content characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            length += 2;
        } else {
            length++;
        }
    }
    return length;
}

/// URL编码
- (NSString *)URLEncodedString {
    NSString *result = (NSString *)CFBridgingRelease
    (CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                             (CFStringRef)self,
                                             NULL,
                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                             kCFStringEncodingUTF8));
    return result;
}

/// URL解码
- (NSString *)URLDecodedString {
    NSString *result = (NSString *)CFBridgingRelease
    (CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                             (CFStringRef)self,
                                                             CFSTR(""),
                                                             kCFStringEncodingUTF8));
    return result;
}

/// URL
- (NSURL *)URL {
    return [NSURL URLWithString:self];
}

/// 文件URL
- (NSURL *)fileURL {
    return [NSURL fileURLWithPath:self];
}

/// MD5加密
- (NSString *)MD5String {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    char md5string[CC_MD5_DIGEST_LENGTH*2];
    int i;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        sprintf(md5string + i*2, "%02X", digest[i]);
    }
    return [NSString stringWithCString:md5string encoding:NSUTF8StringEncoding];
}

/// 是否全是数字
- (BOOL)isNumber {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 是否全是英文字母
- (BOOL)isEnglishWords {
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 是否全是中文汉字
- (BOOL)isChineseWords {
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 是否为邮箱
- (BOOL)isEmail {
    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 是否为网络链接
- (BOOL)isURL {
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 是否为电话号码
/// 3-4位区号, 7-8位直播号码
- (BOOL)isPhoneNumber {
    NSString *regex = @"^(\(\\d{3,4}\\)|\\d{3,4}-)?\\d{7,8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 是否为手机号码
/// 手机号必须1开头
- (BOOL)isMobilePhoneNumber {
    NSString *regex = @"^[1][3-8]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 是否为身份证号码(15或18位)
- (BOOL)isIdentifyCardNumber {
    NSString *regex = @"^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

///  是否为组织机构代码
- (BOOL)isOrganizationCode {
    NSString *regex = @"^[^\u4e00-\u9fa5]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 验证密码(6—18位, 只能包含字符、数字和下划线)
- (BOOL)isValidPassword {
    NSString *regex = @"^[\\w\\d_]{6,18}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 验证名称(只能由中英文、数字、下划线组成)
- (BOOL)isValidName {
    NSString *regex = @"\\w*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 字符串转时间
/// format 时间字符串
- (NSDate *)dateWithFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:self];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return date;
}

/// 计算文字的高度
/// font  字体(默认为系统字体)
/// width 约束宽度
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/// 计算文字的宽度
/// font   字体(默认为系统字体)
/// height 约束高度
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 //当前系统支持的最小版本 < 7
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}

/// 计算文字的大小
/// font  字体(默认为系统字体)
/// width 约束宽度
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 //支持最低的系统版本
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/// 计算文字的大小
/// font   字体(默认为系统字体)
/// height 约束高度
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/// 计算文字高度，可以处理计算带行间距的
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    return rect.size;
}

/// 计算文字高度，可以处理计算带行间距的
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing {
    
    font = font?:[UIFont systemFontOfSize:14];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    return rect.size;
}

/// 计算最大行数文字高度,可以处理计算带行间距的
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines {
    
    if (maxLines <= 0) {
        return 0;
    }
    //  行高 + 行间距
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    //计算文字高度，可以处理计算带行间距的
    CGSize orginalSize = [self boundingRectWithSize:size font:font lineSpacing:lineSpacing];
    
    if (orginalSize.height >= maxHeight) {
        return maxHeight;
    } else {
        return orginalSize.height;
    }
}

/// 计算是否超过一行
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing {
    
    if ([self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight) {
        return YES;
    } else {
        return NO;
    }
}

///计算行数
- (NSInteger)boundingRectNumberOfLineWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing {
    CGFloat h = [self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height;
    NSInteger numberOfLine = (NSInteger)(h/font.lineHeight);
    NSLog(@"行数:_______ :  %ld", numberOfLine);
    
    return numberOfLine;
}

//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

/// 文本字号计算 指定单行字符串高度
/// @param height 返回单行可显示的最大字号
- (CGFloat)fontSizeFromHeight:(CGFloat)height {
    CGFloat fontSize = 0;
    for (int i = 0; i < (int)height ; i++) {
//        CGFloat h = [self strHeightFromWidth:0 font:[UIFont systemFontOfSize:i] str:@"高"];
        CGFloat h = [self heightWithFont:[UIFont systemFontOfSize:i] constrainedToWidth:0];
        if (height - h >= 0) {
            fontSize = i;
        }
    }
    return fontSize;
}

/*********************************************************************************************************************************************************************************************************************/
//https://cloud.tencent.com/developer/article/1668089
/// 使用此方法时请标明源作者：欧阳大哥2013。本方法符合MIT协议规范。
/// github地址：https://github.com/youngsoft
/// 计算简单文本或者属性字符串的自适应尺寸
/// @param fitsSize 指定限制的尺寸，参考UILabel中的sizeThatFits中的参数的意义。
/// @param text 要计算的简单文本NSString或者属性字符串NSAttributedString对象
/// @param numberOfLines 指定最大显示的行数，如果为0则表示不限制最大行数
/// @param font 指定计算时文本的字体，可以为nil表示使用UILabel控件的默认17号字体
/// @param textAlignment 指定文本对齐方式默认是NSTextAlignmentNatural
/// @param lineBreakMode 指定多行时断字模式，默认可以用UILabel的默认断字模式NSLineBreakByTruncatingTail
/// @param minimumScaleFactor 指定文本的最小缩放因子，默认填写0。这个参数用于那些定宽时可以自动缩小文字字体来自适应显示的场景。
/// @param shadowOffset 指定阴影的偏移位置，需要注意的是这个偏移位置是同时指定了阴影颜色和偏移位置才有效。如果不考虑阴影则请传递CGSizeZero，否则阴影会参与尺寸计算。
/// @return 返回自适应的最合适尺寸
CGSize calcTextSize(CGSize fitsSize, id text, NSInteger numberOfLines, UIFont *font, NSTextAlignment textAlignment, NSLineBreakMode lineBreakMode, CGFloat minimumScaleFactor, CGSize shadowOffset) {
    
    if (text == nil || [text length] <= 0) {
        return CGSizeZero;
    }
    
    NSAttributedString *calcAttributedString = nil;

    //如果不指定字体则用默认的字体。
    if (font == nil) {
        font = [UIFont systemFontOfSize:17];
    }
    
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
        
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    //系统大于等于11才设置行断字策略。
    if (systemVersion >= 11.0) {
        @try {
            [paragraphStyle setValue:@(1) forKey:@"lineBreakStrategy"];
        } @catch (NSException *exception) {}
    }
        
    if ([text isKindOfClass:NSString.class]) {
        calcAttributedString = [[NSAttributedString alloc] initWithString:(NSString *)text attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    } else {
        NSAttributedString *originAttributedString = (NSAttributedString *)text;
        //对于属性字符串总是加上默认的字体和段落信息。
        NSMutableAttributedString *mutableCalcAttributedString = [[NSMutableAttributedString alloc] initWithString:originAttributedString.string attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
        
        //再附加上原来的属性。
        [originAttributedString enumerateAttributesInRange:NSMakeRange(0, originAttributedString.string.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            [mutableCalcAttributedString addAttributes:attrs range:range];
        }];
        
        //这里再次取段落信息，因为有可能属性字符串中就已经包含了段落信息。
        if (systemVersion >= 11.0) {
            NSParagraphStyle *alternativeParagraphStyle = [mutableCalcAttributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
            if (alternativeParagraphStyle != nil) {
                paragraphStyle = (NSMutableParagraphStyle*)alternativeParagraphStyle;
            }
        }
        
        calcAttributedString = mutableCalcAttributedString;
    }
    
    //调整fitsSize的值, 这里的宽度调整为只要宽度小于等于0或者显示一行都不限制宽度，而高度则总是改为不限制高度。
    fitsSize.height = FLT_MAX;
    if (fitsSize.width <= 0 || numberOfLines == 1) {
        fitsSize.width = FLT_MAX;
    }
        
    //构造出一个NSStringDrawContext
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = minimumScaleFactor;
    @try {
        //因为下面几个属性都是未公开的属性，所以我们用KVC的方式来实现。
        [context setValue:@(numberOfLines) forKey:@"maximumNumberOfLines"];
        if (numberOfLines != 1) {
            [context setValue:@(YES) forKey:@"wrapsForTruncationMode"];
        }
        [context setValue:@(YES) forKey:@"wantsNumberOfLineFragments"];
    } @catch (NSException *exception) {}
       

    //计算属性字符串的bounds值。
    CGRect rect = [calcAttributedString boundingRectWithSize:fitsSize options:NSStringDrawingUsesLineFragmentOrigin context:context];
    
    //需要对段落的首行缩进进行特殊处理！
    //如果只有一行则直接添加首行缩进的值，否则进行特殊处理。。
    CGFloat firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    if (firstLineHeadIndent != 0.0 && systemVersion >= 11.0) {
        //得到绘制出来的行数
        NSInteger numberOfDrawingLines = [[context valueForKey:@"numberOfLineFragments"] integerValue];
        if (numberOfDrawingLines == 1) {
            rect.size.width += firstLineHeadIndent;
        } else {
            //取内容的行数。
            NSString *string = calcAttributedString.string;
            NSCharacterSet *charset = [NSCharacterSet newlineCharacterSet];
            NSArray *lines = [string componentsSeparatedByCharactersInSet:charset]; //得到文本内容的行数
            NSString *lastLine = lines.lastObject;
            NSInteger numberOfContentLines = lines.count - (NSInteger)(lastLine.length == 0);  //有效的内容行数要减去最后一行为空行的情况。
            if (numberOfLines == 0) {
                numberOfLines = NSIntegerMax;
            }
            if (numberOfLines > numberOfContentLines)
                numberOfLines = numberOfContentLines;
            
            //只有绘制的行数和指定的行数相等时才添加上首行缩进！这段代码根据反汇编来实现，但是不理解为什么相等才设置？
            if (numberOfDrawingLines == numberOfLines) {
                rect.size.width += firstLineHeadIndent;
            }
        }
    }
    
    //取fitsSize和rect中的最小宽度值。
    if (rect.size.width > fitsSize.width) {
        rect.size.width = fitsSize.width;
    }
    
    //加上阴影的偏移
    rect.size.width += fabs(shadowOffset.width);
    rect.size.height += fabs(shadowOffset.height);
       
    //转化为可以有效显示的逻辑点, 这里将原始逻辑点乘以缩放比例得到物理像素点，然后再取整，然后再除以缩放比例得到可以有效显示的逻辑点。
    CGFloat scale = [UIScreen mainScreen].scale;
    rect.size.width = ceil(rect.size.width * scale) / scale;
    rect.size.height = ceil(rect.size.height *scale) / scale;
    
    return rect.size;
}

//上述方法的精简版本
NS_INLINE CGSize calcTextSizeV2(CGSize fitsSize, id text, NSInteger numberOfLines, UIFont *font) {
    return calcTextSize(fitsSize, text, numberOfLines, font, NSTextAlignmentNatural, NSLineBreakByTruncatingTail,0.0, CGSizeZero);
}
/*********************************************************************************************************************************************************************************************************************/


@end
