//
//  YahooWeatherHelper.h
//  Forecast
//
//  Created by Maciej Stanik on 19/04/2015.
//  Copyright (c) 2015 Maciej Stanik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooWeatherHelper : NSObject

+ (NSArray *)getForecastForCity:(NSString *)city;

@end
