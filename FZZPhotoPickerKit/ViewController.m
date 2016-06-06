//
//  ViewController.m
//  FZZPhotoPickerKit
//
//  Created by Administrator on 2016/06/05.
//  Copyright © 2016年 Shota Nakagami. All rights reserved.
//

#import "ViewController.h"
#import "FZZPhotoPickerView.h"

@interface ViewController ()
<FZZPhotoPickerViewDelegate>

@property (nonatomic,strong) FZZPhotoPickerView *photoPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s",__func__);
    self.photoPickerView = [[FZZPhotoPickerView alloc] initWithFrame:self.view.bounds];
    self.photoPickerView.delegate = self;
    [self.view addSubview:self.photoPickerView];
    
}

- (void)viewDidLayoutSubviews{
    [self.photoPickerView updateFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)FZZPhotoPickerView:(FZZPhotoPickerView *)photoPickerView didGetAsset:(PHAsset *)asset{
    NSLog(@"%s",__func__);
}

@end
