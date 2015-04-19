//
//  YahooWeatherHelper.m
//  Forecast
//
//  Created by Maciej Stanik on 19/04/2015.
//  Copyright (c) 2015 Maciej Stanik. All rights reserved.
//

#import "YahooWeatherHelper.h"
#import "Forecast.h"

@implementation YahooWeatherHelper

+ (NSArray *)getForecastForCity:(NSString *)city {
    NSMutableArray *forecasts = [[NSMutableArray alloc] init];
    NSHTTPURLResponse *response = nil;
    
    static NSString *urlStringPrefix = @"https://query.yahooapis.com/v1/public/yql?q=select%20item.forecast%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22";
    static NSString *urlStringSuffix = @"%22)and%20u='c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", urlStringPrefix, city, urlStringSuffix];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSError *error;
    
    if (responseData != nil) {
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        for (NSDictionary *dictionary in [resultDict valueForKeyPath:@"query.results.channel.item.forecast"]) {
            NSDictionary *forecastDict = [[NSDictionary alloc] initWithDictionary:dictionary];
            
            Forecast *forecast = [[Forecast alloc] init];
            
            for (NSString *key in forecastDict) {
                if ([forecast respondsToSelector:NSSelectorFromString(key)]) {
                    [forecast setValue:[forecastDict valueForKey:key] forKey:key];
                }
            }
            [forecasts addObject:forecast];
        }
    }
    return forecasts;
}

@end
