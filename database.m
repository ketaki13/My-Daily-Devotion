//
//  database.m
//  DailyDevotional
//
//  Created by ketaki on 6/23/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "database.h"
static database *sharedInstance = nil;
static sqlite3 *databaseDB = nil;
static sqlite3_stmt *statement = nil;
@implementation database
//Create the database
+(database*)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}


-(NSMutableArray *) fnGetTodaysPrayer: (int) prayer_Id tableName:(NSString *)tableName
{
    
    NSMutableArray *arrPrayerDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"Select * from %@ WHERE id='%d'",tableName, prayer_Id];
        
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int nID = sqlite3_column_int(statement, 2) ;
                NSLog(@"Prayer ID is : %d", nID);
                
                NSString *strPrayerTitle = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                
                [arrPrayerDetails addObject:strPrayerTitle];
                
                NSString *strPrayer = [NSString stringWithUTF8String:sqlite3_column_text(statement, 1)];
                
                //                NSString *strPrayer =  NSSRING_FROM_CSTRING(sqlite3_column_text(statement, 2));
                [arrPrayerDetails addObject:strPrayer];
                NSLog(@"Prayer is : %@", strPrayer);
                
            }
        }
    }
    return arrPrayerDetails;
}
-(NSMutableArray *)fnGetACTSHeading:(int)ACTS_id tableName:(NSString *)tableName
{
    NSMutableArray *arrPrayerDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"Select title from %@ WHERE prayerLineId='%d'",tableName, ACTS_id];
        
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *nID = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                NSLog(@"Prayer ID is : %@", nID);

                [arrPrayerDetails addObject:nID];
            }
        }
    }
        return arrPrayerDetails;
}
-(NSMutableArray *)fnGetACTSDesc:(NSString *)ACTS_id
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSMutableArray *arrPrayerDetails=[[NSMutableArray alloc]init];
    NSString *selectQry = nil;
    NSString *count;
    NSString *rowid;
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"SELECT count (id) from ACTSPrayerGuide where prayerLineId=%@",ACTS_id];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                count=[NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
            }
        }
        selectQry = [NSString stringWithFormat: @"Select id from ACTSPrayerGuide where prayerLineId=%@",ACTS_id];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                rowid=[NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                [arrPrayerDetails addObject:rowid];
            }
            
        }
        NSMutableArray *arrPrayer=[[NSMutableArray alloc]init];
        for (int i=0; i<[count intValue]; i++)
        {
            
            [arrPrayer removeAllObjects];
            NSMutableDictionary *prayerdict=[[NSMutableDictionary alloc]init];
            selectQry=[NSString stringWithFormat:@"SELECT prayer.prayer,guide.title from ACTSprayers prayer INNER JOIN ACTSPrayerGuide guide ON prayer.headlineId = guide.id WHERE prayer.headlineId=%@",[arrPrayerDetails objectAtIndex:i]];
            if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
            {
                NSString *strTitle=@"";
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *prayer = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                    [arrPrayer addObject:prayer];
                    strTitle=[NSString stringWithCString:(sqlite3_column_text(statement, 1)) encoding:NSUTF8StringEncoding];
                }
                
                if(strTitle!=nil&&[strTitle isKindOfClass:[NSString class]])
                {
                    [prayerdict setObject:strTitle forKey:@"title" ];
                }
                NSMutableArray *arrValue=[arrPrayer mutableCopy];
                [prayerdict setObject:arrValue forKey:@"data" ];
                
            }
            [array addObject:prayerdict];
        }
    }
    
    return array;
}

-(NSMutableArray *) fetchGuideToConfession{
    
    NSMutableArray *arrPrayerDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = @"SELECT rowid, * FROM guideToConfession";
        
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                int nID = sqlite3_column_int(statement, 0) ;
                NSLog(@"Prayer ID is : %d", nID);
                
                NSString *strPrayerTitle = [NSString stringWithCString:(sqlite3_column_text(statement, 1)) encoding:NSUTF8StringEncoding];
                NSString *strPrayer = [NSString stringWithUTF8String:sqlite3_column_text(statement, 2)];
                
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                [dict setValue:[NSString stringWithFormat:@"%d",nID] forKey:@"rowid"];
                [dict setValue:strPrayerTitle forKey:@"chapterName"];
                [dict setValue:strPrayer forKey:@"Desc"];
                [arrPrayerDetails addObject:dict];
                
                dict = nil;
                
                NSLog(@"Prayer is : %@", strPrayer);
                
            }
        }
    }
    return arrPrayerDetails;
}


