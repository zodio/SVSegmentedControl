//
// SWSegmentedControl.h
// SWSegmentedControl
//
// Created by Sam Vermette on 26.10.10.
// Copyright 2010 Sam Vermette. All rights reserved.
//
// https://github.com/samvermette/SVSegmentedControl
//

// Edited by Wojciech Czekalski in order to flatify the control

#import <UIKit/UIKit.h>
#import "SVFlatSegmentedThumb.h"
#import <AvailabilityMacros.h>

@protocol SVSegmentedControlDelegate;

@interface SVFlatSegmentedControl : UIControl

@property (nonatomic, copy) void (^changeHandler)(NSUInteger newIndex); // you can also use addTarget:action:forControlEvents:
@property (nonatomic, copy) NSArray *sectionTitles;
@property (nonatomic, copy) NSArray *sectionImages;

@property (nonatomic, strong, readonly) SVFlatSegmentedThumb *thumb;
@property (nonatomic, readonly) NSUInteger selectedSegmentIndex; // default is 0
@property (nonatomic, readwrite) BOOL animateToInitialSelection; // default is NO
@property (nonatomic, readwrite) BOOL crossFadeLabelsOnDrag; // default is NO

@property (nonatomic, readwrite) BOOL mustSlideToChange; // default is NO - To make the control difficult to accidentally change, force the user to slide it
@property (nonatomic, readwrite) CGFloat minimumOverlapToChange; // default is 0.66 - Only snap to a new segment if the thumb overlaps it by this fraction
@property (nonatomic, readwrite) UIEdgeInsets touchTargetMargins; // default is UIEdgeInsetsMake(0, 0, 0, 0) - Enlarge touch target of control

@property (nonatomic, strong) UIColor *backgroundTintColor; // default is [UIColor colorWithWhite:0.1 alpha:1]
@property (nonatomic, strong) UIImage *backgroundImage; // default is nil

@property (nonatomic, readwrite) CGFloat height; // default is 32.0
@property (nonatomic, readwrite) UIEdgeInsets thumbEdgeInset; // default is UIEdgeInsetsMake(2, 2, 3, 2)
@property (nonatomic, readwrite) UIEdgeInsets titleEdgeInsets; // default is UIEdgeInsetsMake(0, 10, 0, 10)
@property (nonatomic, readwrite) CGFloat cornerRadius; // default is 4.0

@property (nonatomic, strong) UIFont *font; // default is [UIFont boldSystemFontOfSize:15]
@property (nonatomic, strong) UIColor *textColor; // default is [UIColor grayColor];

- (SVFlatSegmentedControl*)initWithSectionTitles:(NSArray*)titlesArray;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;

// deprecated
@property (nonatomic, readwrite) NSUInteger selectedIndex __attribute__((deprecated("use 'setSelectedSegmentIndex:animated:' instead")));
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated __attribute__((deprecated("use 'setSelectedSegmentIndex:animated:' instead")));
- (void)moveThumbToIndex:(NSUInteger)segmentIndex animate:(BOOL)animate __attribute__((deprecated("use 'setSelectedSegmentIndex:animated:' instead")));

@end


@protocol SVSegmentedControlDelegate

- (void)segmentedControl:(SVFlatSegmentedControl*)segmentedControl didSelectIndex:(NSUInteger)index;

@end
