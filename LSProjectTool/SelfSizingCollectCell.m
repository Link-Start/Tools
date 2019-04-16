//
//  SelfSizingCollectCell.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/3/7.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "SelfSizingCollectCell.h"
#import "Masonry.h"
#define itemHeight 60

@implementation SelfSizingCollectCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        // 用约束来初始化控件:
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.textLabel];
#pragma mark — 如果使用CGRectMake来布局,是需要在preferredLayoutAttributesFittingAttributes方法中去修改textlabel的frame的
        // self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
#pragma mark — 如果使用约束来布局,则无需在preferredLayoutAttributesFittingAttributes方法中去修改cell上的子控件l的frame
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            make.height.equalTo(@(itemHeight/2));                // 高度
            make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        }];
    }
    return self;
}
#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect rect = [self.textLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, itemHeight) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    rect.size.width +=8;
    rect.size.height+=8;
    attributes.frame = rect;
    return attributes;
}
@end
