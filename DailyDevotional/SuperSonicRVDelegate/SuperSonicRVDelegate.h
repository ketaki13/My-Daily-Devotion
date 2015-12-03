//
//  SuperSonicRVDelegate.h
//  DailyDevotional
//
//  Created by ketaki on 9/15/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Supersonic/Supersonic.h>
#import "AppDelegate.h"

@class imageViewController;

@interface SuperSonicRVDelegate : NSObject<SupersonicRVDelegate>
@property BOOL isWatched;
@property BOOL isItemUnlocked;
- (id) initWithView:(imageViewController *) view;
@end