-(NSMutableArray *) fetchACTSPrayerGuide:(NSInteger)prayerLineIdToFetchPrayer {
    
    NSMutableArray *arrPrayerDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        if(prayerLineIdToFetchPrayer == 0)
            selectQry = @"SELECT rowid, * FROM ACTSPrayerGuide";
        else
            selectQry = [NSString stringWithFormat:@"SELECT rowid, * FROM ACTSPrayerGuide where prayerLineId = %d",prayerLineIdToFetchPrayer];
        
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
//                CREATE TABLE "ACTSPrayerGuide" ("heading" TEXT, "title" TEXT, "prayerLineId" INTEGER, "id" INTEGER PRIMARY KEY AUTOINCREMENT)
                
                int nID = sqlite3_column_int(statement, 0) ;
                NSLog(@"Prayer ID is : %d", nID);
                
                NSString *strHeading = [NSString stringWithCString:(sqlite3_column_text(statement, 1)) encoding:NSUTF8StringEncoding];
                NSString *strTitle = [NSString stringWithUTF8String:sqlite3_column_text(statement, 2)];
                
                int prayerLineId = sqlite3_column_int(statement, 3) ;
                int idValues = sqlite3_column_int(statement, 4) ;

                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                [dict setValue:[NSString stringWithFormat:@"%d",nID] forKey:@"rowid"];
                [dict setValue:strHeading forKey:@"heading"];
                [dict setValue:strTitle forKey:@"title"];
                [dict setValue:[NSString stringWithFormat:@"%d",prayerLineId] forKey:@"prayerLineId"];
                [dict setValue:[NSString stringWithFormat:@"%d",idValues] forKey:@"id"];

                [arrPrayerDetails addObject:dict];
                
                dict = nil;
                
                
            }
        }
    }
    return arrPrayerDetails;
}

-(NSMutableArray *) fetchACTSPrayerGuideLinesFromHeadingnumber:(NSString *)prayerLineIdToFetchPrayer titleForHeading:(NSString *)titleForHeading {
    
    NSMutableArray *arrPrayerDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
            selectQry = [NSString stringWithFormat:@"SELECT prayer FROM ACTSprayers where headlineId = %@",prayerLineIdToFetchPrayer ];

        
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *strPrayerLine = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];

                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:strPrayerLine forKey:@"prayerline"];
                [dict setValue:titleForHeading forKey:@"heading"];
                [arrPrayerDetails addObject:dict];
                
                dict = nil;
                
                
            }
        }
    }
    return arrPrayerDetails;
}
-(NSString *)getountPrayerBooklet:(NSString *)bokletId
{
    NSString *selectQry = nil;
    int bookid=0;
     NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@" SELECT count(id) FROM booklet WHERE BookletId=%@",bokletId];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                bookid=sqlite3_column_int(statement, 0);
            }
        }

    }
    return [NSString stringWithFormat:@"%d",bookid];
}
    
-(NSString *)getMinPrayerBooklet:(NSString *)bokletId
{
    NSString *selectQry = nil;
    int bookid=0;
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@" SELECT min(id) FROM booklet WHERE BookletId=%@",bokletId];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                bookid=sqlite3_column_int(statement, 0);
            }
        }
        
    }
    return [NSString stringWithFormat:@"%d",bookid];
}
-(NSString *)getMaxPrayerBooklet:(NSString *)bokletId
{
    NSString *selectQry = nil;
    int bookid=0;
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@" SELECT max(id) FROM booklet WHERE BookletId=%@",bokletId];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                bookid=sqlite3_column_int(statement, 0);
            }
        }
        
    }
    return [NSString stringWithFormat:@"%d",bookid];
}
-(NSMutableArray *) fetchChristoperText:(NSString *)BookletId prayerId:(NSString *)prayerId
{
    NSMutableArray *arrPrayerDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"SELECT * FROM booklet WHERE BookletId=%@ and id=%@",BookletId,prayerId];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *strBookletHeading = [NSString stringWithCString:(sqlite3_column_text(statement, 1)) encoding:NSUTF8StringEncoding];
            
             NSString *strBookletDesc = [NSString stringWithCString:(sqlite3_column_text(statement, 2)) encoding:NSUTF8StringEncoding];
           
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:strBookletHeading forKey:@"strBookletHeading"];
            [dict setValue:strBookletDesc forKey:@"strBookletDesc"];
    
            [arrPrayerDetails addObject:dict];
            
            dict = nil;

        }
        }
    }
        return arrPrayerDetails;
}

