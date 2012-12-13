//
//  TAPCollectionLayout.h
//  CollectionView
//
//  Created by Michał Smulski on 12.12.2012.
//  Copyright (c) 2012 tap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAPCollectionLayout : UICollectionViewLayout

@property (unsafe_unretained) UIEdgeInsets itemInsets;
@property (unsafe_unretained) CGSize itemSize;
@property (unsafe_unretained) CGFloat interItemSpacingY;
@property (unsafe_unretained) int numberOfColumns;

@end
