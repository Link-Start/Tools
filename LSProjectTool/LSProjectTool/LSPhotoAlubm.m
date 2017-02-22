//
//  LSPhotoAlubm.m
//  LSProjectTool
//
//  Created by Xcode on 16/12/7.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

//一共有两种方法自定义相册
//第一种是iOS9之后过期的 <AssetsLibrary/AssetsLibrary.h>苹果原生框架
//第二种是iOS8推出的<Photos/Photos.h> 苹果原生框架,功能更多,但是只支持iOS8之后的版本
//一般推荐使用<Photos/Photos.h>

#import "LSPhotoAlubm.h"

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h> 


static NSString *ls_groupNameKey = @"nameKey";
static NSString *ls_defaultGroupName = @"文件夹的名字";

@interface LSPhotoAlubm ()

@property (nonatomic, strong) ALAssetsLibrary *library;

@property (nonatomic, strong) UIImage *image;
@end

@implementation LSPhotoAlubm


///保存
- (void)save {
    //获取文件夹的名字
    __block NSString *groupName = [self groupName];
    
     __weak __typeof(self)weakSelf = self;
    
    //图片库
    __weak ALAssetsLibrary *weakLibrary = self.library;
    
    //创建自定义的相册
    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
        
        if (group) { //新创建的文件夹
            //直接把图片添加到文件夹中
            [weakSelf addImageToGroup:group];
            
        } else {
            //遍历相册中的每一个文件夹
            [weakLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                //取出文件夹的名字
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                
                if ([name isEqualToString:groupName]) { //如果相等,那么就是自己创建的文件夹
                    
                    //添加图片到文件夹中
                    [weakSelf addImageToGroup:group];
                    
                    *stop = YES;//将图片添加到文件中就停止遍历
                } else if ([name isEqualToString:@"Camera Roll"]) {
                    
                    //文件夹被用户强制删除了,(拼接一个空格就是不同的文件夹的名字)
                    groupName = [groupName stringByAppendingString:@" "];
                    
                    //储存新的名字
                    [[NSUserDefaults standardUserDefaults] setObject:groupName forKey:ls_groupNameKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //创建新的文件夹
                    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
                        
                        //添加图片到文件夹中
                        [weakSelf addImageToGroup:group];
                        
                    } failureBlock:^(NSError *error) {
                        
                    }];
                }
            } failureBlock:^(NSError *error) {
            }];
        }
    } failureBlock:^(NSError *error) {
    }];
}

///添加一张图片到文件夹中
- (void)addImageToGroup:(ALAssetsGroup *)group {
    
    __weak ALAssetsLibrary *weakLibrary = self.library;
    //需要保存的图片
    CGImageRef imageRef = self.image.CGImage;
    
    //添加图片到相机胶卷
    [weakLibrary writeImageToSavedPhotosAlbum:imageRef metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
       
        // asset就是一张照片
        [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            //将照片保存到自定的文件夹中
            [group addAsset:asset];
 
        } failureBlock:nil];
        
    }];
    
}


- (ALAssetsLibrary *)library {
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (NSString *)groupName {
    //先从沙盒中取得名字
    NSString *groupName = [[NSUserDefaults standardUserDefaults] stringForKey:ls_groupNameKey];
    
    if (!groupName) { //如果沙盒中取不到这个key值(文件夹的名字)
        groupName = ls_defaultGroupName;
        
        //储存名字到沙盒里面
        [[NSUserDefaults standardUserDefaults] setObject:groupName forKey:ls_groupNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];//立即保存
    }
    
    return groupName;
}

@end
