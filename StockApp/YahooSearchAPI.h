//
//  YahooSearchAPI.h
//  assignment2
//
//  Created by Rania Arbash on 2018-11-23.
//  Copyright © 2018 Rania Arbash. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YahooSearchDelegate
-(void)yahooDidFinishWithArray :(NSArray*)results;
    
    @end

@interface YahooSearchAPI : NSObject
-(void)searchYahooAPIwithText :(NSString*)searchText;
    @property (nonatomic)id<YahooSearchDelegate> delegate;
@end
