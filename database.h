//
//  database.h
//  DailyDevotional
//
//  Created by ketaki on 6/23/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface database : NSObject
{
    sqlite3 *dbInstance;
}
+(database*)getSharedInstance;
-(NSMutableArray *) fnGetTodaysPrayer: (int) prayer_Id tableName:(NSString *)tableName;
-(NSMutableArray *)fnGetACTSHeading:(int)ACTS_id tableName:(NSString *)tableName;

-(NSMutableArray *)fnGetACTSDesc:(NSString *)ACTS_id;
-(NSMutableArray *) fetchGuideToConfession;
-(NSMutableArray *) fetchACTSPrayerGuide:(NSInteger)prayerLineIdToFetchPrayer;
-(NSMutableArray *) fetchACTSPrayerGuideLinesFromHeadingnumber:(NSString *)prayerLineIdToFetchPrayer titleForHeading:(NSString *)titleForHeading;
-(NSMutableArray *) fetchChristoperText:(NSString *)BookletId prayerId:(NSString *)prayerId;
-(NSMutableArray *) fetchSacripturePrayer:(NSString *)scriptId;
-(NSMutableArray *)fnLordPrayerDesc:(NSString *)LordPrayer_id;
-(NSMutableArray *)fetchDictonary:(NSString *)aplhabet_id;
-(NSMutableArray *)fetchNameDictonary:(NSString *)aplhabet_id;
-(NSString *)getountPrayerBooklet:(NSString *)bokletId;
-(NSString *)getMinPrayerBooklet:(NSString *)bokletId;
-(NSString *)getMaxPrayerBooklet:(NSString *)bokletId;
@end
