//
//  MRZoomScrollView.m
//  ZoomView
//
//  Created by apple-CXTX on 16/11/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MRZoomScrollView.h"

#define MRScreenWidth              [UIScreen mainScreen].bounds.size.width
#define MRScreenHeight             [UIScreen mainScreen].bounds.size.height


@interface MRZoomScrollView (Utility)<UIScrollViewDelegate>

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MRZoomScrollView
@synthesize imageView;


- (id)initWithFrame:(CGRect)frame withImageViewFrame : (CGRect)imageViewFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.frame = frame;
        [self initImageView:imageViewFrame];
    }
    
    return self;
}

- (void)initImageView:(CGRect)imageViewFrame
{
    imageView = [[UIImageView alloc]init];
    
    // The imageView can be zoomed largest size
    imageView.frame = CGRectMake(imageViewFrame.origin.x, imageViewFrame.origin.y, imageViewFrame.size.width*2.5, imageViewFrame.size.height*2.5);
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];
    float minimumScale = 1.0;
    if (imageViewFrame.origin.x == 0) {
        minimumScale = self.frame.size.width / imageView.frame.size.width;
    }
    if (imageViewFrame.origin.y == 0) {
        minimumScale = self.frame.size.height / imageView.frame.size.height;
    }
    else {
        minimumScale = self.frame.size.width / imageView.frame.size.width;
    }
    //float minimumScale = self.frame.size.width / imageView.frame.size.width;//判断最小比例是按宽还是按高
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = self.zoomScale * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    //imageView.frame = CGRectMake(center.x - (zoomRect.size.width  / 2.0), center.y - (zoomRect.size.height / 2.0), imageView.frame.size.width, imageView.frame.size.height);
    
    return zoomRect;
}

//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?(self.bounds.size.width-self.contentSize.width)/2:0.0;
    
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?(self.bounds.size.height-self.contentSize.height)/2:0.0;
    
    imageView.center = CGPointMake(self.contentSize.width/2+offsetX, self.contentSize.height/2+offsetY);
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
//{
//    [scrollView setZoomScale:scale animated:NO];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
