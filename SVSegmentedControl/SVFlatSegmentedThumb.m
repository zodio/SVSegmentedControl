//
// SVSegmentedThumb.m
// SVSegmentedControl
//
// Created by Sam Vermette on 25.05.11.
// Copyright 2011 Sam Vermette. All rights reserved.
//
// https://github.com/samvermette/SVSegmentedControl
//

#import "SVFlatSegmentedThumb.h"
#import <QuartzCore/QuartzCore.h>
#import "SVFlatSegmentedControl.h"

@interface SVFlatSegmentedThumb ()

@property (nonatomic, readwrite) BOOL selected;
@property (nonatomic, readonly) SVFlatSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIImageView *thumbBackgroundImageView;
@property (nonatomic, readonly) UIFont *font;

@property (strong, nonatomic, readonly) UILabel *firstLabel;
@property (strong, nonatomic, readonly) UILabel *secondLabel; // when crossFadeLabelsOnDrag == YES
@property (strong, nonatomic, readonly) UIImageView *firstImageView;
@property (strong, nonatomic, readonly) UIImageView *secondImageView; // when crossFadeLabelsOnDrag == YES

@property (nonatomic, readonly) BOOL isAtLastIndex;
@property (nonatomic, readonly) BOOL isAtFirstIndex;

- (void)activate;
- (void)deactivate;

@end


@implementation SVFlatSegmentedThumb {
    UIColor *_tintColor;
}

@synthesize segmentedControl, backgroundImage, highlightedBackgroundImage, font, textColor, selected;
@synthesize firstLabel = _firstLabel;
@synthesize secondLabel = _secondLabel;
@synthesize firstImageView = _firstImageView;
@synthesize secondImageView = _secondImageView;
@synthesize thumbBackgroundImageView = _thumbBackgroundImageView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	
    if (self) {
		self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		self.textColor = [UIColor whiteColor];
		self.tintColor = [UIColor grayColor];
        self.backgroundColor = [UIColor clearColor];
    }
	
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    return CGRectContainsPoint(CGRectMake(bounds.origin.x - self.segmentedControl.touchTargetMargins.left,
                                          bounds.origin.y - self.segmentedControl.touchTargetMargins.top,
                                          bounds.size.width + self.segmentedControl.touchTargetMargins.left + self.segmentedControl.touchTargetMargins.right,
                                          bounds.size.height + self.segmentedControl.touchTargetMargins.bottom + self.segmentedControl.touchTargetMargins.top), point);
}

- (UILabel*)label {
    
    if(_firstLabel == nil) {
        _firstLabel = [[UILabel alloc] initWithFrame:self.bounds];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
		_firstLabel.textAlignment = UITextAlignmentLeft;
#else
        _firstLabel.textAlignment = NSTextAlignmentLeft;
#endif
		_firstLabel.font = self.font;
		_firstLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_firstLabel];
    }
    
    return _firstLabel;
}

- (UILabel*)secondLabel {
    
    if(_secondLabel == nil) {
		_secondLabel = [[UILabel alloc] initWithFrame:self.bounds];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
		_secondLabel.textAlignment = UITextAlignmentLeft;
#else
        _secondLabel.textAlignment = NSTextAlignmentLeft;
#endif
		_secondLabel.font = self.font;
		_secondLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_secondLabel];
    }
    
    return _secondLabel;
}

- (UIImageView *)imageView {
    if(!_firstImageView) {
        _firstImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _firstImageView.layer.shadowOpacity = 1;
        _firstImageView.layer.shadowRadius = 0;
        [self addSubview:_firstImageView];
    }
    return _firstImageView;
}

- (UIImageView *)secondImageView {
    if(!_secondImageView) {
        _secondImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _secondImageView.layer.shadowOpacity = 1;
        _secondImageView.layer.shadowRadius = 0;
        [self addSubview:_secondImageView];
    }
    return _secondImageView;
}

- (UIImageView *)thumbBackgroundImageView {
    if(!_thumbBackgroundImageView) {
        _thumbBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5+self.segmentedControl.thumbEdgeInset.left,
                                                                                  self.segmentedControl.thumbEdgeInset.top,
                                                                                  self.bounds.size.width-10-self.segmentedControl.thumbEdgeInset.left-self.segmentedControl.thumbEdgeInset.right,
                                                                                  self.backgroundImage.size.height)];
        _thumbBackgroundImageView.backgroundColor = [UIColor clearColor];
        [self insertSubview:_thumbBackgroundImageView atIndex:0];
        
        self.clipsToBounds = NO;
        self.segmentedControl.clipsToBounds = NO;
    }
    return _thumbBackgroundImageView;
}

- (SVFlatSegmentedControl *)segmentedControl {
    return (SVFlatSegmentedControl*)self.superview;
}

- (UIFont *)font {
    return self.label.font;
}

- (UIColor*)tintColor {
    return _tintColor;
}


