//
//  RoutViewController.h
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/8/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RoutViewController : UIViewController <MKMapViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *buttonsBarView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *butonBarHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *safeButton;
@property (weak, nonatomic) IBOutlet UIButton *popularButton;
@property (weak, nonatomic) IBOutlet UIButton *quickButton;

@property (weak, nonatomic) IBOutlet UIImageView *bikeImage;
@property (weak, nonatomic) IBOutlet UIButton *bikeButton;

@property int seconds;
@property (nonatomic, strong) NSTimer *timer;

@end
