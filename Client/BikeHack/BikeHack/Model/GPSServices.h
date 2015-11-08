//
//  GPSServices.h
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/8/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GPSServices : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKRoute *appleRoute;
@property (strong, nonatomic) CLPlacemark *localPlaceMark;
@property (strong, nonatomic) CLPlacemark *addressPlaceMark;
@property (weak, nonatomic) MKMapView *mapView;

@property float distance;

+ (id)sharedManager;

-(void) findeRouteToAddress:(NSString *)address withCompleteHandler:(void (^)(BOOL state))completionHandler;
-(void) startStopTracking;

@end
