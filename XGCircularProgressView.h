//  Created by whg on 17/9/5.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XGCircularType) {
    XGCircularTypeDefault = 0,
    XGCircularTypeGradient,     //渐变色圆环进度
};

@interface XGCircularProgressView : UIView

@property (nonatomic, assign) XGCircularType type;

@property (nonatomic, assign) CGFloat lineWidth;
//0-1
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *outLayer;
//开始角度 * M_PI
@property (nonatomic, assign) CGFloat startAngle;
//结束角度
@property (nonatomic, assign) CGFloat endAngle;

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
