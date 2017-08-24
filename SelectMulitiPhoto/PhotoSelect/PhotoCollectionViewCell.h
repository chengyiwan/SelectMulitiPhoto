//
//  PhotoCollectionViewCell.h
//  SelectMulitiPhoto
//
//  Created by apple-CXTX on 17/8/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@protocol PhotoCollectionViewCellDelegate <NSObject>

- (void)selectPhoto:(PHAsset *)asset;

@end


@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak)id <PhotoCollectionViewCellDelegate>delegate;

@property (nonatomic,strong)PHAsset *gAssst;

@property (nonatomic,strong)UIButton *selectBtn;

@end
