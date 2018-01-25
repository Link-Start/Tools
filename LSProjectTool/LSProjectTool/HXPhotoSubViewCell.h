//
//  HXPhotoSubViewCell.h
//  微博照片选择
//
//  Created by 洪欣 on 17/2/17.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXPhotoSubViewCellDelegate <NSObject>

- (void)cellDidDeleteClcik:(UICollectionViewCell *)cell;
- (void)cellNetworkingPhotoDownLoadComplete;
@end

@interface HXPhotoSubViewCell : UICollectionViewCell
@property (weak, nonatomic) id<HXPhotoSubViewCellDelegate> delegate;
@property (strong, nonatomic, readonly) UIImageView *imageView;


@end
