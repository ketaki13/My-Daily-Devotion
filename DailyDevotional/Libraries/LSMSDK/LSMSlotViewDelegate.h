//
//  LSMSlotViewDelegate.h
//  LSMSDK
//
//  Copyright (c) 2012 LifeStreet Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSMSlotView;

@protocol LSMSlotViewDelegate <NSObject>

- (void)slotView:(LSMSlotView *)aSlotView didShowAd:(UIView *)aView;

@end
