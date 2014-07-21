//
//  ViewController.m
//  CustomAlertView
//
//  Created by jason on 7/21/14.
//  Copyright (c) 2014 jason. All rights reserved.
//

#import "ViewController.h"
#import "CAlertView.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <CAlertViewDelegate>

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *statusBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusBarBackgroundView.backgroundColor = [self colorWithHex:0x222222 alpha:1.0];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, ScreenWidth - 60, 45)];
    button.backgroundColor = [self colorWithHex:0x77C9DD alpha:1.0];
    [button setTitle:@"show alert view" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:statusBarBackgroundView];
    [self.view addSubview:button];
    
    
    // Do any additional setup after loading the view.
}

- (void)showAlertView
{
    CAlertView *alertlertView = [[CAlertView alloc] initWithTitle:@"Alert" cancelButtonTitle:@"cancel" otherButtonTitles:@"comfirm", nil];
    UIView *contentView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 100)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:contentView.frame];
    backgroundImageView.image = [UIImage imageNamed:@"bg1"];
    UILabel *label  = [[UILabel alloc] initWithFrame:contentView.frame];
    label.text      = @"create what you like ：)";
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    
    [contentView addSubview:backgroundImageView];
    [contentView addSubview:label];
    alertlertView.delegate = self;
    alertlertView.contentView = contentView;
    
    
    [alertlertView show];
}

- (void)touchUpInsideButtonAtIndex:(NSInteger)index
{
    
}

- (UIColor *)colorWithHex:(uint)hex alpha:(CGFloat)alpha
{
    int red,green,blue;
    
    blue  = (hex  & 0x0000FF);
    green = ((hex & 0x00FF00) >> 8);
    red   = ((hex & 0xFF0000) >> 16);
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
