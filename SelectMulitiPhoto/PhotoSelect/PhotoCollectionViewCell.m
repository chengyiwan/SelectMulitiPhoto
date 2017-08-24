//
//  PhotoCollectionViewCell.m
//  SelectMulitiPhoto
//
//  Created by apple-CXTX on 17/8/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import <Photos/Photos.h>

@interface PhotoCollectionViewCell ()
{
    UIImageView *imageView;
}
@end


@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.contentView addSubview:imageView];
    
    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 5, 25, 25)];
   // _selectBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [_selectBtn setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"btn_check_pre"] forState:UIControlStateSelected];
    
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_selectBtn];
}

- (void)setGAssst:(PHAsset *)gAssst {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    _gAssst = gAssst;
    //获取图片
    [[PHImageManager defaultManager] requestImageForAsset:gAssst targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@", result);
        imageView.image = result;
    }];

}

- (void)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(selectPhoto:)]) {
        [self.delegate selectPhoto:self.gAssst];
    }
}

@end
