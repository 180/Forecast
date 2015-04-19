//
//  ForecastTableViewController.m
//  Forecast
//
//  Created by Maciej Stanik on 19/04/2015.
//  Copyright (c) 2015 Maciej Stanik. All rights reserved.
//

#import "ForecastTableViewController.h"
#import "Forecast.h"
#import "WeatherCell.h"
#import "YahooWeatherHelper.h"

NSString *const ForecastTableViewCellReuseIdentifier = @"WeatherCell";

@interface ForecastTableViewController ()

@end

@implementation ForecastTableViewController {
    NSArray *_forecasts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _forecasts = [YahooWeatherHelper getForecast];
    
    UINib *weatherCellNib = [UINib nibWithNibName:NSStringFromClass([WeatherCell class]) bundle:nil];
    [self.tableView registerNib:weatherCellNib forCellReuseIdentifier:ForecastTableViewCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_forecasts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Forecast *forecast = [_forecasts objectAtIndex:indexPath.row];
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:ForecastTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    [cell.dateLabel setText:forecast.date];
    [cell.dayLabel setText:forecast.day];
    [cell.tempHiLabel setText:[NSString stringWithFormat:@"%d°C", forecast.high]];
    [cell.weatherTextLabel setText:forecast.text];
    
    return cell;
}

@end
