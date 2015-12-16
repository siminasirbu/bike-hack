//
//  GPSServices.m
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/8/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import "GPSServices.h"

@implementation GPSServices

CLGeocoder *geocoder;
BOOL recording;
CLLocation *lastLocation;

@synthesize locationManager;
@synthesize appleRoute;

+ (id)sharedManager {
    static GPSServices *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
       
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.activityType = CLActivityTypeFitness;
        
        // Movement threshold for new events.
        self.locationManager.distanceFilter = 5; // meters
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
        
        geocoder = [[CLGeocoder alloc] init];
        
        recording = NO;
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

// MARK: - Tracking
-(void) startStopTracking; {
    
    if (recording) {
        recording = NO;
        [self.timer invalidate];
    } else {
        self.distance = 0;
        self.seconds = 0;
        recording = YES;
        // start timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(secondPassed) userInfo:nil repeats:YES];
    }

}

- (void)secondPassed {
    self.seconds++;
    
    NSLog(@" - seconds:%d distance:%f",self.seconds,self.distance);
}

// MARK: - Finding
-(void) findeRouteToAddress:(NSString *)address withCompleteHandler:(void (^)(BOOL state))completionHandler{

    // find a given place
    [self findPlaceMarkForAddress:address completionHandler:^(CLPlacemark *placeMaker) {
        if (placeMaker) {
            self.addressPlaceMark = placeMaker;
            // find my curent place
            [self findPlaceMarkForCurrentLocationWithCompletionHandler:^(CLPlacemark *placeMaker) {
                if (placeMaker) {
                    // found my current place
                    self.localPlaceMark = placeMaker;
                    
                    // find a routeBetwenThem
                    [self findRouteFromPlaceMark:self.localPlaceMark toPlaceMark:self.addressPlaceMark andCompletionHandler:^(BOOL state) {
                        if (state) {
                            // all was ok
                            NSLog(@"- %@",appleRoute);
                            if (completionHandler != nil) {
                                completionHandler(YES);
                            }
                            
                        } else {
                            if (completionHandler != nil) {
                                completionHandler(NO);
                            }
                        }
                    }];
                } else {
                    if (completionHandler != nil) {
                        completionHandler(NO);
                    }
                }
            }];
        } else {
            if (completionHandler != nil) {
                completionHandler(NO);
            }
        }
        
    }];
    
}

-(void) findPlaceMarkForAddress:(NSString *)address completionHandler:(void (^)(CLPlacemark *placeMaker))completionHandler {

    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding given address");
        if (error) {
            NSLog(@"%@", error);
            if (completionHandler != nil) {
                completionHandler(nil);
            }
        } else {
            if (completionHandler != nil) {
                CLPlacemark *thePlacemark = [placemarks lastObject];
                completionHandler(thePlacemark);
            }
        }
    }];
}

- (void) findPlaceMarkForCurrentLocationWithCompletionHandler:(void (^)(CLPlacemark *placeMaker))completionHandler {

    [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding local address");
        if (error) {
            NSLog(@"Error %@", error.description);
            if (completionHandler != nil) {
                completionHandler(nil);
            }
        } else {
            if (completionHandler != nil) {
                CLPlacemark *localPlacemark = [placemarks lastObject];
                completionHandler(localPlacemark);
            }
        }
    }];
}

- (void) findRouteFromPlaceMark:(CLPlacemark *) currentPlaceMark toPlaceMark:(CLPlacemark *) destinationPlaceMark andCompletionHandler:(void (^)(BOOL state))completionHandler {

    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:currentPlaceMark]];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:destinationPlaceMark]];

    [directionsRequest setSource:source];
    [directionsRequest setDestination:destination];
    directionsRequest.transportType = MKDirectionsTransportTypeAny;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];

    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
            if (completionHandler != nil) {
                completionHandler(NO);
            }
        } else {
            self.appleRoute = response.routes.lastObject;
            
            if (completionHandler != nil) {
                completionHandler(YES);
            }
//            [self.mapView addOverlay:self.appleRoute.polyline];

            //                    for (int i = 0; i < routeDetails.steps.count; i++) {
            //                        MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
            //                        NSString *newStep = step.instructions;
            //                        self.allSteps = [self.allSteps stringByAppendingString:newStep];
            //                        self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
            //                        self.steps.text = self.allSteps;
            //                    }
        }
    }];
 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *newLocation in locations) {
        if (newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (recording) {
                if (lastLocation != nil) {
                    self.distance += [newLocation distanceFromLocation:lastLocation];
                }
                
                lastLocation = newLocation;
            }
            
            NSLog(@" - new position :%@",newLocation);
            
//            self.lastLocation = newLocation;
//            
//            //TODO: create model
//            //            PointModel *point = [[PointModel alloc] init];
//            [[[Model sharedManager] route] addObject:newLocation];
        }
    }
}

// MARK: - Utility
+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}

@end
