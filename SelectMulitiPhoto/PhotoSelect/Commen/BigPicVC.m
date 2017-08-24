//
//  BigPicVC.m
//  CarWorld2
//
//  Created by apple-CXTX on 16/11/7.
//  Copyright © 2016年 Ande Lee. All rights reserved.
//

#import "BigPicVC.h"
#import "MRZoomScrollView.h"


@interface BigPicVC ()
{
    UIButton *picBtn;
}

@end

@implementation BigPicVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    __block CGRect frame = self.view.frame;
    NSLog(@"%f",frame.size.width);
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;

    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = self.pic;
        if (height/width >= image.size.height/image.size.width) {
            frame = CGRectMake(0,                                                                                                                                                                                                                                                                                           (height - width*image.size.height/image.size.width)/2, width, width*image.size.height/image.size.width);
        }else {
            frame = CGRectMake((width-height*image.size.width/image.size.height)/2,                                                                                                                                                                                                                                                                                           0, height*image.size.width/image.size.height, height);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MRZoomScrollView *mrzoom = [[MRZoomScrollView alloc] initWithFrame:self.view.frame withImageViewFrame:frame];
            mrzoom.backgroundColor = [UIColor blackColor];
            mrzoom.imageView.image = self.pic;
            [self.view addSubview:mrzoom];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
            
            [mrzoom.imageView addGestureRecognizer:tap];
            mrzoom.imageView.userInteractionEnabled = YES;

        });
    });
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
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