- (void)drawRect:(CGRect)rect {
    CGRect thumbRect = CGRectMake(self.segmentedControl.thumbEdgeInset.left,
                                  self.segmentedControl.thumbEdgeInset.top,
                                  rect.size.width-self.segmentedControl.thumbEdgeInset.left-self.segmentedControl.thumbEdgeInset.right,
                                  rect.size.height-self.segmentedControl.thumbEdgeInset.top-self.segmentedControl.thumbEdgeInset.bottom+1); // 1 is for segmented bottom gloss
    
    thumbRect = CGRectInset(thumbRect, 5, 0); // 5 is for thumb shadow
    
    if(self.backgroundImage && !self.selected) {
        self.thumbBackgroundImageView.image = self.backgroundImage;
    }
    else if(self.highlightedBackgroundImage && self.selected) {
        self.thumbBackgroundImageView.image = self.highlightedBackgroundImage;
    }
    else {
        
        CGFloat cornerRadius = self.segmentedControl.cornerRadius;
        UIBezierPath *thumbRectPath= [UIBezierPath bezierPathWithRoundedRect:thumbRect cornerRadius:cornerRadius-1.5];
        [self.tintColor set];
        [thumbRectPath fill];
    }
}


#pragma mark -
#pragma mark Setters

- (void)setTitle:(NSString*)title image:(UIImage*)image {
    [UIView setAnimationsEnabled:NO];
    
    self.label.text = title;
    self.imageView.image = image;
    [self arrangeLabel:self.label imageView:self.imageView];
    
    [UIView setAnimationsEnabled:YES];
}

- (void)setSecondTitle:(NSString*)title image:(UIImage*)image {
    [UIView setAnimationsEnabled:NO];
    
    self.secondLabel.text = title;
    self.secondImageView.image = image;
    [self arrangeLabel:self.secondLabel imageView:self.secondImageView];

    [UIView setAnimationsEnabled:YES];
}

- (void)arrangeLabel:(UILabel*)label imageView:(UIImageView*)imageView {
    CGSize titleSize = [label.text sizeWithFont:self.font];
    CGFloat titleWidth = titleSize.width;
    CGFloat imageWidth = 0;
    
    if(imageView.image) {
        imageWidth = imageView.image.size.width + (titleSize.width > 0 ? 5 : 0);
        titleWidth += imageWidth;
    }
    
    CGFloat titlePosX = round((self.bounds.size.width-titleWidth)/2);
    
    if(imageView.image)
        imageView.frame = CGRectMake(titlePosX,
                                     round((self.segmentedControl.bounds.size.height-imageView.image.size.height)/2),
                                     imageView.image.size.width,
                                     imageView.image.size.height);
    
    CGFloat posY = round((self.segmentedControl.height-self.font.ascender-5)/2)+self.segmentedControl.titleEdgeInsets.top-self.segmentedControl.titleEdgeInsets.bottom;

    label.frame = CGRectMake(titlePosX+imageWidth,
                             posY,
                             titleWidth,
                             titleSize.height);
}

- (void)setBackgroundImage:(UIImage *)newImage {
    
    if(backgroundImage)
        backgroundImage = nil;
    
    if(newImage) {
        backgroundImage = newImage;
    }
}

- (void)setTintColor:(UIColor *)newColor {
    
    if(_tintColor != newColor)
        _tintColor = newColor;

	[self setNeedsDisplay];
}

- (void)setFont:(UIFont *)newFont {
    self.label.font = newFont;
    self.secondLabel.font = newFont;
}

- (void)setTextColor:(UIColor *)newColor {
    textColor = newColor;
	self.label.textColor = newColor;
    self.secondLabel.textColor = newColor;
}

#pragma mark -

- (void)setFrame:(CGRect)newFrame {
	[super setFrame:newFrame];
        
    CGFloat posY = ceil((self.segmentedControl.height-self.font.pointSize+self.font.descender)/2)+self.segmentedControl.titleEdgeInsets.top-self.segmentedControl.titleEdgeInsets.bottom+2;
	int pointSize = self.font.pointSize;
	
	if(pointSize%2 != 0)
		posY--;
    
	self.label.frame = self.secondLabel.frame = CGRectMake(0, posY, newFrame.size.width, self.font.pointSize);
}

- (void)setSelected:(BOOL)s {
	
	selected = s;
	
	if(selected && !self.segmentedControl.crossFadeLabelsOnDrag && !self.highlightedBackgroundImage)
		self.alpha = 0.8;
	else
		self.alpha = 1;
	
	[self setNeedsDisplay];
}

- (void)activate {
	[self setSelected:NO];
    
    if(!self.segmentedControl.crossFadeLabelsOnDrag) {
        self.label.alpha = 1;
        self.imageView.alpha = 1;
    }
}

- (void)deactivate {
	[self setSelected:YES];
    
    if(!self.segmentedControl.crossFadeLabelsOnDrag) {
        self.label.alpha = 0;
        self.imageView.alpha = 0;
    }
}

- (BOOL)isAtFirstIndex {
    return (CGRectGetMinX(self.frame) < CGRectGetMinX(self.segmentedControl.bounds));
}

- (BOOL)isAtLastIndex {
    return (CGRectGetMaxX(self.frame) > CGRectGetMaxX(self.segmentedControl.bounds));
}

@end
