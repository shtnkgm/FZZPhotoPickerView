//
//  FZZPhotoPickerView.h
//  FZZPhotoPickerKit
//
//  Created by Administrator on 2016/06/06.
//  Copyright © 2016年 Shota Nakagami. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@protocol FZZPhotoPickerViewDelegate;

@interface FZZPhotoPickerView : UIView

@property (nonatomic, weak) id<FZZPhotoPickerViewDelegate> delegate;

- (void)updateFrame:(CGRect)frame;
- (void)updateContents;

@end

@protocol FZZPhotoPickerViewDelegate <NSObject>

- (void)FZZPhotoPickerView:(FZZPhotoPickerView *)photoPickerView
               didGetAsset:(PHAsset *)asset;

@end
