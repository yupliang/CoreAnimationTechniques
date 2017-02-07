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
#define LIGHT_DIRECTION 0,1,-0.5
#define AMBIENT_LIGHT 0.5
@interface ViewController () <CALayerDelegate>
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *faces;
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
- (CALayer *)faceWithTransform:(CATransform3D)transform {
    //create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    //apply a random color
    CGFloat red = rand()/(double)INT_MAX;
    CGFloat green = rand()/(double)INT_MAX;
    CGFloat blue = rand()/(double)INT_MAX;
    
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
    //apply the transform and return
    face.transform = transform;
    return face;
}
- (CALayer *)cubeWithTransform:(CATransform3D)transform {
    //create cube layer
    CATransformLayer *cube = [CATransformLayer layer];
    //add cube face 1
    [cube addSublayer:[self faceWithTransform:CATransform3DMakeTranslation(0, 0, 50)]];
    //add cube face 2
    CATransform3D ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    //add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //center the cube layer within the container
    CGSize containerSize = _containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width/2.0f, containerSize.height/2.0f);
    //apply the transform and return
    cube.transform = transform;
    return cube;
}
- (void)loadView {
    [super loadView];
    //set up the perspective transform
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0f/500.0f;
    _containerView.layer.sublayerTransform = pt;
    //set up the transform for cube 1 and add it
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [_containerView.layer addSublayer:cube1];
    
    //set up the transform for cube 2 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [_containerView.layer addSublayer:cube2];
}


- (IBAction)tap:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}
@end
