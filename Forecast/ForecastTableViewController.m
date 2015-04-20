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
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    CLPlacemark *_placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
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
    [cell.tempLoLabel setText:[NSString stringWithFormat:@"%d°C", forecast.low]];
    [cell.tempHiLabel setText:[NSString stringWithFormat:@"%d°C", forecast.high]];
    [cell.weatherTextLabel setText:forecast.text];
    
    return cell;
}

#pragma mark Location methods

- (void)setupLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _geocoder = [[CLGeocoder alloc] init];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        [_geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error == nil && [placemarks count] > 0) {
                _placemark = [placemarks lastObject];
                NSString *city = _placemark.locality;
                
                if (city != nil) {
                    _forecasts = [YahooWeatherHelper getForecastForCity:city];
                    
                    if (_forecasts.count == 0) {
                        // For some locations it's not possible to find forecast for locality, so let's try subLocality
                        city = _placemark.subLocality;
                        
                        if (city != nil) {
                            _forecasts = [YahooWeatherHelper getForecastForCity:city];
                        } else {
                            [self showForecastErrorAlert];
                        }
                    }
                    [self.tableView reloadData];
                    _cityNameLabel.hidden = NO;
                    _cityNameLabel.text = city;
                } else {
                    [self showLocationErrorAlert];
                }
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showLocationErrorAlert];
}

- (void)showLocationErrorAlert {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Application failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void)showForecastErrorAlert {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Application failed to get forecast for your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
}

#pragma mark IBActions

- (IBAction)refreshButtonTapped:(UIButton *)sender {
    [_locationManager startUpdatingLocation];
}
@end
