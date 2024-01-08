//
//  富文本.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/13.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#ifndef ____h
#define ____h
https://www.jianshu.com/p/ae795de53308

最近想实现一个功能,如图:


每月价格
最初实现的时候想到了用两个Label,来实现,第一个显示¥4000,设置一个字体,第二个显示/月,设置另一个字体.这样就能实现这个效果了,但是最后想一想还是用富文本比较好,顺便可以学习一下.

今天我们先实现这个简单的效果.
先创建一个Label:

-(UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = kFONT(13);
        _priceLabel.textColor = kColorTheme;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
自己再创建一个私有方法,把字符串(比如:¥4000/月)传进来,进行转换,返回富文本,赋值给所需要的Label.

-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range = [string rangeOfString:@"/"];
    NSRange pointRange = NSMakeRange(0, range.location);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    //赋值
    [attribut addAttributes:dic range:pointRange];
    return attribut;
}
首先创建一个富文本NSMutableAttributedString对象,把传进来的NSString对象转化为NSMutableAttributedString对象.
然后对NSMutableAttributedString进行设置.
NSRange range = [string rangeOfString:@"/"];取到一个标志的位置:range,然后对"/"前面的文字进行设置.

然后,返回富文本,再进行赋值.

  _priceLabel.attributedText = [self getPriceAttribute:@"¥4000/月"];
上面只是一个简单应用,还有很多常用到的富文本.比如,文字和图片的混排,文字点击事件.等等.

我们依次实现一些功能

在指定位置添加图片

NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:@"不要问我为什么编程,我喜欢手指在键盘上飞舞的感觉"];
[attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 5)];
[attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 5)];
添加图片到指定的位置

NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
// 表情图片
attchImage.image = [UIImage imageNamed:@"pic3"];
// 设置图片大小
attchImage.bounds = CGRectMake(0, -5, 20, 20);
NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
[attriStr insertAttributedString:stringImage atIndex:2];
追加图片到最后一位

NSTextAttachment *attch = [[NSTextAttachment alloc] init];
// 表情图片
attch.image = [UIImage imageNamed:@"pic2"];
// 设置图片大小
attch.bounds = CGRectMake(0, -5, 20, 15);
// 创建带有图片的富文本
NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
[attriStr appendAttributedString:string];
设置中间位置文字为红色

[attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 4)];
[attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(6, 4)];
综合写法

NSDictionary * attriBute = @{NSForegroundColorAttributeName:[UIColor yellowColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
[attriStr addAttributes:attriBute range:NSMakeRange(10, 4)];
self.attrobiuteLabel.attributedText = attriStr;

效果图:


效果图
最后认识一下各个属性的意思:


// NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
// NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
// NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
// NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
// NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
// NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
// NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
// NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
// NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
// NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
// NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
// NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
// NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
// NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
// NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
// NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
// NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
// NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
// NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
// NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
// NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象

格式&排版

上面属性的最后一个就是排版.需要去一NSMutableParagraphStyle的对象.直接上代码:

NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
paragraphStyle.alignment = aligent;
paragraphStyle.lineSpacing = lineSpace; // 调整行间距
paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;//首行缩进
NSRange range = NSMakeRange(0, [string length]);
[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
我们再来认识一下NSMutableParagraphStyle的属性:

CGFloat lineSpacing;                 // 字体的行间距
CGFloat paragraphSpacing;            // 段与段之间的间距
NSTextAlignment alignment;           // (两端对齐的)文本对齐方式(左,中,右,两端对齐,自然)
CGFloat firstLineHeadIndent;         // 首行缩进
CGFloat headIndent;                  // 整体缩进(首行除外)
CGFloat tailIndent;                  // 尾部缩进
NSLineBreakMode lineBreakMode;       // 结尾部分的内容以……方式省略
CGFloat minimumLineHeight;           // 最低行高
CGFloat maximumLineHeight;           // 最大行高
NSWritingDirection baseWritingDirection; // 书写方向
CGFloat lineHeightMultiple;          // 行间距多少倍
CGFloat paragraphSpacingBefore;      // 段首行空白空
float hyphenationFactor;             // 连字属性 在iOS，唯一支持的值分别为0和1
设置了这么多的格式,进行了各种各样的排版那么怎么计算行高呢.

- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 6_0);
是苹果推荐的计算方法，显然会遇到段落格式问题，例如行间距、缩进等格式设置需求，attributes传进来的字典中，包含我们设置的字体及格式，其中NSParagraphStyleAttributeName是设置段落风格，NSFontAttributeName是设置字体。


byWordWrapping ： 以单词为单位换行，以单词为单位截断。
byCharWrapping ：以字符为单位换行，以字符为单位截断。
byClipping ： 以单词为单位换行，以字符为单位截断。
byTruncatingHead ： 以单词为单位换行, 如果是单行，则开始部分有省略号。如果是多行，则中间有省略号。
byTruncatingTail ： 以单词为单位换行, 无论是单行还是多行，都是末尾有省略号。
byTruncatingMiddle ： 以单词为单位换行, 无论是单行还是多行，都是中间有省略号






UILineBreakModeWordWrap = 0,
以单词为单位换行，以单词为单位截断。

UILineBreakModeCharacterWrap,
以字符为单位换行，以字符为单位截断。

label.lineBreakMode = NSLineBreakByCharWrapping;
以字符为显示单位显示，后面部分省略不显示。

label.lineBreakMode = NSLineBreakByClipping;
剪切与文本宽度相同的内容长度，后半部分被删除。

label.lineBreakMode = NSLineBreakByTruncatingHead;
前面部分文字以……方式省略，显示尾部文字内容。

label.lineBreakMode = NSLineBreakByTruncatingMiddle;
中间的内容以……方式省略，显示头尾的文字内容。

label.lineBreakMode = NSLineBreakByTruncatingTail;
结尾部分的内容以……方式省略，显示头的文字内容。

label.lineBreakMode = NSLineBreakByWordWrapping;
以单词为显示单位显示，后面部分省略不显示。















#endif /* ____h */
