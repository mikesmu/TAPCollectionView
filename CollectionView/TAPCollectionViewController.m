//
//  TPViewController.m
//  CollectionView
//
//  Created by Michał Smulski on 12.12.2012.
//  Copyright (c) 2012 tap. All rights reserved.
//

#import "TAPCollectionViewController.h"
#import "TAPCollectionLayout.h"
#import "TAPPhotoCell.h"
#import "BHAlbum.h"
#import "BHPhoto.h"

static NSString * const TAPPhotoCellId = @"photo:cell";

@interface TAPCollectionViewController ()

@property (weak) IBOutlet TAPCollectionLayout *collectionLayout;
@property (strong) NSMutableArray *albums;
@property (strong) NSOperationQueue *thumbnailQueue;

@end

@implementation TAPCollectionViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		self.collectionLayout.numberOfColumns = 3;
		
		CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136 ? 45.0 : 25.0;
		
		self.collectionLayout.itemInsets = UIEdgeInsetsMake(22.0, 22.0, 13.0, sideInset);
	} else {
		self.collectionLayout.numberOfColumns = 2;
		self.collectionLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
	}
	[[self collectionLayout] invalidateLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.collectionView.backgroundColor = [UIColor colorWithWhite:0.250 alpha:1.000];
	
	[[self collectionView] registerClass:[TAPPhotoCell class]
			  forCellWithReuseIdentifier:TAPPhotoCellId];
	//////////////////////////////////////////////////////////////////////////////////////////////
	self.albums = [NSMutableArray new];
	
	NSURL *prefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
	
	int index = 0;
	
	for (int i = 0; i < 12; i++) {
		BHAlbum *album = [BHAlbum new];
		album.name = [NSString stringWithFormat:@"Album %d", i+1];
		
		int photoCount = 1;
		for (int p = 0; p < photoCount; p++) {
			NSString *filename = [NSString stringWithFormat:@"thumbnail%d.jpg", index % 25];
			NSURL *url = [prefix URLByAppendingPathComponent:filename];
			BHPhoto *photo = [BHPhoto photoWithImageURL:url];
			[album addPhoto:photo];
			
			index++;
		}
		
		[self.albums addObject:album];
	}
	//////////////////////////////////////////////////////////////////////////////////////////////
	self.thumbnailQueue = [[NSOperationQueue alloc] init];
	self.thumbnailQueue.maxConcurrentOperationCount = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return [[(BHAlbum*)self.albums[section] photos] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	TAPPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TAPPhotoCellId
																   forIndexPath:indexPath];
	
	BHAlbum *album = self.albums[indexPath.section];
	BHPhoto *photo = album.photos[indexPath.item];
	
	__weak TAPCollectionViewController *me = self;
	
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		UIImage *image = [photo image];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if ([me.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
				TAPPhotoCell *cell = (TAPPhotoCell*)[me.collectionView cellForItemAtIndexPath:indexPath];
				cell.imageView.image = image;
			}
		});
	}];
	
	[self.thumbnailQueue addOperation:operation];
	
	return cell;
}
#pragma mark -

@end
