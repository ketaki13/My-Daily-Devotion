//
//  LSMAdapterDelegate.h
//  LSMSDK
//
//  Copyright (c) 2012-2013 LifeStreet Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSMBaseAdapter;

@protocol LSMAdapterDelegate <NSObject>

- (NSNumber *)showCloseButton;
- (CGRect)slotViewFrame;
- (UIViewController *)viewControllerForPresentingModalView;
- (void)trackClickForAdapter:(LSMBaseAdapter *)anAdapter;
- (BOOL)runCustomFunction:(NSString *)aFunction withObject:(id)anObject;
- (void)runDeallocCustomFunction:(NSString *)aFunction withObject:(id)anObject;

#pragma mark - Normal ads

- (void)adapter:(LSMBaseAdapter *)adapter didReceiveAd:(UIView *)aView;
- (void)adapter:(LSMBaseAdapter *)adapter didFailToReceiveAd:(UIView *)aView error:(NSError *)anError;
- (void)adapter:(LSMBaseAdapter *)adapter willPresentModalViewFromAd:(UIView *)aView;
- (void)adapter:(LSMBaseAdapter *)adapter didDismissModalViewFromAd:(UIView *)aView;
- (void)adapter:(LSMBaseAdapter *)adapter applicationWillTerminateFromAd:(UIView *)aView;

- (void)adapter:(LSMBaseAdapter *)adapter didCloseAd:(UIView *)aView;

#pragma mark - Interstitial ads

- (void)adapter:(LSMBaseAdapter *)adapter didReceiveInterstitialAd:(NSObject *)anInterstitialAd;
- (void)adapter:(LSMBaseAdapter *)adapter didFailToReceiveInterstitialAd:(NSObject *)ad error:(NSError *)anError;
- (void)adapter:(LSMBaseAdapter *)adapter willPresentInterstitialAd:(NSObject *)anInterstitialAd;
- (void)adapter:(LSMBaseAdapter *)adapter didDismissInterstitialAd:(NSObject *)anInterstitialAd;
- (void)adapter:(LSMBaseAdapter *)adapter applicationWillTerminateFromInterstitialAd:(NSObject *)anInterstitialAd;

#pragma mark - Targeting

- (NSString *)areaCode;
- (NSString *)city;
- (NSString *)country;
- (BOOL)hasLocation;
- (double)latitude;
- (double)longitude;
- (NSString *)metro;
- (NSString *)zip;
- (NSString *)region;
- (NSString *)gender;

@end
