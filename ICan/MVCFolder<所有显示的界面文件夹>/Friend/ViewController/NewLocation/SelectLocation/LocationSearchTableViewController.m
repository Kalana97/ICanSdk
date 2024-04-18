//
//  LocationSearchTableViewController.m
//  ICan
//
//  Created by MAC on 2022-12-05.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "LocationSearchTableViewController.h"

@interface LocationSearchTableViewController () <UISearchResultsUpdating>

@property(nonatomic, strong) NSMutableArray<MKMapItem *> *matchingItems;
@property(nonatomic, strong) NSString *searchText;

@end

@implementation LocationSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSMutableArray *)matchingItems{
    if (!_matchingItems) {
        _matchingItems=[NSMutableArray array];
    }
    return _matchingItems;
}

- (NSString *)parseAddress:(MKPlacemark*)selectedItem {
    // put a space between "4" and "Melrose Place"
    NSString *firstSpace = (selectedItem.subThoroughfare != nil &&
                            selectedItem.thoroughfare != nil) ? @" " : @"";
    
    // put a comma between street and city/state
    NSString *comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
    (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? @", " : @"";
    
    // put a space between "Washington" and "DC"
    NSString *secondSpace = (selectedItem.subAdministrativeArea != nil &&
                             selectedItem.administrativeArea != nil) ? @" " : @"";
    
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             // street number
                             selectedItem.subThoroughfare? :@"",
                             firstSpace,
                             // street name
                             selectedItem.thoroughfare? :@"",
                             comma,
                             // city
                             selectedItem.locality? :@"",
                             secondSpace,
                             // state
                             selectedItem.administrativeArea? :@""];
    
    return addressLine;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    MKPlacemark *selectedItem = self.matchingItems[indexPath.row].placemark;
    
    cell.textLabel.frame = CGRectMake(15, 0, ScreenWidth, 20);
    cell.textLabel.text = selectedItem.name;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = UIColor102Color;
    
    cell.detailTextLabel.frame = CGRectMake(15, 22, ScreenWidth, 14);
    cell.detailTextLabel.text = [self parseAddress: selectedItem];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = UIColor102Color;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    return cell;
}

 #pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKPlacemark *selectedItem = self.matchingItems[indexPath.row].placemark;
    [self.handleMapSearchDelegate dropPinZoomIn:selectedItem searchText:self.searchText];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    MKMapView *mapView = _mapView;
    if(searchController.searchBar.text){
        self.searchText = searchController.searchBar.text;
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = self.searchText;
    if (@available(iOS 13.0, *)) {
        request.resultTypes = MKLocalSearchResultTypePointOfInterest;
    } else {
        // Fallback on earlier versions
    }
    request.region = mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if(response) {
            [self.matchingItems removeAllObjects];
            self.matchingItems = [NSMutableArray arrayWithArray:response.mapItems];
            [self.tableView reloadData];
        }else {
            DDLogInfo(@"error=%@",error);
        }
    }];
}

@end
