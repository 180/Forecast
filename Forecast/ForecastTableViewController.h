//
//  ForecastTableViewController.h
//  Forecast
//
//  Created by Maciej Stanik on 19/04/2015.
//  Copyright (c) 2015 Maciej Stanik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ForecastTableViewController : UITableViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

- (IBAction)refreshButtonTapped:(UIButton *)sender;
@end
