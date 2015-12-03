//
//  LSMSlotView.h
//  LSMSDK
//
//  Copyright (c) 2012-2013 LifeStreet Media. All rights reserved.
//

#import <UIKit/UIKit.h>

OBJC_EXPORT NSString * const kLSMDefaultTransitionAnimation;

@protocol LSMSlotViewDelegate;

//! Represents an integration type of SDK.
typedef enum
{
	//! A publisher integrates AdMob Mediation SDK and use LSMSDK adapter to integrate our SDK.
	kLSMIntegrationAdMob,
	
	//! A publisher deals with our SDK directly and integrate it in his applicaton.
	kLSMIntegrationLSMSDKDirect
} LSMIntegrationType;

@interface LSMSlotView : UIView

//! Initializes with delegate and frame of slot view.
//! @see LSMSlotViewDelegate
- (id)initWithDelegate:(id<LSMSlotViewDelegate>)aDelegate frame:(CGRect)aRect;

//! Delegate of slot view.
@property (nonatomic, unsafe_unretained) id<LSMSlotViewDelegate> delegate;

//! Perform transititon with specific animation to view.
- (void)transitionToView:(UIView *)aView animation:(NSString *)anAnimationType;

//! Removes ad view from superview.
- (void)removeAdView;

//! @see LSMIntegrationType type for more info.
//! Default value: kLSMIntegrationLSMSDKDirect
@property (nonatomic, assign) LSMIntegrationType integrationType;

//! Checks if slot view is currently inside the window.
@property (nonatomic, assign) BOOL isSlotViewVisible;

@end
