//
//  DailyDevotionalHelper.m
//  DailyDevotional
//
//  Created by ketaki on 7/1/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "DailyDevotionalHelper.h"

@implementation DailyDevotionalHelper
+ (DailyDevotionalHelper *)sharedInstance {
    static dispatch_once_t once;
    static DailyDevotionalHelper * sharedInstance;
    dispatch_once(&once, ^{
        //Product Id List
        
        NSSet * productIdentifiers = [NSSet setWithObjects:@"com.brain.ACTS",
                                      @"com.brian.BibleDictonary",
                                      @"com.brian.bibleNameDictionary",
                                      @"com.brian.GuidToConfess",
                                      @"com.brian.LordPrayer",
                                      @"com.brian.christopher",
                                      @"com.brian.jude",
                                      @"com.brian.anthony",
                                      @"com.brian.love",
                                      @"com.brian.inspirational",
                                      @"com.brian.women",
                                      @"com.brian.Peregrine",
                                      @"com.brian.scripture",
                                       @"com.brian.allcontent",
                                      @"com.brian.family",
                                    nil];        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
