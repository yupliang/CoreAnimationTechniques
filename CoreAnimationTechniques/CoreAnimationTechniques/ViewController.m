//
//  ViewController.m
//  CoreAnimationTechniques
//
//  Created by app-01 on 2017/2/4.
//  Copyright © 2017年 EBOOK. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <CoreText/CoreText.h>
#import "CATELayerLabel.h"
#import "CATEScrollView.h"
#define LIGHT_DIRECTION 0,1,-0.5
#define AMBIENT_LIGHT 0.5
@interface ViewController () <CALayerDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *faces;
@end
@interface CATiledLayer (CATEFADE)

@end
@implementation CATiledLayer (CATEFADE)

+ (CFTimeInterval)fadeDuration {
    return 0.0f;
}

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
UIButton * (^getAButton)() = ^UIButton *(){
    //create button
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10.0f;
    //add label
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"Hello World";
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    return button;
};
@implementation ViewController
- (void)loadView {
    [super loadView];
    //add the tiled layer
    CATiledLayer *tileLayer = [CATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 14935/2, 847/2);
    tileLayer.delegate = self;
    tileLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.scrollView.layer addSublayer:tileLayer];
    //configure the scroll view
    _scrollView.contentSize = tileLayer.frame.size;
    //draw layer
    [tileLayer setNeedsDisplay];
}
#pragma mark - CALAYER DELEGATE
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    //determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    CGFloat scale = [UIScreen mainScreen].scale;
    NSInteger x = floor(bounds.origin.x/layer.tileSize.width*scale);
    NSInteger y = floor(bounds.origin.y/layer.tileSize.height*scale);
    //load tile image
    NSString *imageName = [NSString stringWithFormat:@"pics_%02i_%02i",x,y];
    NSLog(@"imageName %@ %@", imageName, NSStringFromCGRect(bounds));
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *tileImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

- (IBAction)tap:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}
@end
