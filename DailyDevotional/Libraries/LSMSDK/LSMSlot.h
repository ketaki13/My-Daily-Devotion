//
//  LSMSlot.h
//  LSMSDK
//
//  Copyright (c) 2012-2013 LifeStreet Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSMSlotViewDelegate.h"

// A version of LSM SDK
OBJC_EXTERN NSString *const kLSMSDKVersion;

//! A versions of MRAID ADs.
OBJC_EXTERN NSString *const kLSMMRAIDVersion;

@class LSMNetwork, LSMSlotView;
@protocol LSMSlotDelegate;

//! Slot class that represents a place for a banner view.
@interface LSMSlot : NSObject<LSMSlotViewDelegate>

//! Ads will be shown inside this view.
@property (nonatomic, readonly) LSMSlotView *view;

//! Set this delegate if you wish to be informed about certain events such as:
//! an ad has been received, an error occured and so on. Also, you can improve
//! quality of the ads if you set targeting information to this delegate.
@property (nonatomic, unsafe_unretained) id<LSMSlotDelegate> delegate;

//! An object that holds business-related logic.
@property (nonatomic, strong) LSMNetwork *network;

//! Unique Id for the slot.
@property (nonatomic, readonly) NSString *slotId;

//! Automatically reload the slot after some period of time. Each ad can have
//! its own display duration. By default |autoRefresh| set to YES.
@property (nonatomic, assign) BOOL autoRefresh;

//! Use this property for showing close button on banner AD or interstitial. Default value for banner is <code>NO</code.
//! Default value for interstitial is <code>YES</code>.
@property (nonatomic, strong) NSNumber *showCloseButton;

//! Initialize the slot.
//! @param aDelegate LSMSlotDelegate delegate (optional)
//! @param aSlotID Uniq identificator (required)
//! @aFrame Position and size (required)
- (id)initWithDelegate:(id<LSMSlotDelegate>)aDelegate slotId:(NSString *)aSlotID frame:(CGRect)aFrame;

//! Loads and show the slot. Call this method after you initialize the slot.
- (void)loadAd;

//! Fetchs slot without showing it.
- (void)fetchAd;

//! Shows slot if it was previously fetched.
- (void)showAd;

//! Pause/continue refreshing process. Recommend to call these methods on viewWillAppear/viewWillDisappear
- (void)pauseAd;
- (void)resumeAd;

//! Add |LSMSlotView| to the |view| where you want to display ads.
- (void)addToView:(UIView *)aView;

@end
