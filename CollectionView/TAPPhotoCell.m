//
//  TAPPhotoCell.m
//  CollectionView
//
//  Created by Michał Smulski on 12.12.2012.
//  Copyright (c) 2012 tap. All rights reserved.
//

#import "TAPPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

@interface TAPPhotoCell ()

@property (strong, readwrite) UIImageView *imageView;

@end

@implementation TAPPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.000];
		
		self.layer.borderColor = [UIColor whiteColor].CGColor;
		self.layer.borderWidth = 3.0;
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowRadius = 3.0;
		self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
		self.layer.shadowOpacity = 0.5;
		
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		
		[self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.imageView.image = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
