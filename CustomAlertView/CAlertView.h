//
//  CAlertView.h
//  CustomAlertView
//
//  Created by jason on 7/21/14.
//  Copyright (c) 2014 jason. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CAlertViewDelegate <NSObject>

- (void)touchUpInsideButtonAtIndex:(NSInteger)index;

@end

@interface CAlertView : UIView

@property(nonatomic,strong)id<CAlertViewDelegate> delegate;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView  *contentView;
@property(nonatomic)NSInteger tag;

- (void)show;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
