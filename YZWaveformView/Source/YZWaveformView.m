//
//  YZWaveformView.m
//  YZWaveformView
//
//  Created by Yifei Zhou on 1/26/15.
//  Copyright (c) 2015 Yifei Zhou. All rights reserved.
//

#import "YZWaveformView.h"

@interface YZWaveformView ()

@property (nonatomic, assign) CGFloat phase;
@property (nonatomic, assign) CGFloat amplitude;
@property (nonatomic, assign, readwrite) NSUInteger numberOfWaves;

@end

@implementation YZWaveformView

- (id)init
{
    if(self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.frequency = 1.5f;
    
    self.amplitude = 1.0f;
    self.idleAmplitude = 0.01f;
    
    self.numberOfWaves = 3;
    self.phase = 0.0f;
    self.phaseShift = 0.05f;
    self.density = 5.0f;
}

-(void)updateWithLevel:(CGFloat)level
{
    if (self.phase <= -1.0f)
        self.phaseShift = 0.05f;
    else if (self.phase >= 1.0f)
        self.phaseShift = -0.05f;
    self.phase += self.phaseShift;
    self.amplitude = fmax( level, self.idleAmplitude);
    
    [self setNeedsDisplay];
}

// Thanks to Raffael Hannemann https://github.com/raffael/SISinusWaveView
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [self.backgroundColor set];
    CGContextFillRect(context, rect);
    
//    NSLog(@"%f", self.amplitude);
    
    CGContextSetBlendMode(context, kCGBlendModeDifference);
    
    // We draw multiple sinus waves, with equal phases but altered amplitudes, multiplied by a parable function.
    for(int i=0; i < self.numberOfWaves; i++) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 0.0f);
        
        CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat mid = width / 2.0f;
        
        const CGFloat maxAmplitude = halfHeight - 4.0f; // 4 corresponds to twice the stroke width
        
        CGContextSetFillColorWithColor(context, [self fillColorAtIndex:i].CGColor);
        
        for(CGFloat x = 0; x<width + self.density; x += self.density) {
            
            // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
            CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
            
            CGFloat ellipse = sqrtf((1 + x * (width - x)) * 0.001);
            
            CGFloat y;
            switch (i) {
                case 0:
                    y = ellipse - scaling * ((self.phase) * sinf(2 * M_PI * x / width) + (1 - self.phase) * sinf(3 * M_PI * x/width));
                    break;
            
                case 1:
                    y = ellipse - scaling * ((1 - self.phase) * sinf(2 * M_PI * x / width + 3/2 * M_PI) + (self.phase) * sinf(3 * M_PI * x/width + 3/2 * M_PI));
                    break;
                    
                default:
                    y = ellipse - scaling * ((self.phase) * sinf(2 * M_PI * x / width - 3/2 * M_PI) + (1 - self.phase) * sinf(3 * M_PI * x/width - 3/2 * M_PI));
                    break;
            }
            
            y = - y * self.amplitude * maxAmplitude + halfHeight;
            
            if (x==0) {
                CGContextMoveToPoint(context, x, y);
            }
            else {
                CGContextAddLineToPoint(context, x, y);
            }
        }
        
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

- (UIColor *)fillColorAtIndex:(NSUInteger)idx
{
    switch (idx) {
        case 0:
            return [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.9f]; // red
        case 1:
            return [UIColor colorWithRed:0 green:1.0f blue:0 alpha:0.9f]; // green
        default:
            return [UIColor colorWithRed:0 green:0 blue:1.0f alpha:0.9f]; // blue
    }
}

@end
