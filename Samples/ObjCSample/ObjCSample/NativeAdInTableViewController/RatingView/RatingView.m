#import "RatingView.h"

@interface RatingView()

@end

@implementation RatingView

- (id)initWithFrame:(CGRect)frame andRating:(float)rating 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
        CALayer* background = [CALayer layer];
        background.contents = (__bridge id)([UIImage imageNamed:@"5starsgray"].CGImage);
        background.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self.layer addSublayer:background];
        
        CALayer* tintLayer = [CALayer layer];
        tintLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        [tintLayer setBackgroundColor:[UIColor yellowColor].CGColor];
        
        [self.layer addSublayer:tintLayer];
        CALayer* mask = [CALayer layer];
        mask.contents = (__bridge id)([UIImage imageNamed:@"5starsgray"].CGImage);
        mask.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self.layer addSublayer:mask];
        tintLayer.mask = mask;
        
        [tintLayer setBackgroundColor:[UIColor yellowColor].CGColor];
        float width = (rating/5.0f) *  (self.bounds.size.width);
        tintLayer.frame = CGRectMake(0, 0, width, self.frame.size.height);
    }
    return self;
}




@end
