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
#import <OpenGLES/EAGL.h>

#define LIGHT_DIRECTION 0,1,-0.5
#define AMBIENT_LIGHT 0.5
@interface ViewController () <CALayerDelegate>
@property (nonatomic, weak) IBOutlet UIView *glView;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, assign) GLuint frameBuffer;
@property (nonatomic, assign) GLuint colorRenderBuffer;
@property (nonatomic, assign) GLuint framebufferWidth;
@property (nonatomic, assign) GLuint framebufferHeight;
@property (nonatomic, strong) GLKBaseEffect *effect;
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
- (void)setUpBuffers {
    //set up frame buffer
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    //set up color render buffer
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);
    //check success
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}
- (void)tearDownBuffers {
    if (_frameBuffer) {
        //delete framebuffer
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    if (_colorRenderBuffer) {
        //delete color render buffer
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
}
- (void)drawFrame {
    //bind framebuffer & set viewport
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, _framebufferWidth, _framebufferHeight);
    //bind shader program
    [self.effect prepareToDraw];
    //clear the screen
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    //set up verticles
    GLfloat vertices[] = {-0.5f, -0.5f, -1.0f, 0.0f, 0.5f, -1.0f, 0.5f, -0.5f, -1.0f,};
    //set up colors
    GLfloat colors[] = {0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f};
    //draw triangle
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    //present render buffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)loadView {
    [super loadView];
    //set up context
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
    //set up layer
    self.glLayer = [CAEAGLLayer layer];
    _glLayer.frame = _glView.bounds;
    [_glView.layer addSublayer:_glLayer];
    _glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@NO, kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8};
    //set up base effect
    self.effect = [[GLKBaseEffect alloc] init];
    //set up buffers
    [self setUpBuffers];
    //draw frame
    [self drawFrame];
}
- (void)viewDidUnload {
    [self tearDownBuffers];
    [super viewDidUnload];
}
- (IBAction)tap:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}
- (void)dealloc
{
    [self tearDownBuffers];
    [EAGLContext setCurrentContext:nil];
}
@end
