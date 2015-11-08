//
//  WelcomeViewController.m
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/8/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Tools.h"
#import "GPSServices.h"
#import "RoutViewController.h"
#import "LoadingViewManager.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *searchContainer;
@property (weak, nonatomic) IBOutlet UITextField *searchEntryField;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchContainer.layer.borderColor = [Tools colorFromHexString:@"#C4C9C9"].CGColor;
    self.searchContainer.layer.borderWidth = 1;
    self.searchEntryField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.searchEntryField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchEntryField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldEnd:(id)sender {
    
    [self startSearchStartForAddress:((UITextField *)sender).text];
}

- (IBAction)searchButtonPressed:(id)sender {
    [self.searchEntryField resignFirstResponder];
}

- (void) startSearchStartForAddress:(NSString *)address {
    
    [LoadingViewManager showLoadingViewInParentView:self.view];
    
    [[GPSServices sharedManager] findeRouteToAddress:address withCompleteHandler:^(BOOL state) {
       
        if (state) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            RoutViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"routViewCtrl"];
            [self presentViewController:vc animated:YES completion:nil];
            
            NSLog(@" you go girl");
        }
        
        [LoadingViewManager hideLoadingView];
    }];
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