-(NSMutableArray *) fetchSacripturePrayer:(NSString *)scriptId
{
    NSMutableArray *arrPrayerDetails = [[NSMutableArray alloc]init];
    
    NSString *selectQry = nil;
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"SELECT prayerlineDesc  FROM ScriptureGuide WHERE scriptId=%@",scriptId];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *prayer = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                     [arrPrayerDetails addObject:prayer];
            }
        }
    }
    return arrPrayerDetails;
}


//new method
-(NSMutableArray *)fnLordPrayerDesc:(NSString *)LordPrayer_id
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSMutableArray *arrPrayerDetails=[[NSMutableArray alloc]init];
    NSString *selectQry = nil;
    NSString *count;
    NSString *rowid;
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"SELECT count (id) from LordPrayerGuide where prayerLineId=%@",LordPrayer_id];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                count=[NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
            }
        }
        selectQry = [NSString stringWithFormat: @"Select id from LordPrayerGuide where prayerLineId=%@",LordPrayer_id];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                rowid=[NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                 [arrPrayerDetails addObject:rowid];
            }
            
        }
        NSMutableArray *arrPrayer=[[NSMutableArray alloc]init];
        for (int i=0; i<[count intValue]; i++)
        {
            
            [arrPrayer removeAllObjects];
            NSMutableDictionary *prayerdict=[[NSMutableDictionary alloc]init];
            selectQry=[NSString stringWithFormat:@"SELECT prayer.prayer,guide.title from LordPrayers prayer INNER JOIN LordPrayerGuide guide ON prayer.headlineId = guide.id WHERE prayer.headlineId=%@",[arrPrayerDetails objectAtIndex:i]];
            if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
            {
                NSString *strTitle=@"";
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *prayer = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                    [arrPrayer addObject:prayer];
                    strTitle=[NSString stringWithCString:(sqlite3_column_text(statement, 1)) encoding:NSUTF8StringEncoding];
                }
                
                if(strTitle!=nil&&[strTitle isKindOfClass:[NSString class]])
                {
                    [prayerdict setObject:strTitle forKey:@"title" ];
                }
                NSMutableArray *arrValue=[arrPrayer mutableCopy];
                [prayerdict setObject:arrValue forKey:@"data" ];
                
            }
            [array addObject:prayerdict];
        }
    }

        return array;
}
-(NSMutableArray *)fetchDictonary:(NSString *)aplhabet_id
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *selectQry = nil;
   NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
    selectQry = [NSString stringWithFormat:@"SELECT title,description from Easton where id=%@",aplhabet_id];
    if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
    {
         NSMutableArray *arrPrayer=[[NSMutableArray alloc]init];
         NSMutableDictionary *prayerdict=[[NSMutableDictionary alloc]init];
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *strTitle = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
            NSString *desc=[NSString stringWithCString:(sqlite3_column_text(statement, 1)) encoding:NSUTF8StringEncoding];
             NSMutableDictionary *prayerdict = [[NSMutableDictionary alloc] init];
            [prayerdict setObject:strTitle forKey:@"title" ];
            [prayerdict setObject:desc forKey:@"desc"];
            [array addObject:prayerdict];
            prayerdict = nil;


        }
     
       
    }

}
return array;
}
-(NSMutableArray *)fetchNameDictonary:(NSString *)aplhabet_id
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *selectQry = nil;
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"Devotional-1-2" ofType:@"sqlite"];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dbInstance) == SQLITE_OK)
    {
        selectQry = [NSString stringWithFormat:@"SELECT title,description from BibleNameDictonary where info==%@",aplhabet_id];
        if (sqlite3_prepare_v2(dbInstance, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
        {
            NSMutableArray *arrPrayer=[[NSMutableArray alloc]init];
            NSMutableDictionary *prayerdict=[[NSMutableDictionary alloc]init];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *strTitle = [NSString stringWithCString:(sqlite3_column_text(statement, 0)) encoding:NSUTF8StringEncoding];
                NSString *desc=[NSString stringWithCString:(sqlite3_column_text(statement, 1)) encoding:NSUTF8StringEncoding];
                NSMutableDictionary *prayerdict = [[NSMutableDictionary alloc] init];
                [prayerdict setObject:strTitle forKey:@"title" ];
                [prayerdict setObject:desc forKey:@"desc"];
                [array addObject:prayerdict];
                prayerdict = nil;
            }
        }
        
    }
    return array;
}


@end
