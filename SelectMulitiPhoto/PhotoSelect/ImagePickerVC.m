//
//  ImagePickerVC.m
//  SelectMulitiPhoto
//
//  Created by apple-CXTX on 17/8/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ImagePickerVC.h"
#import "PhotoCollectionViewCell.h"
#import "BigPicVC.h"
#import "ShowPicVC.h"
#import <objc/runtime.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height


@interface ImagePickerVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PhotoCollectionViewCellDelegate>
{
    UICollectionView *myCollectView;
    NSArray *keyArray;
    NSMutableArray *selectArray;
}

@end

static char *buttonClickKey;


@implementation ImagePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    keyArray = self.dataDic.allKeys;
    keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result  = [obj1 compare:obj2];
        return result;
    }];
    self.title = @"选择照片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeClick)];
    [self createCollectionView];
}

- (void)completeClick {
    if (self.minCount != 0) {
        if (selectArray.count < self.minCount) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"小于最小张数" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    if (self.maxCount != 0) {
        if (selectArray.count > self.maxCount) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"大于最大张数" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    ShowPicVC *showPicVC = [[ShowPicVC alloc]init];
    showPicVC.picArray = selectArray;
    [self.navigationController pushViewController:showPicVC animated:YES];
    
}

//返回
- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
 
    flowLayout.headerReferenceSize = CGSizeMake(30, 45);
    
    myCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    
    myCollectView.delegate = self;
    myCollectView.dataSource = self;
    
    myCollectView.showsVerticalScrollIndicator = NO;
    myCollectView.showsHorizontalScrollIndicator = NO;
    myCollectView.backgroundColor = [UIColor whiteColor];
    //注册cell
    [myCollectView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册reusableview（相当于section头部view）
    [myCollectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [self.view addSubview:myCollectView];
    
}

#pragma mark - 分类collectionView

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    
    
    for (UIView *subView in headerView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSString *key = keyArray[indexPath.section];
    
    //日期
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH/2, 15)];
    timeLab.text = key;
    timeLab.font = [UIFont systemFontOfSize:15];
    timeLab.textColor = [UIColor lightGrayColor];
    [headerView addSubview:timeLab];
    
    //选中按钮
    UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25 -5, 10, 25, 25)];
    [selectBtn setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"btn_check_pre"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *array = [_dataDic objectForKey:key];
    
    if ([self arrayA:selectArray containsArrayB:array]) {
        selectBtn.selected = YES;
    }else {
        selectBtn.selected = NO;
    }
    
    objc_setAssociatedObject(selectBtn, &buttonClickKey, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [headerView addSubview:selectBtn];
    
    return headerView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = keyArray[indexPath.section];
    
    NSArray *array = [_dataDic objectForKey:key];
    
    PHAsset *asset = array[indexPath.row];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;

    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@", result);
        BigPicVC *picVC = [BigPicVC new];
        picVC.pic = result;
        [self.navigationController pushViewController:picVC animated:YES];
    }];

    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *array = [self.dataDic objectForKey:keyArray[section]];
    return array.count;
}

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView

{
    
    return keyArray.count;
    
}

//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
    return CGSizeMake((self.view.frame.size.width - 3)/4, (self.view.frame.size.width - 3)/4);
    
}


//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}




//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}




//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}


//每个UICollectionView展示的内容

-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath

{
    
    PhotoCollectionViewCell * cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier : @"cell" forIndexPath :indexPath];
    
    cell.delegate = self;
    
    NSString *key = keyArray[indexPath.section];
    
    NSArray *array = [_dataDic objectForKey:key];
    
    PHAsset *asset = array[indexPath.row];
    
    cell.gAssst = asset;
    
    if ([selectArray containsObject:asset]) {
        
        cell.selectBtn.selected = YES;//yes?no

    }else {
        
        cell.selectBtn.selected = NO;//yes?no

    }
    
    return cell;

}

//区间勾选按钮
- (void)selectBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    NSString *key = objc_getAssociatedObject(sender, &buttonClickKey);
    //根据key寻找点击的是哪个区间
    NSArray *array = [self.dataDic objectForKey:key];
    
    if (sender.selected) {
        
        for (PHAsset *asset in array) {
            if (![selectArray containsObject:asset]) {
                [selectArray addObject:asset];
            }
        }
        if (self.maxCount == 0) {
            
        }else {
            if (selectArray.count > self.maxCount) {
                for (PHAsset *asset in array) {
                    if ([selectArray containsObject:asset]) {
                        [selectArray removeObject:asset];
                    }
                }
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"超过最大张数" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];

            }

        }
        
    }else {
        
        for (PHAsset *asset in array) {
            if ([selectArray containsObject:asset]) {
                [selectArray removeObject:asset];
            }
        }
    }
    self.title = [NSString stringWithFormat:@"选择%lu张照片",selectArray.count];
    if (selectArray.count == 0) {
        self.title = @"选择照片";
    }
    [myCollectView reloadData];
}

//cell勾选按钮
- (void)selectPhoto:(PHAsset *)asset {
    if ([selectArray containsObject:asset]) {
        [selectArray removeObject:asset];
    }else {
        
        if (self.maxCount == 0) {
            [selectArray addObject:asset];
        }else {
            if (selectArray.count == self.maxCount) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"超过最大张数" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                
                }else {
                [selectArray addObject:asset];
            }
        }
        
    }
    self.title = [NSString stringWithFormat:@"选择%lu张照片",selectArray.count];
    if (selectArray.count == 0) {
        self.title = @"选择照片";
    }

    [myCollectView reloadData];
}

//判断数组a是否包含数组b
- (BOOL)arrayA:(NSArray *)arrayA containsArrayB:(NSArray *)arrayB {
    NSSet *seta = [NSSet setWithArray:arrayA];
    NSSet *setb = [NSSet setWithArray:arrayB];
    
    if ([setb isSubsetOfSet:seta]) {
        return YES;
    } else {
        return NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
