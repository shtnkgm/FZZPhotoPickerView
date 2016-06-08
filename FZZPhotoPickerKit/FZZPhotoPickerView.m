//
//  FZZPhotoPickerView.m
//  FZZPhotoPickerKit
//
//  Created by Administrator on 2016/06/06.
//  Copyright © 2016年 Shota Nakagami. All rights reserved.
//

#import "FZZPhotoPickerView.h"
#import <Photos/Photos.h>

@interface FZZPhotoPickerView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) PHFetchResult *imageAssets;
@property (nonatomic, assign) CGFloat cellWidth;

@end

@implementation FZZPhotoPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初期化
        self.backgroundColor = [UIColor clearColor];
        self.cellWidth = [self getCellWidth];
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 1.0f;
        layout.minimumLineSpacing = 1.0f;
        layout.itemSize = CGSizeMake(self.cellWidth,self.cellWidth);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)
                                                 collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self addSubview:self.collectionView];
        
        [self updateContents];
    }
    return self;
}

- (void)updateFrame:(CGRect)frame{
    self.frame = frame;
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
}

- (void)updateContents{
    self.imageAssets = [self fetchAssetsOfSmartAlbumWithSubtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary];
    [self.collectionView reloadData];
}

- (PHFetchResult *)fetchAssetsOfSmartAlbumWithSubtype:(PHAssetCollectionSubtype)subtype{
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                               subtype:subtype
                                                                               options:nil];
    
    if(assetCollections.count == 0){
        return nil;
    }
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    
    return [PHAsset fetchAssetsInAssetCollection:assetCollections.firstObject options:fetchOptions];
}

#pragma mark UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //コレクションビューのセクション数
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //セクション内のアイテム数
    return self.imageAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //コレクションビューのセル
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                           forIndexPath:indexPath];
    UIImageView *imageView = [UIImageView new];
    imageView.frame = cell.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = NO;
    imageView.clipsToBounds = YES;
    cell.backgroundView = imageView;

    PHImageRequestOptions *options = [PHImageRequestOptions new];
    // 同期処理にする場合にはYES (デフォルトはNO)
    options.synchronous = YES;
    
    CGFloat retina = [[UIScreen mainScreen] scale];
    CGFloat imageWidth = self.cellWidth * retina;
    
    PHAsset * asset = self.imageAssets[indexPath.row];
    
    //アセットから画像を取得
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(imageWidth,imageWidth)
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (result) {
                                                    //NSLog(@"%f",result.size.width);
                                                    imageView.image = result;
                                                }else{
                                                    NSLog(@"No Image");
                                                }
                                            }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake(self.cellWidth,self.cellWidth);
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cell.contentView.backgroundColor = nil;
                     }completion:^(BOOL finished){
                         
                     }];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.imageAssets[indexPath.row];
    [self.delegate FZZPhotoPickerView:self didGetAsset:asset];
}

- (CGFloat)getCellWidth{
    //1つのセルあたりのサイズを計算(横幅に4つ収まるようにする)
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSUInteger borderWidth = 1;
    NSUInteger divisionNumber = 4;
    CGFloat cellWidth = (screenSize.size.width - borderWidth * (divisionNumber - 1)) / divisionNumber;
    return cellWidth;
}



@end
