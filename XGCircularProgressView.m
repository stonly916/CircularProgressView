//  Created by whg on 17/9/5.


#import "XGCircularProgressView.h"

@interface XGCircularProgressView()
@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation XGCircularProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = clear_color;
        _lineWidth = 3;
    }
    return self;
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self addBackArc];
    [self addProgressArc];
}

- (void)addBackArc
{
    if (self.backLayer == nil) {
        CAShapeLayer *outLayer = [CAShapeLayer layer];
        self.backLayer = outLayer;
    }
    
    CGFloat width = self.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                                        radius:width/2.0f - _lineWidth
                                                    startAngle:_startAngle
                                                      endAngle:_endAngle
                                                     clockwise:YES];
    
    if (self.type == XGCircularTypeDefault) {
        self.backLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    }else if (self.type == XGCircularTypeGradient) {
        self.backLayer.strokeColor = LINE_BG.CGColor;
    }
    
    self.backLayer.lineWidth = _lineWidth;
    self.backLayer.fillColor =  [UIColor clearColor].CGColor;
    self.backLayer.lineCap = kCALineCapRound;
    self.backLayer.path = path.CGPath;
    if (self.backLayer.superlayer == nil) {
        [self.layer addSublayer:self.backLayer];
    }
    
    if (self.outLayer == nil) {
        self.outLayer = [CAShapeLayer layer];
    }
}

- (void)addProgressArc
{
    CGFloat width = self.width;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                                        radius:width/2.0f - _lineWidth
                                                    startAngle:_startAngle
                                                      endAngle:_endAngle
                                                     clockwise:YES];
    self.outLayer.strokeColor = white_color.CGColor;
    self.outLayer.lineWidth = _lineWidth;
    self.outLayer.fillColor =  [UIColor clearColor].CGColor;
    self.outLayer.lineCap = kCALineCapRound;
    self.outLayer.path = path.CGPath;
    self.outLayer.strokeEnd = 0;
    if (self.type == XGCircularTypeDefault) {
        if (self.outLayer.superlayer == nil) {
            [self.layer addSublayer:self.outLayer];
        }
    }else if (self.type == XGCircularTypeGradient && self.gradientLayer == nil){
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)XG_COLOR_GRADIEN_A.CGColor, (__bridge id)XG_COLOR_GRADIEN_B.CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, self.width, self.height);
        [self.layer addSublayer:gradientLayer];
        self.gradientLayer = gradientLayer;
        self.gradientLayer.mask = self.outLayer;
    }
    if (_progress > 0) {
        self.outLayer.strokeEnd = _progress;
        [self layoutIfNeeded];
    }
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    _progress = progress;
    if (animated) {
        [self updatePath:progress];
    }else {
        self.outLayer.strokeEnd = _progress;
        [self layoutIfNeeded];
    }
}

- (void)updatePath:(CGFloat)progress {
    self.outLayer.strokeEnd = 0;
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    self.outLayer.strokeEnd = _progress;
    [CATransaction commit];
}

@end
