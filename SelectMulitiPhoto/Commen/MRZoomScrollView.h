//
//  MRZoomScrollView.h
//  ZoomView
//
//  Created by apple-CXTX on 16/11/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRZoomScrollView : UIScrollView
{
    UIImageView *imageView;
}

@property (nonatomic, assign) CGRect imageViewframe;
@property (nonatomic, strong) UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame withImageViewFrame : (CGRect)imageViewFrame;

@end
