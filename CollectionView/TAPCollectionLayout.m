//
//  TAPCollectionLayout.m
//  CollectionView
//
//  Created by Michał Smulski on 12.12.2012.
//  Copyright (c) 2012 tap. All rights reserved.
//

#import "TAPCollectionLayout.h"

static NSString *TAPCollectionLayoutPhotoCellKind = @"photo:cell";
static int const RotationCount = 32;
static int const RotationStride = 3;

@interface TAPCollectionLayout ()

@property (strong) NSDictionary *layoutInfo;
@property (strong) NSArray *rotations;

@end

@implementation TAPCollectionLayout

#pragma mark -
- (void)prepareLayout {
	NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[TAPCollectionLayoutPhotoCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
	
    CGFloat spacingX = self.collectionView.bounds.size.width -
	self.itemInsets.left -
	self.itemInsets.right -
	(self.numberOfColumns * self.itemSize.width);
	
    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1);
	
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
	
    CGFloat originY = floor(self.itemInsets.top +
							(self.itemSize.height + self.interItemSpacingY) * row);
	
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.width);
}

#pragma mark -

// zwaraca atrybuty dla itemow widocznych na ekranie. 
// @param rect to rozmiar aktualnie widocznej czesci kolekcji
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
	
	[self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementId,
														 NSDictionary *elementsInfo, 
														 BOOL *stop) {
		[elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
														  UICollectionViewLayoutAttributes *attributes, 
														  BOOL *stop) {
			// sprawdz czy kolejny item z kolekcji powinien byc widoczny w widocznej czesci kolekcji
			if (CGRectIntersectsRect(rect, attributes.frame)) {
				[allAttributes addObject:attributes];
			}
		}];
	}];
	return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	return self.layoutInfo[TAPCollectionLayoutPhotoCellKind][indexPath];
}

- (CGSize)collectionViewContentSize {
	NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    // make sure we count another row if one is only partially filled
    if ([self.collectionView numberOfSections] % self.numberOfColumns) rowCount++;
	
    CGFloat height = self.itemInsets.top +
	rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
	self.itemInsets.bottom;
	
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (CATransform3D)transformForAlbumPhotoAtIndex:(NSIndexPath*)indexPath {
	int offset = (indexPath.section * RotationStride + indexPath.item);
	return [[self rotations][offset % RotationCount] CATransform3DValue];
}

#pragma mark -


- (void)setup {
	self.itemInsets = UIEdgeInsetsMake(22.0, 22.0, 13.0, 22.0);
	self.itemSize = CGSizeMake(125.0, 125.0);
	self.interItemSpacingY = 12.0;
	self.numberOfColumns = 2;
	
	NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:RotationCount];
	float percentage = 0.0;
	
	for (int i = 0; i < RotationCount; i++) {
		float newPercentage = 0.0;
		do {
			newPercentage = float(arc4random() % 220) - 100) * 0.0001;
		} while (fabsf(percentage - newPercentage) < 0.006);
		percentage = newPercentage;
		
		float angle = 2 * M_PI * (1 + percentage);
		CATransform3D transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
		
		[rotations addObject:[NSValue valueWithCATransform3D:transform]];
	}
	self.rotations = rotations;
}


- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

@end
