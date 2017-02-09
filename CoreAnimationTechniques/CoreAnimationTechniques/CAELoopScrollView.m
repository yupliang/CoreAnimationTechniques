//
//  CAELoopScrollView.m
//  CoreAnimationTechniques
//
//  Created by app-01 on 2017/2/7.
//  Copyright © 2017年 EBOOK. All rights reserved.
//

#import "CAELoopScrollView.h"
#define kSUBVIEW_WIDTH 200
@interface CAELoopScrollView () <UIScrollViewDelegate>

@end

@implementation CAELoopScrollView
- (void)awakeFromNib {
    [self setUp];
}
- (void)setUp {
    self.delegate = self;
    self.pagingEnabled = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.contentOffset = CGPointMake(kSUBVIEW_WIDTH, 0);
}
@end
