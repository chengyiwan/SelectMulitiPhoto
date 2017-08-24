//
//  ImagePickerVC.h
//  SelectMulitiPhoto
//
//  Created by apple-CXTX on 17/8/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerVC : UIViewController

@property (nonatomic,strong)NSMutableDictionary *dataDic;//图片数据

@property (nonatomic,assign)NSInteger maxCount;//最大图片数量(0为不限制)

@property (nonatomic,assign)NSInteger minCount;//最小图片数量(0为不限制)

@end
