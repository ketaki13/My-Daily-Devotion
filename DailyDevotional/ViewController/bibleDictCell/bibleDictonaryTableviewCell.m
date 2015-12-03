//
//  bibleDictonaryTableviewCell.m
//  DailyDevotional
//
//  Created by ketaki on 6/18/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "bibleDictonaryTableviewCell.h"

@implementation bibleDictonaryTableviewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // (2)
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    // (3)
    self.lblValue.preferredMaxLayoutWidth = CGRectGetWidth(self.lblValue.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
