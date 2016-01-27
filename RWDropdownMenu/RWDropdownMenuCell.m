//
//  RWDropdownMenuCell.m
//  DirtyBeijing
//
//  Created by Zhang Bin on 14-01-20.
//  Copyright (c) 2014年 Fresh-Ideas Studio. All rights reserved.
//

#import "RWDropdownMenuCell.h"

@implementation RWDropdownMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.currentSelectionView = [UIView new];
        self.currentSelectionView.backgroundColor = [UIColor clearColor];
        self.currentSelectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.currentSelectionView];
        
        self.textLabel = [UILabel new];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textLabel];
        
        self.imageView = [UIImageView new];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.imageView];
        self.backgroundColor = [UIColor clearColor];
        self.imageView.image = nil;
        self.selectedBackgroundView = [UIView new];
        self.imageView.layer.cornerRadius = 8.0;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.clipsToBounds = YES;
        
        self.starImageView = [UIImageView new];
        self.starImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.starImageView];
    }
    
    return self;
}

- (UIColor *)inversedTintColor
{
    CGFloat white = 0, alpha = 0;
    [self.tintColor getWhite:&white alpha:&alpha];
    return [UIColor colorWithWhite:1.2 - white alpha:alpha];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    self.textLabel.textColor = self.tintColor;
    self.selectedBackgroundView.backgroundColor = self.tintColor;
    self.textLabel.highlightedTextColor = [self inversedTintColor];
}

- (void)setIsItemSelected:(BOOL)isItemSelected
{
    _isItemSelected = isItemSelected;
    
    UIColor *selectionColor = isItemSelected ? [UIColor lightGrayColor] : [UIColor clearColor];
    
    self.currentSelectionView.backgroundColor = selectionColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.imageView.tintColor = [self inversedTintColor];
    }
    else
    {
        self.imageView.tintColor = self.tintColor;
    }
}

- (void)setAlignment:(RWDropdownMenuCellAlignment)alignment
{
    _alignment = alignment;
    self.imageView.hidden = (alignment == RWDropdownMenuCellAlignmentCenter);
    switch (_alignment) {
        case RWDropdownMenuCellAlignmentLeft:
            self.textLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case RWDropdownMenuCellAlignmentCenter:
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case RWDropdownMenuCellAlignmentRight:
            self.textLabel.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    
    NSDictionary *views = @{@"selection": self.currentSelectionView, @"text":self.textLabel, @"image":self.imageView, @"star":self.starImageView};
    NSDictionary *metrics = @{@"selectionWidth": @4, @"selectionMarginLeft": @4, @"starTrailingRight": @4};
    
    // vertical centering
    for (UIView *v in [views allValues])
    {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    
    CGFloat margin = 20;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        margin = 25;
    }
    
    // horizontal
    NSString *vfs = nil;
    NSString *heightVfs = @"V:|[selection]|";
    
    switch (self.alignment)
    {
        case RWDropdownMenuCellAlignmentCenter:
            
            vfs = @"H:|-(selectMarginLeft)-[selection(selectionWidth)][text]|";
            
            break;
            
        case RWDropdownMenuCellAlignmentLeft:
            
            vfs = @"H:|-(selectionMarginLeft)-[selection(selectionWidth)]-[image]-[text][star]-(starTrailingRight)-|";
            
            break;
            
        case RWDropdownMenuCellAlignmentRight:
            
            vfs = @"H:|-(selectionMarginLeft)-[selection(selectionWidth)][text]-[image]-[star]-(starTrailingRight)-|";
            
            break;
            
        default:
            
            break;
    }
    
    [self.imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfs options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfs options:0 metrics:metrics views:views]];
}

@end
