//
//  Forecast.h
//  Forecast
//
//  Created by Maciej Stanik on 19/04/2015.
//  Copyright (c) 2015 Maciej Stanik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject

@property (nonatomic) int high;
@property (nonatomic) int low;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *text;

@end
