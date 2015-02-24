//
//  MAConfirmButton.m
//

#import "MAConfirmButton.h"

#define kHeight 26.0
#define kPadding 20.0
#define kFontSize 14.0

#define kDisabledColor [UIColor colorWithRed:(204.0/255.0) green:(204.0/255.0) blue:(204.0/255.0) alpha:1.0]
#define kNormalColor [UIColor colorWithRed:(0.0/255.0) green:(122.0/255.0) blue:(255.0/255.0) alpha:1.0]
#define kBuyColor [UIColor colorWithRed:(25.0/255.0) green:(171.0/255.0) blue:(32.0/255.0) alpha:1.0]

@interface MAConfirmButton ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *confirm;
@property (nonatomic, copy) NSString *disabled;
@property (nonatomic, strong) UIColor *tint;

- (void)toggle;
- (void)setupLayers;
- (void)cancel;
- (void)lighten;
- (void)darken;

@end

@implementation MAConfirmButton

+ (MAConfirmButton *)buttonWithTitle:(NSString *)titleString confirm:(NSString *)confirmString{	
    MAConfirmButton *button = [[super alloc] initWithTitle:titleString confirm:confirmString];	
    return button;
}

+ (MAConfirmButton *)buttonWithDisabledTitle:(NSString *)disabledString{	
    MAConfirmButton *button = [[super alloc] initWithDisabledTitle:disabledString];	
    return button;
}

- (id)initWithDisabledTitle:(NSString *)disabledString{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.disabled = disabledString;
        self.toggleAnimation = MAConfirmButtonToggleAnimationLeft;

        self.layer.needsDisplayOnBoundsChange = YES;

        CGSize size = [self.disabled sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:kFontSize]}];
        CGRect r = self.frame;
        r.size.height = kHeight;
        r.size.width = size.width+kPadding;
        self.frame = r;

        [self setTitle:self.disabled forState:UIControlStateNormal];
        [self setTitleColor:kDisabledColor forState:UIControlStateNormal];

        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
        self.tint = kDisabledColor;

        [self setupLayers];
    }	
    return self;	
}

- (id)initWithTitle:(NSString *)titleString confirm:(NSString *)confirmString{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.title = titleString;
        self.confirm = confirmString;
        self.tint = kNormalColor;

        self.toggleAnimation = MAConfirmButtonToggleAnimationLeft;

        self.layer.needsDisplayOnBoundsChange = YES;

        CGSize size = [self.title sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:kFontSize]}];
        CGRect r = self.frame;
        r.size.height = kHeight;
        r.size.width = size.width+kPadding;
        self.frame = r;

        [self setTitle:self.title forState:UIControlStateNormal];
        [self setTitleColor:self.tint forState:UIControlStateNormal];

        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];

        [self setupLayers];
    }	
    return self;
}

