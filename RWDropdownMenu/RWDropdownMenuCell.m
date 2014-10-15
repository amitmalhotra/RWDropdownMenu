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
    self = [super initWithFrame:frame];
    if (self)
    {
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
        //self.starImageView.hidden=YES;
        
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

/*
- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        self.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    else
    {
        self.tintColor = nil;
    }
    [super setSelected:selected];
}
 */

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
    NSDictionary *views = @{@"text":self.textLabel, @"image":self.imageView, @"star":self.starImageView};
    
    // vertical centering
    for (UIView *v in [views allValues])
    {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    
    CGFloat margin = 20;
    CGFloat textWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 200 : [UIScreen mainScreen].bounds.size.width-120;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        margin = 25;
    }
    
    // horizontal
    NSString *vfs = nil;
    switch (self.alignment) {
        case RWDropdownMenuCellAlignmentCenter:
            vfs = @"H:|[text]|";
            break;
            
        case RWDropdownMenuCellAlignmentLeft:
            vfs = [NSString stringWithFormat:@"H:|-[image]-(15)-[text(%f)]-(15)-[star]", textWidth];
            //vfs = @"H:|-[image]-(15)-[text(240.0)]";
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:margin]];
            break;
            
        case RWDropdownMenuCellAlignmentRight:
            vfs = @"H:|[text]-(15)-[image]";
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-margin]];
            break;
            
        default:
            break;
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfs options:0 metrics:nil views:views]];
}

@end
