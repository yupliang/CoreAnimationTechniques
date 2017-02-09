//
//  CATELayerLabel.m
//  CoreAnimationTechniques
//
//  Created by app-01 on 2017/2/7.
//  Copyright © 2017年 EBOOK. All rights reserved.
//

#import "CATELayerLabel.h"

@implementation CATELayerLabel

+ (Class)layerClass {
    //this makes our label create a CATextLayer insted of a regular CALayer for its backing layer
    return [CALayer class];
}
- (CATextLayer *)textLayer {
    return (CATextLayer *)nil;
}
- (void)setUp {
    NSLog(@"%s",__FUNCTION__);
    //set defaults from UILabel settings
    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    [self textLayer].alignmentMode = kCAAlignmentJustified;
    
    [self textLayer].wrapped = YES;
    [self.layer display];
}
- (instancetype)initWithFrame:(CGRect)frame {
    //called when creating label programmatically
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib {
    //called when creating label using IB
    [self setUp];
}
- (void)setText:(NSString *)text {
    super.text = text;
    //set layer text
    [self textLayer].string = text;
    NSLog(@"layer %@", [self textLayer]);
}
- (void)setTextColor:(UIColor *)textColor {
    super.textColor = textColor;
    //set layer text color
    [self textLayer].foregroundColor = textColor.CGColor;
}
- (void)setFont:(UIFont *)font {
    super.font = font;
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
    CGFontRelease(fontRef);
}
@end
