/**
 * @class WToast
 * @author Nik S Dyonin <wolf.step@gmail.com>
 * Small popup message inspired by Android Toast object
 */

#import "WToast.h"
#import <QuartzCore/QuartzCore.h>

#define TABBAR_OFFSET 44.0f

@interface WToast()

@property (nonatomic) NSInteger length;

@end


@implementation WToast

@synthesize length = _length;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame]) != nil) {
		_length = kWTShort;
	}
	return self;
}

- (void)__show {
	[UIView animateWithDuration:0.2f
					 animations:^{
						 self.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {
						 [self performSelector:@selector(__hide) withObject:nil afterDelay:_length];
					 }];
}

- (void)__hide {
	[UIView animateWithDuration:0.8f
					 animations:^{
						 self.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [self removeFromSuperview];
#if !__has_feature(objc_arc)
						 [self release];
#endif
						 
					 }];
}

+ (WToast *)__createWithText:(NSString *)text {
	float screenWidth, screenHeight;
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	
	
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused"
        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
    #pragma clang diagnostic pop
	

	
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    NSLog(@"Width >>>> %f", screenSize.width);
    NSLog(@"Height >>>> %f", screenSize.height);
	
	
	switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown: {
            NSLog(@"Orient >>>UIInterfaceOrientationPortraitUpsideDown");
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeLeft: {
            NSLog(@"Orient >>>UIInterfaceOrientationLandscapeLeft");
            screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeRight: {
            NSLog(@"Orient >>>UIInterfaceOrientationLandscapeRight");
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        default: {
            NSLog(@"Orient >>>DEFAULT");
            screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
    }
    
    NSLog(@"screenWidth Width >>>> %f", screenWidth);
    NSLog(@"screenHeight Height >>>> %f", screenHeight);
	
	float x = 10.0f;
	float width = screenWidth - x * 2.0f;

	UILabel *textLabel = [[UILabel alloc] init];
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.font = [UIFont systemFontOfSize:14];
	textLabel.textColor = RGB(255, 255, 255);
	textLabel.numberOfLines = 0;
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    //textLabel.lineBreakMode = UILineBreakModeWordWrap;
    //CGSize sz = [text boundingRectWithSize:options:attributes:context:nil:textLabel.font
		//		 constrainedToSize:CGSizeMake(width - 20.0f, 9999.0f)
			//		 lineBreakMode:textLabel.lineBreakMode];
    
    NSLog(@"SZ  >>>> ");
    
    CGRect sz = [text boundingRectWithSize:CGSizeMake(width - 20.0f, 9999.0f)
    options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
    attributes:@{NSFontAttributeName:textLabel.font}
    context:nil];
    
   NSLog(@"tmpRect  >>>> ");
    
	CGRect tmpRect = CGRectZero;
	tmpRect.size.width = width;
    tmpRect.size.height = MAX(sz.size.height + 20.0f, 38.0f);
    
     NSLog(@"WToast  >>>> ");

	WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
	toast.backgroundColor = RGBA(0, 0, 0, 0.8f);
	CALayer *layer = toast.layer;
	layer.masksToBounds = YES;
	layer.cornerRadius = 5.0f;

	textLabel.text = text;
    tmpRect.origin.x = floor((toast.frame.size.width - sz.size.width) / 2.0f);
    tmpRect.origin.y = floor((toast.frame.size.height - sz.size.height) / 2.0f);
    tmpRect.size = sz.size;
	textLabel.frame = tmpRect;
	[toast addSubview:textLabel];
#if !__has_feature(objc_arc)
	[textLabel release];
#endif
	
    NSLog(@"toast  >>>> ");
    
	toast.alpha = 0.0f;

	return toast;
}

+ (WToast *)__createWithImage:(UIImage *)image {
	float screenWidth, screenHeight;
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSLog(@"__createWithImage ORIENTATION");
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown: {
             NSLog(@"UIInterfaceOrientationPortraitUpsideDown ORIENTATION");
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeLeft: {
            NSLog(@"UIInterfaceOrientationLandscapeLeft ORIENTATION");
            screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeRight: {
            NSLog(@"UIInterfaceOrientationLandscapeRight ORIENTATION");
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        default: {
            NSLog(@"default ORIENTATION");
            screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
    }
	
	float x = 10.0f;
	float width = screenWidth - x * 2.0f;

	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	CGSize sz = imageView.frame.size;

	CGRect tmpRect = CGRectZero;
	tmpRect.size.width = width;
	tmpRect.size.height = MAX(sz.height + 20.0f, 38.0f);

	WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
	toast.backgroundColor = RGBA(0, 0, 0, 0.8f);
	CALayer *layer = toast.layer;
	layer.masksToBounds = YES;
	layer.cornerRadius = 5.0f;

	tmpRect.origin.x = floor((toast.frame.size.width - sz.width) / 2.0f);
	tmpRect.origin.y = floor((toast.frame.size.height - sz.height) / 2.0f);
	tmpRect.size = sz;
	imageView.frame = tmpRect;
	[toast addSubview:imageView];
#if !__has_feature(objc_arc)
	[imageView release];
#endif
	
	toast.alpha = 0.0f;
	
	return toast;
}

- (void)__flipViewAccordingToStatusBarOrientation {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat angle = 0.0;
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	float x, y;
	float screenWidth, screenHeight;
    
    BOOL iOS_7andDown = [[[UIDevice currentDevice] systemVersion] floatValue]<7.0;
    
    
    NSLog(@"__flipViewAccordingToStatusBarOrientation");
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            if (iOS_7andDown) {
                angle = M_PI;
                x = floor((screenWidth - self.bounds.size.width) / 2.0f);
                y = 15.0f + TABBAR_OFFSET;
            }
            break;
		}
        case UIInterfaceOrientationLandscapeLeft: {
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            if (iOS_7andDown) {
                angle = - M_PI / 2.0f;
                x = screenHeight - self.bounds.size.height - 15.0f - TABBAR_OFFSET;
                y = floor((screenWidth - self.bounds.size.width) / 2.0f);
            }
            break;
		}
        case UIInterfaceOrientationLandscapeRight: {
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            if (iOS_7andDown) {
                angle = M_PI / 2.0f;
                x = 15.0f + TABBAR_OFFSET;
                y = floor((screenWidth - self.bounds.size.width) / 2.0f);
            }
            break;
		}
        default: {
            NSLog(@"Deault");
            angle = 0.0;
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
			x = floor((screenWidth - self.bounds.size.width) / 2.0f);
			y = screenHeight - self.bounds.size.height - 15.0f - TABBAR_OFFSET;
            break;
		}
          
    }
    
    x = floor((screenWidth - self.bounds.size.width) / 2.0f);
    y = (screenHeight - self.bounds.size.height) - 15.0f - TABBAR_OFFSET;

    self.transform = CGAffineTransformMakeRotation(angle);

	CGRect f = self.frame;
	f.origin = CGPointMake(x, y);
	self.frame = f;
}

/**
 * Show toast with text in application window
 * @param text Text to print in toast window
 */
+ (void)showWithText:(NSString *)text {
	[WToast showWithText:text length:kWTShort];
}

/**
 * Show toast with image in application window
 * @param image Image to show in toast window
 */
+ (void)showWithImage:(UIImage *)image {
	[WToast showWithImage:image length:kWTShort];
}

/**
 * Show toast with text in application window
 * @param text Text to print in toast window
 * @param length Toast visibility duration
 */
+ (void)showWithText:(NSString *)text length:(WToastLength)length {
	WToast *toast = [WToast __createWithText:text];
	toast.length = length;
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	[mainWindow addSubview:toast];
	
	[toast __flipViewAccordingToStatusBarOrientation];
	[toast __show];
}

/**
 * Show toast with image in application window
 * @param image Image to show in toast window
 * @param length Toast visibility duration
 */
+ (void)showWithImage:(UIImage *)image length:(WToastLength)length {
	WToast *toast = [WToast __createWithImage:image];
	toast.length = length;
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	[mainWindow addSubview:toast];
	
	[toast __flipViewAccordingToStatusBarOrientation];
	[toast __show];
}

@end
