//
//  LSMSlotInterstitial.h
//  LSMSDK
//
//  Copyright (c) 2013 LifeStreet Media. All rights reserved.
//

#import "LSMSlot.h"

//! Slot class that represents a place for an entire screen for interstitial ads.
@interface LSMSlotInterstitial : LSMSlot

//! Initialize the interstitial slot.
//! @param aDelegate LSMSlotDelegate delegate (optional)
//! @param aSlotID Uniq identificator (required)
- (id)initWithDelegate:(id<LSMSlotDelegate>)aDelegate slotId:(NSString *)aSlotID;

@end
