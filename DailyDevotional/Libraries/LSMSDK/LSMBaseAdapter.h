//
//  LSMBaseAdapter.h
//  LSMSDK
//
//  Copyright (c) 2012-2013 LifeStreet Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSMAdapterDelegate;
@class LSMPixelsTracker;

//! A key for accessing the additional data value from <code>params</code> dictionary.
//! If network data value is present in parameters (usually it needs for "Custom" network type) you can access
//! it in the following way:
//! <code>NSString *theDataValue = [aBaseAdapter.params objectForKey:kLSMDataParameterKey];<code>
//! "theDataValue" can be <code>nil</code>
//! @see params property
extern NSString *const kLSMDataParameterKey;

//! A base implementor fo adapter. If you want to implement your custom adapter it should be inherited from
//! this class.
@interface LSMBaseAdapter : NSObject

//! A delegate object for adapter.
//! @see LSMAdapterDelegate interface for more info.
@property (nonatomic, unsafe_unretained) id<LSMAdapterDelegate> delegate;

@property (nonatomic, strong) LSMPixelsTracker *pixelsTracker;

@property (nonatomic, copy) NSString *transitionAnimation;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) BOOL showCloseButton;

//! Initializes <code>LSMBaseAdapter</code> object with delegate.
//! @see LSMAdapterDelegate interface for more info about which methods delegate must implement.
- (id)initWithDelegate:(id<LSMAdapterDelegate>)aDelegate;
- (void)getAd;

//! Override this method if you want to add behavior for adapter when ad is shown.
- (void)didShowAd;

@end
