//
//  GGProgressView.m
//
//  Created by GG on 2016/10/20.
//  Copyright © 2016年 GG. All rights reserved.
//

#import "GGProgressView.h"


@interface GGProgressView()

@property (nonatomic, strong) UIView *progressView;

//@property (nonatomic, assign) float progress;

@end

@implementation GGProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame progressViewStyle:GGProgressViewStyleDefault];
}

- (instancetype)initWithFrame:(CGRect)frame progressViewStyle:(GGProgressViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        self.progress = 0;
        self.progressViewStyle = style;
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)setProgressViewStyle:(GGProgressViewStyle)progressViewStyle {
    
    _progressViewStyle = progressViewStyle;
    
    if (progressViewStyle == GGProgressViewStyleTrackFillet) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.bounds.size.height / 2;
        
    } else if (progressViewStyle==GGProgressViewStyleAllFillet) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.bounds.size.height / 2;
        _progressView.layer.cornerRadius = self.bounds.size.height / 2;
    }
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    
    _trackTintColor = trackTintColor;
    
    if (self.trackImage) {
        
    } else {
        self.backgroundColor = trackTintColor;
    }
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    _progress = MIN(progress, 1.0);// 最大只能是1
    _progressView.frame = CGRectMake(0, 0, self.bounds.size.width * _progress, self.bounds.size.height);
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    
    _progressTintColor = progressTintColor;
    _progressView.backgroundColor = progressTintColor;
}

- (void)setTrackImage:(UIImage *)trackImage {
    _trackImage = trackImage;
    
    if (self.isTile) {
        self.backgroundColor = [UIColor colorWithPatternImage:trackImage];
    } else {
        self.backgroundColor = [UIColor colorWithPatternImage:[self stretchableWithImage:trackImage]];
    }
}

- (void)setIsTile:(BOOL)isTile {
    _isTile = isTile;
    if (self.progressImage) {
        [self setProgressImage:self.progressImage];
    }
    if (self.trackImage) {
        [self setTrackImage:self.trackImage];
    }
}

- (void)setProgressImage:(UIImage *)progressImage {
    _progressImage = progressImage;
    
    if(self.isTile) {
        _progressView.backgroundColor = [UIColor colorWithPatternImage:progressImage];
    } else {
        _progressView.backgroundColor = [UIColor colorWithPatternImage:[self stretchableWithImage:progressImage]];
    }
}

- (UIImage *)stretchableWithImage:(UIImage *)image {
    if (@available(iOS 17.0, *)) {
        UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
        format.opaque = NO;
        format.scale = 0.f;
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:self.frame.size format:format];
        UIImage *lastImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
//            CGContextRef context = rendererContext.CGContext;
            [image drawInRect:self.bounds];
        }];
        return lastImage;
    } else {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.f);
        [image drawInRect:self.bounds];
        UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return lastImage;
    }
}

@end