- (void)toggle {
    if (self.userInteractionEnabled) {
        self.userInteractionEnabled = NO;
        self.titleLabel.alpha = 0;

        CGSize size;

        if (self.disabled) {
            [self setTitle:self.disabled forState:UIControlStateNormal];
            [self setTitleColor:kDisabledColor forState:UIControlStateNormal];
            size = [self.disabled sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:kFontSize]}];
        }
        else if (selected) {
            [self setTitle:self.confirm forState:UIControlStateNormal];
            [self setTitleColor:kBuyColor forState:UIControlStateNormal];
            size = [self.confirm sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:kFontSize]}];
        }
        else {
            [self setTitle:self.title forState:UIControlStateNormal];
            [self setTitleColor:self.tint forState:UIControlStateNormal];
            size = [self.title sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:kFontSize]}];
        }

        size.width += kPadding;
        float offset = size.width - self.frame.size.width;

        [CATransaction begin];
        [CATransaction setAnimationDuration:0.25];
        [CATransaction setCompletionBlock:^{
            //Readjust button frame for new touch area, move layers back now that animation is done

            CGRect frameRect = self.frame;
            switch(self.toggleAnimation) {
                case MAConfirmButtonToggleAnimationLeft:
                    frameRect.origin.x = frameRect.origin.x - offset;
                    break;
                case MAConfirmButtonToggleAnimationRight:
                    break;
                case MAConfirmButtonToggleAnimationCenter:
                    frameRect.origin.x = frameRect.origin.x - offset/2.0;
                    break;
                default:
                    break;
            }
            frameRect.size.width = frameRect.size.width + offset;
            self.frame = frameRect;

            [CATransaction setDisableActions:YES];
            [CATransaction setCompletionBlock:^{
                self.userInteractionEnabled = YES;
            }];
            
            for(CALayer *layer in self.layer.sublayers) {
                CGRect rect = layer.frame;
                switch(self.toggleAnimation) {
                    case MAConfirmButtonToggleAnimationLeft:
                        rect.origin.x = rect.origin.x+offset;
                        break;
                    case MAConfirmButtonToggleAnimationRight:
                        break;
                    case MAConfirmButtonToggleAnimationCenter:
                        rect.origin.x = rect.origin.x+offset/2.0;
                        break;
                    default:
                        break;
                }

                layer.frame = rect;
            }
            [CATransaction commit];

            self.titleLabel.alpha = 1;
            [self setNeedsLayout];
        }];

        UIColor *greenColor = kBuyColor;

        // Animate color change
        CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        borderAnimation.removedOnCompletion = NO;
        borderAnimation.fillMode = kCAFillModeForwards;

        if (self.disabled) {
            borderAnimation.fromValue = (id)greenColor.CGColor;
            borderAnimation.toValue = (id)kDisabledColor.CGColor;
        } else {
            borderAnimation.fromValue = selected ? (id)self.tint.CGColor : (id)greenColor.CGColor;
            borderAnimation.toValue = selected ? (id)greenColor.CGColor : (id)self.tint.CGColor;
        }

        [colorLayer addAnimation:borderAnimation forKey:@"colorAnimation"];

        // Animate layer scaling
        for (CALayer *layer in self.layer.sublayers) {
            CGRect rect = layer.frame;

            switch (self.toggleAnimation) {
                case MAConfirmButtonToggleAnimationLeft:
                    rect.origin.x = rect.origin.x-offset;
                    break;
                case MAConfirmButtonToggleAnimationRight:
                    break;
                case MAConfirmButtonToggleAnimationCenter:
                    rect.origin.x = rect.origin.x-offset/2.0;
                    break;
                default:
                    break;
            }
            rect.size.width = rect.size.width + offset;
            layer.frame = rect;
        }
        [CATransaction commit];
        [self setNeedsDisplay];
    }
}

- (void)setupLayers {
    colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    colorLayer.borderColor = self.tint.CGColor;
    colorLayer.backgroundColor = [UIColor clearColor].CGColor;
    colorLayer.borderWidth = 1.0;	
    colorLayer.cornerRadius = 4.0;
    colorLayer.needsDisplayOnBoundsChange = YES;

    [self.layer addSublayer:colorLayer];
    [self bringSubviewToFront:self.titleLabel];
}

- (void)setSelected:(BOOL)s {
    selected = s;
    [self toggle];
}

- (void)disableWithTitle:(NSString *)disabledString {
    self.disabled = disabledString;    
    [self toggle];	
}

- (void)setAnchor:(CGPoint)anchor {
    // Top-right point of the view (MUST BE SET LAST)
    CGRect rect = self.frame;
    rect.origin = CGPointMake(anchor.x - rect.size.width, anchor.y);
    self.frame = rect;
}

- (void)setTintColor:(UIColor *)color {
    self.tint = color;
    [self setTitleColor:self.tint forState:UIControlStateNormal];
    colorLayer.borderColor = self.tint.CGColor;
    [self setNeedsDisplay];
}

- (void)darken {
    darkenLayer = [CALayer layer];
    darkenLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    darkenLayer.backgroundColor = [UIColor clearColor].CGColor;
    darkenLayer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    darkenLayer.cornerRadius = 4.0;
    darkenLayer.needsDisplayOnBoundsChange = YES;
    [self.layer addSublayer:darkenLayer];
}

- (void)lighten {
    if (darkenLayer) {
        [darkenLayer removeFromSuperlayer];
        darkenLayer = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.disabled && !confirmed && self.userInteractionEnabled) {
        [self darken];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.disabled && !confirmed && self.userInteractionEnabled) {
        if (!CGRectContainsPoint(self.frame, [[touches anyObject] locationInView:self.superview])) {
            [self lighten];
            [super touchesCancelled:touches withEvent:event];
        } else if(selected) {
            [self lighten];
            confirmed = YES;
            [cancelOverlay removeFromSuperview];
            cancelOverlay = nil;
            [super touchesEnded:touches withEvent:event];
        } else {
            [self lighten];		
            self.selected = YES;            
            if (!cancelOverlay) {
                cancelOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelOverlay setFrame:CGRectMake(0, 0, 1024, 1024)];
                [cancelOverlay addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
                [self.superview addSubview:cancelOverlay];                
            }
            [self.superview bringSubviewToFront:self];
        }
    }
}

- (void)cancel {
    if (cancelOverlay && self.userInteractionEnabled) {
        [cancelOverlay removeFromSuperview];
        cancelOverlay = nil;	
    }	
    self.selected = NO;
}

@end
