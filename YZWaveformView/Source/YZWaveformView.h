//
//  YZWaveformView.h
//  YZWaveformView
//
//  Created by Yifei Zhou on 1/26/15.
//  Copyright (c) 2015 Yifei Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZWaveformView : UIView

/*
 * Tells the waveform to redraw itself using the given level (normalized value)
 */
-(void)updateWithLevel:(CGFloat)level;

/*
 * The total number of waves
 */
@property (nonatomic, readonly) NSUInteger numberOfWaves;

/*
 * The amplitude that is used when the incoming amplitude is near zero.
 * Setting a value greater 0 provides a more vivid visualization.
 * Default: 0.01
 */
@property (nonatomic, assign) CGFloat idleAmplitude;

/*
 * The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
 * Default: 1.5
 */
@property (nonatomic, assign) CGFloat frequency;

/*
 * The current amplitude
 */
@property (nonatomic, assign, readonly) CGFloat amplitude;

/*
 * The lines are joined stepwise, the more dense you draw, the more CPU power is used.
 * Default: 5
 */
@property (nonatomic, assign) CGFloat density;

/*
 * The phase shift that will be applied with each level setting
 * Change this to modify the animation speed or direction
 * Default: -0.15
 */
@property (nonatomic, assign) CGFloat phaseShift;

@end