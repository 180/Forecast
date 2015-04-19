//
//  ForecastTableViewController.m
//  Forecast
//
//  Created by Maciej Stanik on 19/04/2015.
//  Copyright (c) 2015 Maciej Stanik. All rights reserved.
//

#import "ForecastTableViewController.h"
#import "WeatherCell.h"

NSString *const ForecastTableViewCellReuseIdentifier = @"WeatherCell";

@interface ForecastTableViewController ()

@end

@implementation ForecastTableViewController {
    NSArray *_forecasts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _forecasts = [[NSArray alloc] initWithObjects:@"20",@"30",@"-15",@"0",nil];
    
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
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:ForecastTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    [cell.tempHiLabel setText:[NSString stringWithFormat:@"%@°C", [_forecasts objectAtIndex:indexPath.row]]];
    [cell.dateLabel setText:@"12/04/2015"];
    [cell.dayLabel setText:@"Monday"];
    [cell.weatherTextLabel setText:@"Sunny"];
    
    return cell;
}

@end
