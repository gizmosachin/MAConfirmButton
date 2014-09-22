//
//  SampleViewController.m
//

#import "SampleViewController.h"
#import "MAConfirmButton.h"

@interface SampleViewController ()
@property (nonatomic, strong) MAConfirmButton *resetButton;

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    MAConfirmButton *defaultButton = [MAConfirmButton buttonWithTitle:@"$9.99" confirm:@"BUY NOW"];
    [defaultButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [defaultButton setAnchor:CGPointMake(200, 50)];
    [self.view addSubview:defaultButton];
    
    MAConfirmButton *tintedButton = [MAConfirmButton buttonWithTitle:@"Tinted" confirm:@"Confirm String"];
    [tintedButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [tintedButton setTintColor:[UIColor colorWithRed:0.176 green:0.569 blue:0.820 alpha:1]];
    [tintedButton setAnchor:CGPointMake(200, 100)];
    [self.view addSubview:tintedButton];
    
    MAConfirmButton *disabledButton = [MAConfirmButton buttonWithDisabledTitle:@"DISABLED"];
    [disabledButton setAnchor:CGPointMake(200, 150)];
    [self.view addSubview:disabledButton];
    
    MAConfirmButton *toggleRightButton = [MAConfirmButton buttonWithTitle:@"$0.99" confirm:@"Toggled to Right"];
    toggleRightButton.toggleAnimation = MAConfirmButtonToggleAnimationRight;
    [toggleRightButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [toggleRightButton setAnchor:CGPointMake(200, 200)];
    [self.view addSubview:toggleRightButton];
    
    self.resetButton = [MAConfirmButton buttonWithTitle:@"Reset" confirm:@"Are you sure?"];
    [self.resetButton addTarget:self action:@selector(setup) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton setTintColor:[UIColor colorWithRed:0.694 green:0.184 blue:0.196 alpha:1]];
    [self.resetButton setAnchor:CGPointMake(200, 250)];
    [self.view addSubview:self.resetButton];
}

- (void)confirmAction:(id)sender {
    [sender disableWithTitle:[@"Confirmed" uppercaseString]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
