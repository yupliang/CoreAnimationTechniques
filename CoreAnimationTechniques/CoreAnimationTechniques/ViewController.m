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
@property (nonatomic, strong) UIView *hourHand;
@property (nonatomic, strong) UIView *minuteHand;
@property (nonatomic, strong) UIView *secondHand;
@property (nonatomic, weak) NSTimer *timer;
@end

UIView * (^getClockHand)(CGRect frame, NSString *imageName) = ^UIView *(CGRect frame, NSString *imageName){
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    view.layer.contents = (__bridge id)image.CGImage;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    view.layer.contentsGravity = kCAGravityResizeAspect;
    return view;
};
@implementation ViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _layerView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    UIImage *image = [UIImage imageNamed:@"ClockFace"];
    _layerView.layer.contents = (__bridge id)image.CGImage;
    _layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    _layerView.layer.contentsGravity = kCAGravityResizeAspect;
    [self.view addSubview:_layerView];
    
    //HourHand
    self.hourHand = getClockHand(CGRectMake(92.0f, 74.0f, 21.0f, 66.5f),@"HourHand");
    [_layerView addSubview:_hourHand];
    self.minuteHand = getClockHand(CGRectMake(96.0f, 65.0f, 13.5f, 74.5f),@"MinuteHand");
    [_layerView addSubview:_minuteHand];
    self.secondHand = getClockHand(CGRectMake(100.0f, 68.0f, 6.5f, 72.0f),@"SecondHand");
    [_layerView addSubview:_secondHand];
    _hourHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    _minuteHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    _secondHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    //start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    //set initial hand positions
    [self tick];
}
- (void)tick {
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour/12.0)*M_PI*2.0;
    CGFloat minutesAngle = (components.minute/60.0)*M_PI*2.0;
    CGFloat secondAngle = (components.second/60.0)*M_PI*2.0;
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteHand.transform = CGAffineTransformMakeRotation(minutesAngle);
    self.secondHand.transform = CGAffineTransformMakeRotation(secondAngle);
}

#pragma mark - CALAYER DELEGATE
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
