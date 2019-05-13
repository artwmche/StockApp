//
//  YahooSearchAPI.m
//  assignment2
//
//  Created by Rania Arbash on 2018-11-23.
//  Copyright © 2018 Rania Arbash. All rights reserved.
//

#import "YahooSearchAPI.h"

@implementation YahooSearchAPI

    
-(void)searchYahooAPIwithText:(NSString *)searchText{
    
    dispatch_queue_t myQ = dispatch_queue_create("myQ", NULL);
    dispatch_async(myQ, ^{
        NSString* urlString = [NSString stringWithFormat:@"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&region=1&lang=en&callback=YAHOO.Finance.SymbolSuggest.ssCallback",searchText];
        //NSLog(@"%@",urlString);
        NSURL* url = [NSURL URLWithString:urlString];
        
        NSString* json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
      
        
        json = [json substringFromIndex:39];
        json = [json substringToIndex:json.length - 2];
       
        // convert json to dictinary
        NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray* results = [jsonDic valueForKeyPath:@"ResultSet.Result"];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.delegate yahooDidFinishWithArray:results];
        });
    });
    
    
    
}

    
@end
