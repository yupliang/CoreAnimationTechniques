//
//  CATEScrollView.m
//  CoreAnimationTechniques
//
//  Created by app-01 on 2017/2/8.
//  Copyright © 2017年 EBOOK. All rights reserved.
//

#import "CATEScrollView.h"

@implementation CATEScrollView
+ (Class)layerClass {
    return [CAScrollLayer class];
}
- (void)setUp {
    //enable clipping
    self.layer.masksToBounds = YES;
    //attach pan gesture recognizer
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:recognizer];
}
- (instancetype)initWithFrame:(CGRect)frame {
    //this is called when view is created in code
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib {
    //this is called when view is created in code
    [self setUp];
}
- (void)pan:(UIPanGestureRecognizer *)reconizer {
    //get the offset by subtracting the pan gesture
    //translation from the current bounds orgin
    CGPoint offset = self.bounds.origin;
    offset.x -= [reconizer translationInView:self].x;
    offset.y -= [reconizer translationInView:self].y;
    //scroll the layer
    [(CAScrollLayer *)self.layer scrollToPoint:offset];
    //reset the pan gesture translation
    [reconizer setTranslation:CGPointZero inView:self];
}
@end
