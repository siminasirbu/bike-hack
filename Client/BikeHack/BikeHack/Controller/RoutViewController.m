//
//  RoutViewController.m
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/8/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import "RoutViewController.h"
#import "GPSServices.h"
#import "LoadingViewManager.h"

@interface RoutViewController ()

@end

@implementation RoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.searchField.delegate = self;

    self.bikeImage.hidden = YES;
    self.bikeButton.hidden = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self drawOverlayOnMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) drawOverlayOnMap {
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlay:[[GPSServices sharedManager] appleRoute].polyline];
    [self.mapView setRegion:[self mapRegion]];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = [[GPSServices sharedManager] addressPlaceMark].location.coordinate;
    [self.mapView addAnnotation:point];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 2;
        return aRenderer;
    }
    
    return nil;
}

- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;

    CLLocation *initialLoc = [[GPSServices sharedManager] localPlaceMark].location;
    CLLocation *destinationLoc = [[GPSServices sharedManager] addressPlaceMark].location;
    
    float centerLat = 0;
    float centerLong = 0;
    float longDelta = 0;
    float latDelta = 0;
    
    if (initialLoc.coordinate.latitude < destinationLoc.coordinate.latitude) {
        latDelta = (destinationLoc.coordinate.latitude - initialLoc.coordinate.latitude );
        centerLat = latDelta / 2 + initialLoc.coordinate.latitude;
    } else {
        latDelta = (initialLoc.coordinate.latitude - destinationLoc.coordinate.latitude );
        centerLat = latDelta / 2 + destinationLoc.coordinate.latitude;
    }
    
    if (initialLoc.coordinate.longitude < destinationLoc.coordinate.longitude) {
        longDelta = (destinationLoc.coordinate.longitude - initialLoc.coordinate.longitude);
        centerLong = longDelta / 2 + initialLoc.coordinate.longitude;
    } else {
        longDelta = (initialLoc.coordinate.longitude - destinationLoc.coordinate.longitude );
        centerLong = longDelta / 2 + destinationLoc.coordinate.longitude;
    }
   
    region.center.latitude = centerLat;
    region.center.longitude = centerLong;
    
    region.span.latitudeDelta = latDelta * 2.0f; // 10% padding
    region.span.longitudeDelta = longDelta * 2.0f; // 10% padding
    
    return region;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.searchField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchField resignFirstResponder];
    return YES;
}

- (IBAction)searchButtonPressed:(id)sender {
     [self.searchField resignFirstResponder];
}

- (IBAction)textFieldEndEditing:(UITextField *)sender {
    
    [self startSearchStartForAddress:sender.text];
}

- (void) startSearchStartForAddress:(NSString *)address {
    
    [LoadingViewManager showLoadingViewInParentView:self.view];
    
    [[GPSServices sharedManager] findeRouteToAddress:address withCompleteHandler:^(BOOL state) {
        
        if (state) {
            [self drawOverlayOnMap];
        }
        
        [LoadingViewManager hideLoadingViewAnimated];
    }];
}

- (IBAction)trackButtonPressed:(id)sender {
    
    if ([self.trackButton.titleLabel.text isEqualToString:@"TRACK"]) {
        self.butonBarHeightConstraint.constant = 0;
        
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded]; // Called on parent view
        }];
        
        [self.safeButton removeFromSuperview];
        [self.popularButton removeFromSuperview];
        [self.quickButton removeFromSuperview];
        
        self.infoLabel.text = @"You get extra points for following the bike lanes!";
        [self.trackButton setTitle:@"FINISH" forState:UIControlStateNormal];
        
        self.bikeImage.hidden = NO;
        self.bikeButton.hidden = YES;
        
        // start recording
        [[GPSServices sharedManager] startStopTracking];
        
        // center map on my location and disable editing
        self.mapView.scrollEnabled = NO;
        self.mapView.zoomEnabled = NO;
 
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
        
    } else {
        // stop recording
        [[GPSServices sharedManager] startStopTracking];
        
        //TODO: GO TO THE NEW PAGE
    }
    
}

- (IBAction)safeRoutButtonPressed:(id)sender {
}

- (IBAction)popularRoutButtonPressed:(id)sender {
}

- (IBAction)quickRouteButtonPressed:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
