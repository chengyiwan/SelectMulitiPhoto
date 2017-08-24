//
//  ShowPicVC.m
//  SelectMulitiPhoto
//
//  Created by apple-CXTX on 17/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShowPicVC.h"
#import <Photos/Photos.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height


@interface ShowPicVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTable;
}

@end

@implementation ShowPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"show";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}

- (void)createTableView {
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:myTable];
}

#pragma mark - tableViewDlegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.picArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PHAsset *asset = self.picArray[indexPath.row];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    //获取图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@", result);
        cell.imageView.image = result;
    }];
    

    cell.textLabel.text = [self dateToString:asset.creationDate withDateFormat:@"yyyy-MM-dd"];
    
    CLLocationCoordinate2D coor = asset.location.coordinate;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"坐标:%f,%f",asset.location.coordinate.latitude,asset.location.coordinate.longitude];
    if (coor.latitude == 0) {
        cell.detailTextLabel.text = @"该图片无坐标";
    }
    
    return cell;
}

//日期格式转字符串
- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
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
