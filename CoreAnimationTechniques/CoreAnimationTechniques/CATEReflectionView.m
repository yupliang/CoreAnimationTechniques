//
//  CATEReflectionView.m
//  CoreAnimationTechniques
//
//  Created by app-01 on 2017/2/7.
//  Copyright © 2017年 EBOOK. All rights reserved.
//

#import "CATEReflectionView.h"

@implementation CATEReflectionView
+ (Class)layerClass {
    return [CAReplicatorLayer class];
}
- (void)setUp {
    //configure replicator
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    //move reflection instance below original and flip vertically
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.instanceTransform = transform;
    //reduce alpha of reflection layer
    layer.instanceAlphaOffset = -0.6f;
}
- (instancetype)initWithFrame:(CGRect)frame {
    //this is called when view is created in code
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib {
    //this is called when view is called from nib
    [self setUp];
}
@end
