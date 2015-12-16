//
//  MainViewController.m
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/9/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import "MainViewController.h"
#import "GPSServices.h" 

#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0);

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headderText;

@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIImageView *menuIconImage;

@end

@implementation MainViewController

BOOL menuOnScreen;
NSMutableArray *menuElements;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuView.hidden = YES;
    self.menuView.frame = CGRectMake(0, 0, 50, 50);
    self.menuView.layer.cornerRadius = 25;
    
    menuOnScreen = NO;
    
    [self createMenuButtons];
    
    MKPolyline *GPSPolyline = [GPSServices polylineWithEncodedString:@"{pihvA{hupg@c`@mg@rK`SdEzH`BhGhMdXd@hBV~AFtBOhBe@|Bm@~AkA~AsA~@}^nAey@fByiGjVuI\\mEaCqCGoI\\uTtC{K|Gav@fz@sz@atBwCeHk`@acAsKiXkGuO}Ywt@{_@waAse@slAkz@gjBu@gBm@gAe@a@m@Kk@Fu@Je@`@{AxBav@pjAsAfBsAjAcBv@gHzAqSrGyGuFqGsFePyB"];
    
}

- (void)createMenuButtons {
    // create the menu buttons array
    menuElements = [[NSMutableArray alloc] init];
    
    // create the butons
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat xFirstCol = (screenWidth - (120 * 2)) / 3;
    CGFloat xSecondCol = xFirstCol * 2 + 120;
    
    CGFloat yFirstRow = (screenHeight - ( 120 * 3)) / 4;
    CGFloat ySecondRow = yFirstRow * 2 + 120;
    CGFloat yThirdRow = (yFirstRow * 3) + (120 * 2);
    
    //TODO: add events to buttons
    
    UIButton *findRoutButton = [[UIButton alloc] initWithFrame:CGRectMake(xFirstCol, yFirstRow, 120, 120)];
    [findRoutButton setTitle:nil forState:UIControlStateNormal];
    [findRoutButton setImage:[UIImage imageNamed:@"faceMenu.png" ] forState:UIControlStateNormal];
    [menuElements addObject:findRoutButton];
    
    UIButton *myStuffButton = [[UIButton alloc] initWithFrame:CGRectMake(xSecondCol, yFirstRow, 120, 120)];
    [myStuffButton setTitle:nil forState:UIControlStateNormal];
    [myStuffButton setImage:[UIImage imageNamed:@"gooMenu.png" ] forState:UIControlStateNormal];
    [menuElements addObject:myStuffButton];

    UIButton *ledearbordButton = [[UIButton alloc] initWithFrame:CGRectMake(xFirstCol, ySecondRow, 120, 120)];
    [ledearbordButton setTitle:nil forState:UIControlStateNormal];
    [ledearbordButton setImage:[UIImage imageNamed:@"instMenu.png" ] forState:UIControlStateNormal];
    [menuElements addObject:ledearbordButton];
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(xSecondCol, ySecondRow, 120, 120)];
    [infoButton setTitle:nil forState:UIControlStateNormal];
    [infoButton setImage:[UIImage imageNamed:@"linkMenu.png" ] forState:UIControlStateNormal];
    [menuElements addObject:infoButton];
    
    UIButton *prizeButton = [[UIButton alloc] initWithFrame:CGRectMake(xFirstCol, yThirdRow, 120, 120)];
    [prizeButton setTitle:nil forState:UIControlStateNormal];
    [prizeButton setImage:[UIImage imageNamed:@"twitMenu.png" ] forState:UIControlStateNormal];
    [menuElements addObject:prizeButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Search 
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.searchField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.searchField.text = nil;
}

- (IBAction)searchButtonPressed:(id)sender {
    [self.searchField resignFirstResponder];
}
- (IBAction)searchFieldEndEditing:(UITextField *)sender {
    [self startSearchStartForAddress:((UITextField *)sender).text];
}

- (void) startSearchStartForAddress:(NSString *)address {
}

// MARK: - Menu
- (IBAction)menuButtonPressed:(id)sender {
    
    if (menuOnScreen == NO) {
        
        self.menuView.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            const CGFloat scale = 30;
            [self.menuView setTransform:CGAffineTransformMakeScale(scale, scale)];
        } completion:^(BOOL finished) {
            menuOnScreen = YES;
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.menuIconImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            
            self.menuIconImage.image = [UIImage imageNamed:@"closeImage"];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.menuIconImage.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            // also pop the buttons
                [self popInTheButtons];
            }];
        }];
        
    } else {
    
        [self popOutTheButtons];
        
        [UIView animateWithDuration:0.5 animations:^{
            const CGFloat scale = 1;
            [self.menuView setTransform:CGAffineTransformMakeScale(scale, scale)];
        } completion:^(BOOL finished) {
            self.menuView.hidden = YES;
            menuOnScreen = NO;
        }];
        
        // TODO: externalize this part
        [UIView animateWithDuration:0.25 animations:^{
            self.menuIconImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            
            self.menuIconImage.image = [UIImage imageNamed:@"menuIconImage"];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.menuIconImage.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void) popInTheButtons {
    
    for (UIButton *but in menuElements) {
        [self.view addSubview:but];
    }
}

- (void) popOutTheButtons {
    
    for (UIButton *but in menuElements) {
        [but removeFromSuperview];
    }
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
