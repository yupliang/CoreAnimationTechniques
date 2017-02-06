//
//  ViewController.m
//  CoreAnimationTechniques
//
//  Created by app-01 on 2017/2/4.
//  Copyright © 2017年 EBOOK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CALayerDelegate>
@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) CALayer *blueLayer;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *digitViews;


@end

UIView * (^getClockHand)(CGRect frame, NSString *imageName) = ^UIView *(CGRect frame, NSString *imageName){
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    view.layer.contents = (__bridge id)image.CGImage;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    view.layer.contentsGravity = kCAGravityResizeAspect;
    return view;
};
UIView * (^getAView)(CGRect frame, UIColor *backgroundColor) = ^UIView *(CGRect frame, UIColor *backgroundColor){
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
};
@implementation ViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    UIImage *digits = [UIImage imageNamed:@"Digits"];
    //set up digit views
    [_digitViews enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL * _Nonnull stop) {
        //set contents
        aView.layer.contents = (__bridge id)digits.CGImage;
        aView.layer.contentsRect = CGRectMake(0, 0, 0.1f, 1.0f);
        aView.layer.contentsGravity = kCAGravityResizeAspect;
        aView.layer.magnificationFilter = kCAFilterNearest;
    }];
    //start timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    //set initial clock time
    [self tick];
}
- (void)setDigit:(NSInteger)digit forView:(UIView *)view {
    //adjust contentsRect to select correct digit
    view.layer.contentsRect = CGRectMake(0.1*digit, 0, 0.1f, 1);
}
- (void)tick {
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    //set hours
    [self setDigit:components.hour/10 forView:self.digitViews[0]];
    [self setDigit:components.hour%10 forView:self.digitViews[1]];
    
    //set minutes
    [self setDigit:components.minute/10 forView:self.digitViews[2]];
    [self setDigit:components.minute%10 forView:self.digitViews[3]];
    
    //set seconds
    [self setDigit:components.second/10 forView:self.digitViews[4]];
    [self setDigit:components.second%10 forView:self.digitViews[5]];
}

#pragma mark - TOUCH EVENT
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //convert point to the white layer's coordinates
    point = [_layerView.layer convertPoint:point fromLayer:self.view.layer];
    //get layer using containsPoint:
    if ([_layerView.layer containsPoint:point]) {
        //convert point to blueLayer's coordinates
        point = [self.blueLayer convertPoint:point fromLayer:_layerView.layer];
        if ([_blueLayer containsPoint:point]) {
            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
                                       message:nil
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
                                       message:nil
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        }
    }
}
 */ //containsPoint:
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //get touch position
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CALayer *layer = [_layerView.layer hitTest:point];
    if (_blueLayer && layer == _blueLayer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil, nil] show];
    } else if (_layerView && layer == _layerView.layer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - CALAYER DELEGATE
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

@end
