//
//  CAlertView.m
//  CustomAlertView
//
//  Created by jason on 7/21/14.
//  Copyright (c) 2014 jason. All rights reserved.
//

#import "CAlertView.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

const static CGFloat  headerViewHeight = 46.0;
const static CGFloat  bottomViewHeight = 46.0;

@interface CAlertView ()

@property(nonatomic,strong)UIView *dialogContainerView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIWindow *alertWindow;
@property(nonatomic,strong)NSMutableArray *buttonsTitle;
@property(nonatomic,strong)NSString *title;

@end

@implementation CAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [self colorWithHex:0x000000 alpha:0.4];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.title = title;
        NSMutableArray *buttonsTitle = [NSMutableArray array];
        NSString *buttonTitle;
        va_list argumentList;
        [buttonsTitle addObject:cancelButtonTitle];
        if(otherButtonTitles){
            [buttonsTitle addObject:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while((buttonTitle = va_arg(argumentList, id))){
                [buttonsTitle addObject:buttonTitle];
            }
            va_end(argumentList);
        }
        self.buttonsTitle = buttonsTitle;
    }
    return self;
}

- (void)show
{
    if (!self.alertWindow) {
        self.alertWindow = [[UIWindow alloc] initWithFrame:self.frame];
        self.alertWindow.windowLevel = UIWindowLevelStatusBar + 1;
        self.alertWindow.backgroundColor = [UIColor clearColor];
        self.alertWindow.hidden = NO;
    }
    if (!self.contentView) {
        self.contentView = [self createContentView];
    } else {
        self.contentView.frame = CGRectMake(0, headerViewHeight, [self widthOfView:self.contentView], [self heightOfView:self.contentView]);
    }
    self.dialogContainerView = [self createDialogContainerView];
    [self addButtonsToBottomView];
    
    [self addSubview:self.dialogContainerView];
    [self.alertWindow addSubview:self];
    
    [self popInAnimation];
}

- (UIView *)createDialogContainerView
{
    CGFloat contentViewWidth  = [self widthOfView:self.contentView];
    CGFloat contentViewHeight = [self heightOfView:self.contentView];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,contentViewWidth, headerViewHeight)];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:self.headerView.frame];
    self.titleLabel.text            = self.title;
    self.titleLabel.textAlignment   = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.headerView addSubview:self.titleLabel];
    [self addLineToView:self.headerView withFrame:CGRectMake(0, [self heightOfView:self.headerView], [self widthOfView:self.headerView], 0.5)];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [self bottomOfView:self.contentView], contentViewWidth, bottomViewHeight)];
    [self addLineToView:self.bottomView withFrame:CGRectMake(0, 0, [self widthOfView:self.bottomView], 0.5)];
    
    CGFloat height = headerViewHeight + contentViewHeight + bottomViewHeight;
    UIView *dialogContainerView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - contentViewWidth) / 2, (ScreenHeight - height ) / 2 + 17, contentViewWidth, height)];
    dialogContainerView.alpha              = 0.9;
    dialogContainerView.clipsToBounds      = YES;
    dialogContainerView.backgroundColor    = [UIColor whiteColor];
    dialogContainerView.layer.cornerRadius = 7;
    [dialogContainerView addSubview:self.headerView];
    [dialogContainerView addSubview:self.contentView];
    [dialogContainerView addSubview:self.bottomView];
    
    return dialogContainerView;
}

- (UIView *)createContentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, headerViewHeight, ScreenWidth - 60 , 0)];
    
    return view;
}

- (void)addButtonsToBottomView
{
    if (self.buttonsTitle == nil || self.buttonsTitle.count == 0) {
        return;
    }
    CGFloat buttonWidth = [self widthOfView:self.bottomView] / self.buttonsTitle.count;
    for (int i = 0 ; i < self.buttonsTitle.count ; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * i, 0 , buttonWidth - 0.5, bottomViewHeight)];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:[self.buttonsTitle objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[self colorWithHex:0x4FA4EC alpha:1.0 ] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchdownButton:)     forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(dragOutOfButton:)     forControlEvents:UIControlEventTouchDragOutside];
        [button addTarget:self action:@selector(dragInsideOfButton:)  forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(touchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addLineToView:button withFrame:CGRectMake(buttonWidth - 0.5, 0, 0.5, bottomViewHeight)];
        [self.bottomView addSubview:button];
        
    }
    
}

- (void)dragOutOfButton:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^(){
        button.backgroundColor = [UIColor clearColor];
    }];
}

- (void)dragInsideOfButton:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^(){
        button.backgroundColor = [self colorWithHex:0xeeeeee alpha:1.0];
    }];
}

- (void)touchdownButton:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^(){
        button.backgroundColor = [self colorWithHex:0xeeeeee alpha:1.0];
    }];
}

- (void)touchUpInsideButton:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^(){
        button.backgroundColor = [UIColor clearColor];
    }];
    if ([self.delegate respondsToSelector:@selector(touchUpInsideButtonAtIndex:)]) {
        [self.delegate touchUpInsideButtonAtIndex:button.tag];
        
    }
    [self popOutAnimation];
}

- (void)addLineToView:(UIView *)view withFrame:(CGRect)frame
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [self colorWithHex:0xC7C7CC alpha:1.0];
    [view addSubview:line];
}

- (void)popInAnimation
{
    CALayer *viewLayer = self.dialogContainerView.layer;
    CAKeyframeAnimation *popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    popInAnimation.duration = 0.2555;
    popInAnimation.values   = @[@1.1f,@0.9f,@1.0f];
    
    popInAnimation.keyTimes = @[@0.0,@0.6,@1.0];
    popInAnimation.delegate = self.dialogContainerView;
    
    [viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];
    
    __weak CAlertView *alertView = self;
    [UIView animateWithDuration:0.2555 animations:^(){
        alertView.backgroundColor = [self colorWithHex:0x000000 alpha:0.5];
    }];
    
}

- (void)popOutAnimation
{
    __weak CAlertView *alertView = self;
    [UIView animateWithDuration:0.3 animations:^(){
        alertView.dialogContainerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        alertView.dialogContainerView.alpha = 0;
    } completion:^(BOOL finished){
        alertView.alertWindow = nil;
    }];
    [UIView animateWithDuration:0.2 animations:^(){
        alertView.backgroundColor = [alertView colorWithHex:0x000000 alpha:0.0];
    }];
}

- (UIColor *)colorWithHex:(uint)hex alpha:(CGFloat)alpha
{
    int red,green,blue;
    
    blue  = (hex  & 0x0000FF);
    green = ((hex & 0x00FF00) >> 8);
    red   = ((hex & 0xFF0000) >> 16);
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

- (CGFloat)widthOfView:(UIView *)view
{
    return CGRectGetWidth(view.frame);
}

- (CGFloat)heightOfView:(UIView *)view
{
    return CGRectGetHeight(view.frame);
}

- (CGFloat)bottomOfView:(UIView *)view
{
    return view.frame.origin.y + view.frame.size.height;
}

- (CGFloat)rightOfView:(UIView *)view
{
    return view.frame.origin.x + view.frame.size.width;
}

- (CGFloat)leftOfView:(UIView *)view
{
    return view.frame.origin.x;
}

- (CGFloat)topOfView:(UIView *)view
{
    return view.frame.origin.y;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
