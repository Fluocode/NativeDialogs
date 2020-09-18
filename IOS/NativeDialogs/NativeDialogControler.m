//
//  NativeDialogDelegate.m
//  NativeDialogs
//
//  Created by Mateusz Mackowiak on 02.02.2013.
//
//

#import "NativeDialogControler.h"
#import "NativeListDelegate.h"
#import "AlertTextView.h"


#define nativeDialog_opened (const uint8_t*)"nativeDialog_opened"
#define nativeDialog_closed (const uint8_t*)"nativeDialog_closed"
#define nativeDialog_canceled (const uint8_t*)"nativeDialog_canceled"
#define nativeListDialog_change (const uint8_t *)"nativeListDialog_change"

#define error (const uint8_t*)"error"

@interface ListItem : NSObject
@property( nonatomic, retain ) NSString *text;
@property( nonatomic ) uint32_t selected;
@end


@implementation ListItem

@synthesize text;
@synthesize selected;


+(id)listItemWithText:(NSString*)text{
    return [[[self alloc] initWithText:text] autorelease];
}
- (id)initWithText:(NSString*)_text
{
    self = [super init];
    if (self) {
        self.text = _text;
        self.selected = NO;
    }
    return self;
}
-(NSString *) description {
    return [NSString stringWithFormat:@"ListItem: text: %@ selected: %@",text,(selected ? @"YES":@"NO")];
}
-(void)dealloc{

    [super dealloc];
}

@end




@implementation NativeDialogControler


@synthesize tableItemList;
@synthesize alert;
@synthesize sbAlert;
@synthesize progressView;
@synthesize tsalertView;
@synthesize actionSheet;
@synthesize freContext;

#pragma mark - Alert

- (id)init
{
    self = [super init];
    if (self) {
        freContext = nil;
        tableItemList =nil;
        alert = nil;
        sbAlert = nil;
        tsalertView = nil;
        progressView = nil;
        popover = nil;
        popview = nil;
        actionSheet = nil;
        delegate = nil;
        picker = nil;
        cancelable = NO;
        datePicker = nil;
    }
    return self;
}

#pragma mark - Utilities

-(float)getStatusBarHeight{
    float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    return statusBarHeight;
}

-(BOOL)isDarkMode{
    BOOL iOS_13andUp = [[[UIDevice currentDevice] systemVersion] floatValue]>=13.0;
    if (iOS_13andUp) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunguarded-availability-new"
      if([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark){
            return YES;
        }
    #pragma clang diagnostic pop
        
    }
    return NO;
}

-(void)statusBarStyleLight:(BOOL)light{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if(light){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        if ([self isDarkMode]){
            #pragma clang diagnostic ignored "-Wunguarded-availability-new"
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
        }
    }
}

/*
-(float)statusBarColor{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIStatusBarStyleDefault

    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];

    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {

        statusBar.backgroundColor = [UIColor whiteColor];//set whatever color you like
    }
    
    BOOL iOS_13andUp = [[[UIDevice currentDevice] systemVersion] floatValue]>=13.0;
    if (iOS_13andUp) {
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        
        let statusbarView = UIView()
        statusbarView.backgroundColor = UIColor.red
        view.addSubview(statusbarView)
      
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor
            .constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor
            .constraint(equalTo: view.topAnchor).isActive = true
        statusbarView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor).isActive = true
      
    } else {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.red
    }
     
}*/

-(void)showAlertWithTitle: (NSString *)title
                  message: (NSString*)message
                andButtons:(FREObject *)buttons{
    
    
    //(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex
    NSLog(@"Show Alert");
    
    //BOOL iOS_7andDown = [[[UIDevice currentDevice] systemVersion] floatValue]<=8.0;
    //if (iOS_7andDown) {
    NSLog(@"Show Alert0000");
    [self dismissWithButtonIndex:0];
    NSLog(@"Show Alert11111");
    //}
    
    NSString* closeLabel=nil;
    
    uint32_t buttons_len;
    
    NSLog(@"Show Alert0");
    FREGetArrayLength(buttons, &buttons_len);

    NSLog(@"Show Alert1");
    
    if(buttons_len>0){
        FREObject button0;
        FREGetArrayElementAt(buttons, 0, &button0);
        
        uint32_t button0LabelLength;
        const uint8_t *button0Label;
        FREGetObjectAsUTF8(button0, &button0LabelLength, &button0Label);
        
        closeLabel = [NSString stringWithUTF8String:(char*)button0Label];
    }else{
        closeLabel = NSLocalizedString(@"OK", nil);
    }

    NSLog(@"Show Alert2");
    
    //alert = [[UIAlertController alloc] initWithTitle:title
      //                                     message:message
        //                                  delegate:self
          //                       cancelButtonTitle:closeLabel
            //                 otherButtonTitles:nil];
    
    NSLog(@"on creating 0 Alert");
    
    alert = [UIAlertController alertControllerWithTitle:title
    message:message
    preferredStyle:UIAlertControllerStyleAlert];
    
    NSLog(@"on creating 1 Alert");
    UIAlertAction * closeButton = [UIAlertAction actionWithTitle:closeLabel style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    }];
    
    NSLog(@"on creating 2 Alert");
    [alert addAction:closeButton];
    
    NSLog(@"on creating 3 Alert");
    
    [ [[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"on creating 4 Alert");

    if(buttons_len>1){

        NSLog(@"on creating 5 Alert");
        FREObject button1;
        FREGetArrayElementAt(buttons, 1, &button1);
        
        uint32_t button1LabelLength;
        const uint8_t *button1Label;
        FREGetObjectAsUTF8(button1, &button1LabelLength, &button1Label);
        NSString* otherButtonLabel=[NSString stringWithUTF8String:(char*)button1Label];
        
        if(otherButtonLabel!=nil && ![otherButtonLabel isEqualToString:@""]){
            //[alert addButtonWithTitle:otherButton];
            UIAlertAction * otherButton = [UIAlertAction actionWithTitle:otherButtonLabel style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            [alert addAction:otherButton];
            
        }

    }

    NSLog(@"on creating 6 Alert");
    dispatch_async(dispatch_get_main_queue(), ^{
        //[alert show];
        NSLog(@"on Show Alert");
        //[alert presentViewController:alert animated:YES completion:nil];
    });
    

    FREDispatchStatusEventAsync(freContext, nativeDialog_opened, (uint8_t*)"-1");
  

}

-(void)showAlertWithTitle: (NSString *)title
                  message: (NSString*)message
               closeLabel: (NSString*)closeLabel
              otherLabels: (NSString*)otherLabels
{


   [self dismissWithButtonIndex:0];
    
    //Create our alert.
    //alert = [[UIAlertView alloc] initWithTitle:title
      //                                  message:message
        //                               delegate:self
          //                    cancelButtonTitle:closeLabel
            //                  otherButtonTitles:nil];
    
    alert = [UIAlertController alertControllerWithTitle:title
    message:message
    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * closeButton = [UIAlertAction actionWithTitle:closeLabel style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    }];
    [alert addAction:closeButton];
    
    
    if (otherLabels && ![otherLabels isEqualToString:@""]) {
        //Split our labels into an array
        NSArray *labels = [otherLabels componentsSeparatedByString:@","];
        
        //Add each label to our array.
        for (NSString *label in labels)
        {
            if(label && ![label isEqual:@""]){
                //[alert addButtonWithTitle:label];
                UIAlertAction * otherOtherButton = [UIAlertAction actionWithTitle:label style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                }];
                [alert addAction:otherOtherButton];
            }
        }
    }
    
    [alert presentViewController:alert animated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
         //[alert show];
        
    });
    

    FREDispatchStatusEventAsync(freContext, nativeDialog_opened, (uint8_t*)"-1");

}






#pragma mark - Toolbar and Pickers Utilities
UIView* blackBG;
UIToolbar* toolbar;
UIView* viewToPresentCurrent;

-(void)presentView:(UIView*)viewToPresent withToolBarItems:(FREObject *)toolbarItems andTitle:(NSString*)title{

    NSLog(@"presentView ::: 0" );
    viewToPresentCurrent = viewToPresent;
    BOOL iOS_7andUP = [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0;
    if (iOS_7andUP) {
        viewToPresent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    }
    
    BOOL iOS_7andDown = [[[UIDevice currentDevice] systemVersion] floatValue]<=8.0;
    if (iOS_7andDown) {
        [self dismissWithButtonIndex:0];
    }

    NSLog(@"presentView ::: 1" );
    UIViewController *rootWindow = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    NSArray* buttons = [NativeDialogControler arrayOfStringsFormFreArray:toolbarItems];
    
    //check is ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//if(NO)
    {
        NSLog(@"presentView ::: 2" );
        __block UIViewController* popoverContent = [[UIViewController alloc] init];
        __block UIView *popoverView = [[UIView alloc] init];
        //No Animated
        //popoverContent.view.backgroundColor = [UIColor blackColor];
        //[popoverContent.view setAlpha:0.5];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        blackBG = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenRect.size.width,screenRect.size.height)];
        [blackBG setBackgroundColor:[UIColor blackColor]];
        [blackBG setAlpha:0.5];
        [popoverContent.view addSubview:blackBG];
    
        ///No work maybe in MacOS
        NSString *osxMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"];
        if([osxMode isEqual:@"Dark"]){
            viewToPresent.backgroundColor = [UIColor darkGrayColor];
        }
        NSLog(@"%@", osxMode);
        //////
    NSLog(@"presentView ::: 3" );
        BOOL iOS_13andUp = [[[UIDevice currentDevice] systemVersion] floatValue]>=13.0;
        if (iOS_13andUp) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wunguarded-availability-new"
          if([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark){
                viewToPresent.backgroundColor = [UIColor darkGrayColor];
            }
        #pragma clang diagnostic pop
            
        }
        
     NSLog(@"presentView ::: 4" );
        //UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        //popoverController.delegate=self;
        
        //UIAlertController *popoverController = [UIAlertController alertControllerWithTitle:@""
        //message:nil
        //preferredStyle:UIModalPresentationCustom];
        
        popoverContent.modalPresentationStyle = UIModalPresentationCustom;
        
        //UIWindow* wind= [[UIApplication sharedApplication] keyWindow];
        
        dispatch_async(dispatch_get_main_queue(), ^{
   // ****
            //UIToolbar*
            toolbar = [self initToolbar:buttons];
            NSLog(@"presentView ::: 5" );
            [popoverView addSubview:viewToPresent];
            [popoverView addSubview:toolbar];
            
            [popoverContent.view addSubview:popoverView];
            //popoverContent.view = popoverView;

            //[popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
           
            
            CGFloat viewWidth = rootWindow.view.frame.size.width;
            CGFloat viewHeight = rootWindow.view.frame.size.height;
            //CGRect rect = CGRectMake(viewWidth/2, viewHeight/2, 1, 1);
            CGRect rect = CGRectMake(((viewWidth-viewToPresent.frame.size.width)/2), ((viewHeight-viewToPresent.frame.size.height)/2)-20, 320, 264);
            
            popoverView.frame =rect;
           
            //[popoverController presentPopoverFromRect:rect inView:wind permittedArrowDirections:0 animated:YES];
            [ rootWindow presentViewController:popoverContent animated:NO completion:nil];  ///YES
            
            [toolbar sizeToFit];
            [toolbar release];
   
        });
        NSLog(@"presentView ::: 6" );
        popover = popoverContent;
        popview = popoverView;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
    }else{ //Is iPhone
        NSLog(@"presentView ::: 7" );
        //NSLog([[UIDevice currentDevice] systemVersion]);
        BOOL isNotOS_8 = [[[UIDevice currentDevice] systemVersion] floatValue]<8.0;
        if (isNotOS_8) {
            
            NSLog(@"is below iOS8");
            UIActionSheet *aac = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:nil //self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

            NSLog(@"presentView ::: 8" );
            UIWindow* wind= [[UIApplication sharedApplication] keyWindow];
            
            if(!wind){
                NSLog(@"Window is nil");
                FREDispatchStatusEventAsync(freContext, error, (const uint8_t*)"Window is nil");
                return;
            }
            NSLog(@"presentView ::: 9" );
            dispatch_async(dispatch_get_main_queue(), ^{
                UIToolbar* toolbar = [self initToolbar:buttons];
                [aac addSubview:viewToPresent];
                [aac addSubview:toolbar];
                
                [aac showInView:wind.rootViewController.view];
                
                if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                    [aac setBounds:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.height, 370)];
                } else {
                    [aac setBounds:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 464)];
                }
                [viewToPresent sizeToFit];
                
                [toolbar sizeToFit];
                [toolbar release];
                
                
            });
            actionSheet = aac;

        }else{
            NSLog(@"is iOS8 or UP");
            UIView *wind = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
            
            
            
            if(!wind){
                NSLog(@"Window is nil");
                FREDispatchStatusEventAsync(freContext, error, (const uint8_t*)"Window is nil");
                return;
            }
            
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused"
            float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            #pragma clang diagnostic pop

            NSLog(@"ADD BLACK BACKGROUND");
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            ///CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;

            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] applicationFrame].size.width,screenHeight)]; //[[UIView alloc] init];
            blackBG = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] applicationFrame].size.width,screenHeight)];
            [blackBG setBackgroundColor:[UIColor blackColor]];
            [blackBG setAlpha:0.5];
            [containerView addSubview:blackBG];
            NSLog(@"presentView ::: 10" );
            //width to iPhone Landscape
            CGRect frame;
            if(datePicker){
                NSLog(@"presentView ::: 11" );
                frame = datePicker.frame;
                NSLog(@"presentView ::: 11.1" );
                frame.size.width = screenRect.size.width;
                NSLog(@"presentView ::: 11.2" );
                [datePicker setFrame: frame];
                NSLog(@"presentView ::: 11.3" );
            }else{
                NSLog(@"presentView ::: 12" );
                frame = picker.frame;
                NSLog(@"presentView ::: 12.1" );
                frame.size.width = screenRect.size.width;
                NSLog(@"presentView ::: 12.2" );
                [picker setFrame: frame];
                NSLog(@"presentView ::: 12.3" );
            }
            NSLog(@"presentView ::: 13" );
            CGRect viewToPresentRect = viewToPresent.frame;
            viewToPresentRect.origin.y = wind.bounds.size.height - viewToPresentRect.size.height;
            viewToPresent.frame = viewToPresentRect;
// [wind addSubview:viewToPresent];
             
            
            //UIToolbar* toolbar = [self initToolbar:buttons];
            toolbar = [self initToolbar:buttons];
            CGRect toolbarRect = toolbar.frame;
            toolbarRect.origin.y = viewToPresentRect.origin.y - toolbarRect.size.height;
            toolbar.frame = toolbarRect;
// [wind addSubview:toolbar];
             [containerView addSubview:toolbar];
            NSLog(@"presentView ::: 14" );
            /*
            [wind.window.rootViewController presentViewController:pickerHolder animated:YES completion:^{
                [wind setBackgroundColor:[UIColor blackColor]];
                [wind setAlpha:0.5];
            }];
            */
            
             BOOL iOS_13andUp = [[[UIDevice currentDevice] systemVersion] floatValue]>=13.0;
             if (iOS_13andUp) {
             #pragma clang diagnostic push
             #pragma clang diagnostic ignored "-Wunguarded-availability-new"
               if([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark){
                   //[wind setBackgroundColor:[UIColor blackColor]];
                   //[wind setAlpha:0.5];
                   viewToPresent.backgroundColor = [UIColor darkGrayColor];
                 }
             }
             #pragma clang diagnostic pop
             
            
            [containerView addSubview:viewToPresent];
            ///iPhone mode
            ///test
            popview = containerView; //containerView; //wind; //blackBG
            viewToPresentCurrent=viewToPresent;
            NSLog(@"presentView ::: 15" );
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
            
            //////////////////
            //[    [[[[UIApplication sharedApplication] delegate] window] rootViewController].view     addSubview:containerView];
            //[wind addSubview:containerView];
            [wind addSubview:containerView];
        }
        
        
    }
    FREDispatchStatusEventAsync(freContext, nativeDialog_opened, (uint8_t*)"-1");
    
    
    
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
# define BUTTON_ITEM_STYLE UIBarButtonItemStylePlain
#else
# define BUTTON_ITEM_STYLE UIBarButtonItemStyleBordered
#endif

- (UIToolbar *)initToolbar:(NSArray*)buttons
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float screenWidth;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
            screenWidth = MIN(screenSize.width, screenSize.height);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            screenWidth = MAX(screenSize.width, screenSize.height);
            break;
        }
        case UIInterfaceOrientationLandscapeRight: {
            screenWidth = MAX(screenSize.width, screenSize.height);
            break;
        }
        default: {
            screenWidth = MIN(screenSize.width, screenSize.height);
            break;
        }
    }
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    
    NSMutableArray* barItems = [[NSMutableArray alloc]init];

    uint32_t buttons_len = 0;
    if (buttons && buttons.count>0) {
        
        buttons_len = (uint32_t) buttons.count;
        UIBarButtonItem *barButton;
        
        for (int i =1; i<buttons_len; i++) {
            
            barButton = [[UIBarButtonItem alloc] initWithTitle:[buttons objectAtIndex:i] style:BUTTON_ITEM_STYLE target:self action:@selector(actionSheetButtonClicked:)];
            
            [barButton setTag:i];
            [barItems addObject:barButton];
            [barButton release];
            barButton = nil;
        }
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        [flexSpace release];
        flexSpace = nil;
        
        barButton = [[UIBarButtonItem alloc] initWithTitle:[buttons objectAtIndex:0] style:BUTTON_ITEM_STYLE target:self action:@selector(actionSheetButtonClicked:)];
        [barButton setTag:0];
        [barItems addObject:barButton];
        [barButton release];
        barButton = nil;
        
    }else{
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionSheetButtonClicked:)];
        [doneBtn setTag:1];
        
        [barItems addObject:flexSpace];
        [barItems addObject:doneBtn];
        
        [flexSpace release];
        [doneBtn release];
    }
    
    
    [pickerDateToolbar setItems:barItems animated:NO];
    [barItems release];
    barItems = nil;
    return pickerDateToolbar;
}



- (void)actionSheetButtonClicked:(UIBarButtonItem*)sender {
    
    
    NSInteger index = [sender tag];
    NSLog(@"actionSheetButtonClicked");
    if(cancelable && index == 1)
    {
        NSLog(@"actionSheetButtonClicked::::nativeDialog_canceled");
        FREDispatchStatusEventAsync(freContext, nativeDialog_canceled, (const uint8_t *)[[NSString stringWithFormat:@"%ld",(long)index] UTF8String]);
    }
    else
    {
        NSLog(@"actionSheetButtonClicked::::nativeDialog_closed");
        FREDispatchStatusEventAsync(freContext, nativeDialog_closed, (const uint8_t *)[[NSString stringWithFormat:@"%ld",(long)index] UTF8String]);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    
    if(popover){
        //*******E
        NSLog(@"XXXXXXXX :::: 0");
        [popover navigationController].delegate = nil;
        NSLog(@"XXXXXXXX :::: 1");
       NSLog(@"actionSheetButtonClicked");
               
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        //[[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];

        NSLog(@"actionSheetButtonClicked::::nativeDialog_closed POPOVER 1");
        //[popover dismm dismissPopoverAnimated:YES];
        UIViewController *rootWindow = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        NSLog(@"XXXXXXXX :::: 3");
        
        //NO animated
        [rootWindow dismissViewControllerAnimated:NO completion:nil]; //YES
        NSLog(@"XXXXXXXX :::: 4");
        //popview
    }else{
        NSLog(@"actionSheetButtonClicked::::nativeDialog_closed POPOVER 2");
        BOOL isNotOS_8 = [[[UIDevice currentDevice] systemVersion] floatValue]<8.0;
        if (isNotOS_8) {
            NSLog(@"actionSheetButtonClicked::::nativeDialog_closed POPOVER 3");
        // *****    [actionSheet dismissWithClickedButtonIndex:[sender tag] animated:YES];
            [actionSheet autorelease];
            actionSheet = nil;
        }else{
            NSLog(@"actionSheetButtonClicked::::nativeDialog_closed POPOVER 4s");
            [blackBG removeFromSuperview ];
            [toolbar removeFromSuperview];
            [viewToPresentCurrent removeFromSuperview];
            [blackBG autorelease];
            [toolbar autorelease];
            [viewToPresentCurrent autorelease];
            blackBG =nil;
            toolbar =nil;
            picker = nil;
             [popview removeFromSuperview ];
            popview= nil;
            datePicker = nil;
            viewToPresentCurrent=nil;
        }
        NSLog(@"actionSheetButtonClicked::::nativeDialog_closed POPOVER 5");
        
        NSLog(@"XXXXXXXX :::: 555");
    }
      
    
    
    NSLog(@"XXXXXXXX :::: 5");
     
}
#pragma mark pickers rotation

- (void) didRotate:(NSNotification *)notification{
    NSLog(@"didRotate");
    //if([popover isPopoverVisible]){
    //UIViewController
     if (popover.isViewLoaded && popover.view.window) {
    //if (!popview.hidden && popview.window) {
        UIWindow* wind= [[UIApplication sharedApplication] keyWindow];
        NSLog(@"didRotate 0");
        //[popover setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
        CGFloat viewWidth = wind.frame.size.width;
        CGFloat viewHeight = wind.frame.size.height;
        //CGRect rect = CGRectMake(viewWidth/2, viewHeight/2, 1, 1);
        CGRect rect = CGRectMake((viewWidth-popview.frame.size.width)/2, (viewHeight-popview.frame.size.height)/2, 320, 264);
        NSLog(@"didRotate 1");
        popview.frame=rect;
         
         CGRect screenRect = [[UIScreen mainScreen] bounds];
         blackBG.frame = CGRectMake(0,0,screenRect.size.width,screenRect.size.height);
        
         //UIViewController *rootWindow = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        ///[popover presentPopoverFromRect:rect inView:wind permittedArrowDirections:0 animated:YES];
        //[rootWindow presentViewController:popover animated:YES completion:nil];
     }else if(popview){
         ///iPhone mode
         CGRect screenRect = [[UIScreen mainScreen] bounds];
         blackBG.frame = CGRectMake(0,0,screenRect.size.width,screenRect.size.height);
         
         CGRect frame;
         if(picker){
             frame = picker.frame;
             frame.size.width = screenRect.size.width;
             
             //*****
             //picker.frame = CGRectMake(5,70,150,300);
             picker.showsSelectionIndicator = YES;
             
             [picker setFrame: frame];
         }else{
             frame = datePicker.frame;
             frame.size.width = screenRect.size.width;
             [datePicker setFrame: frame];
         }
         
         CGRect viewToPresentRect = viewToPresentCurrent.frame;
         viewToPresentRect.origin.y = screenRect.size.height - viewToPresentRect.size.height;
         viewToPresentCurrent.frame = viewToPresentRect;

         
         [toolbar sizeToFit];
         
         
         CGRect toolbarRect = toolbar.frame;
         toolbarRect.origin.y = viewToPresentRect.origin.y - toolbarRect.size.height;
         toolbar.frame = toolbarRect;
         
         
         //[toolbar release];
     }
}



#pragma mark - Picker
UIPickerView *pickerList;
-(void)showPickerWithOptions:(FREObject*)options
                  andIndexes:(FREObject*)indexes
                   withTitle:(NSString*)title
                  andMessage:(NSString*)message
                  andButtons:(FREObject*)buttons
                    andWidths:(FREObject*)widths{
#ifdef MYDEBUG
    NSLog(@"Show picker with options");
#endif
    @try {
        NSLog(@"****pickerLIST****");
        
        /*
        if(pickerList!=nil){
            NSLog(@"PICKER NO ES NULL");
            if(pickerList.hidden){
                NSLog(@"PICKER ES HIDDEN");
            }else{
                NSLog(@"PICKER NO ES HIDDEN");
                pickerList.hidden = YES;
                return;
            }
         
            //
        }else{
            NSLog(@"PICKER ES NULL");
        }
        */
        
        NSLog(@"PICKER OPTIONS ::::: 00");

        uint32_t options_len;
        if (FREGetArrayLength(options, &options_len) == FRE_OK)
        {
            NSLog(@"PICKER OPTIONS ::::: 0");
            if (options_len==1) {
                NSLog(@"PICKER OPTIONS ::::: 1");
                FREObject singleOptions;
                FREObject index;
                if(FREGetArrayElementAt(options, 0, &singleOptions) == FRE_OK){
                    NSLog(@"PICKER OPTIONS ::::: 2");
                    if (FREGetArrayElementAt(indexes, 0, &index) == FRE_OK) {
                        NSLog(@"PICKER OPTIONS ::::: 3");
                        int32_t checkedEntry =-1;
                        if(FREGetObjectAsInt32(index, &checkedEntry)!=FRE_OK){
                            NSLog(@"PICKER OPTIONS ::::: 4");
                            checkedEntry = -1;
                        }
                        NSLog(@"PICKER OPTIONS ::::: 5");
                        [self showSingleOptionsPickerWithTitle:title message:message options:singleOptions checked:checkedEntry buttons:buttons];
                    }
                }
            }else{
                NSLog(@"PICKER OPTIONS ::::: 6");
//*****
               
                picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0, 0)];
                //picker = [[UIPickerView alloc]init];
                //picker.frame = CGRectMake(0,0,screenRect.size.width,0);
                picker.showsSelectionIndicator = YES;
                
                delegate = [[NativeListDelegate alloc] initWithMultipleOptions:options andWidths:widths target:self action:@selector(selectionChanged:withRow:andComponent:)];
                picker.delegate = delegate;
                
                NSLog(@"PICKER OPTIONS ::::: 7");
                
                uint32_t indexes_len;
                if (FREGetArrayLength(indexes, &indexes_len) == FRE_OK)
                {
                    NSLog(@"PICKER OPTIONS ::::: 8");
                    for(int i=0; i<indexes_len; ++i)
                    {
                        FREObject item;
                        FREResult result = FREGetArrayElementAt(indexes, i, &item);
                        if(result == FRE_OK){
                            int32_t checkedEntry =-1;
                            if(FREGetObjectAsInt32(index, &checkedEntry)==FRE_OK){
                                if(checkedEntry>-1){
                                    [picker selectRow:checkedEntry inComponent:i animated:NO];
                                }
                            }
                            
                        }
                    }
                }
                NSLog(@"PICKER OPTIONS ::::: 9");
                [self presentView:picker withToolBarItems:buttons andTitle:title];
                
            }
            
        }
    }
    @catch (NSException *exception) {
        FREDispatchStatusEventAsync(freContext, error, (const uint8_t *)[[exception reason] UTF8String]);
    }
#ifdef MYDEBUG
    NSLog(@"Show picker with options ended");
#endif
}


-(void)setSelectedRow:(NSInteger)index andSection:(NSInteger)section{
    dispatch_async(dispatch_get_main_queue(), ^{
        [pickerList selectRow:index inComponent:section animated:YES];
    });
}


-(void)showSingleOptionsPickerWithTitle: (NSString*)title
                        message: (NSString*)message
                        options: (FREObject*)options
                        checked: (NSInteger)checked
                        buttons: (FREObject*)buttons{
    @try {
        NSLog(@">>>>> showSingleOptionsPickerWithTitle");
        //picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0, 0)];
        //picker = [[UIPickerView alloc] init];
        //picker.frame = CGRectMake(5,70,150,250);
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0, 0)];
        picker.showsSelectionIndicator = YES;
        delegate = [[NativeListDelegate alloc] initWithOptions:options target:self action:@selector(selectionChanged:withRow:)];
        picker.delegate = delegate;
        
        if(checked>-1){
            //[pickerList selectRow:checked inComponent:0 animated:NO];
            [picker selectRow:checked inComponent:0 animated:NO];
        }
        //[self presentView:pickerList withToolBarItems:buttons andTitle:title];
        [self presentView:picker withToolBarItems:buttons andTitle:title];
        
    }
    @catch (NSException *exception) {
        FREDispatchStatusEventAsync(freContext, error, (const uint8_t *)[[exception reason] UTF8String]);
    }
}



#pragma mark - Date Picker
UIDatePicker *datePicker;
-(void)showDatePickerWithTitle:(NSString *)title
                    andMessage:(NSString *)message
                       andDate:(double *)date
                      andStyle:(const uint8_t*)style
                    andButtons:(FREObject*)buttons
                  andHasMinMax:(bool)hasMinMax
                        andMin:(double *)minDate
                        andMax:(double *)maxDate {
    @try {

        
        datePicker = nil;
       /* if(datePicker!=nil && datePicker.hidden == NO){
            NSLog(@"[AirDatePicker] HIDDING");
            datePicker.hidden = YES;
            return;
        }*/

       // UIApplication *rootView = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

       //UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
//--------------------------------------------------------------------------------------------------------------------
        [self dismissWithButtonIndex:0];
        
        NSLog(@"DATE PICKER0");
        
        //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0, 0)];
        //datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0, 0)];
    
        //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0, 0)];
        datePicker = [[UIDatePicker alloc]init];//Date picker
        //[datePicker setFrame: CGRectMake(0.0, 44.0, 0, 0)]; //CGRectMake(0, 0, 320, 216)];
        [datePicker setFrame: CGRectMake(0, 0, 320, 216)]; //CGRectMake(0, 0, 320, 216)];
    
        [datePicker setDate:[NSDate dateWithTimeIntervalSince1970:*date]];
//  datePicker.hidden = NO;
        
        NSLog(@"DATE PICKER1");
        
        BOOL iOS_7andUP = [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0;
        if (iOS_7andUP) {
            //datePicker.backgroundColor = [UIColor whiteColor];
        }
        
        NSLog(@"DATE PICKER2");
        if(strcmp((const char *)style, (const char *)"time")==0)
        {
            datePicker.datePickerMode = UIDatePickerModeTime;
        }else if(strcmp((const char *)style, (const char *)"date")==0)
        {
            datePicker.datePickerMode = UIDatePickerModeDate;
        }else if(strcmp((const char *)style, (const char *)"dateAndTime")==0)
        {
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        }
         NSLog(@"DATE PICKER hasMinMax if");
        if(hasMinMax && datePicker.datePickerMode != UIDatePickerModeTime)
        {
            NSLog(@"DATE PICKER hasMinMax");
            datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:*minDate];
            datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:*maxDate];
        }
        NSLog(@"DATE PICKER selector");
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSLog(@"DATE PICKER preshow");
        //[self presentView:datePicker withToolBarItems:buttons andTitle:title];
        
    /*
        UIViewController *popoverViewController = [[UIViewController alloc] init];
        popoverViewController.view = datePicker;
        popoverViewController.view.frame = CGRectMake(0, 0, 320, 216);
        //popoverViewController.modalPresentationStyle = UIModalPresentationPopover;
        //popoverViewController.modalPresentationStyle = UIAlertControllerStyleAlert;
    popoverViewController.modalPresentationStyle = UIAlertControllerStyleActionSheet;
    //[popoverViewController viewWillLayoutSubviews];
     popoverViewController.preferredContentSize = CGSizeMake(320, 216);
        popoverViewController.popoverPresentationController.sourceView = [[[[UIApplication sharedApplication] delegate] window] rootViewController].view;
        //popoverViewController.popoverPresentationController.sourceRect = [[[[UIApplication sharedApplication] delegate] window] rootViewController].view.bounds;
    
        [ [[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:popoverViewController animated:YES completion:nil];
    */
    
       [self presentView:datePicker withToolBarItems:buttons andTitle:title];
    
 //   [ [[[[UIApplication sharedApplication] delegate] window] rootViewController] presentView:datePicker withToolBarItems:buttons andTitle:title];
    
    
      //presentView:datePicker withToolBarItems:buttons andTitle:title];
       
    //[[[[[UIApplication sharedApplication] delegate] window] rootViewController].view presentingViewController:datePicker animated:YES completion:nil];
      
        /*
        UIViewController *popoverViewController = [[UIViewController alloc] init];
        popoverViewController.view = datePicker;
        popoverViewController.view.frame = CGRectMake(0, 0, 320, 216);
        popoverViewController.modalPresentationStyle = UIModalPresentationPopover;
        popoverViewController.preferredContentSize = CGSizeMake(320, 216);
        //popoverViewController.popoverPresentationController.sourceView = sender; // source button
        //popoverViewController.popoverPresentationController.sourceRect = sender.bounds; // source button bounds
        //popoverViewController.popoverPresentationController.delegate = self;
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:popoverViewController animated:YES completion:nil];
*/
        NSLog(@"DATE PICKER postshow");
        
     //   [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentView:datePicker withToolBarItems:buttons andTitle:title];
               
       // [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController

    }
    @catch (NSException *exception) {
        FREDispatchStatusEventAsync(freContext, error, (const uint8_t *)[[exception reason] UTF8String]);
    }

}


-(void)dateChanged:(id)sender{
    
    NSDate *date = [sender date];
    NSTimeInterval timeInterval  = [date timeIntervalSince1970];
    
    FREDispatchStatusEventAsync(freContext, (const uint8_t *)"change", (const uint8_t *)[[NSString stringWithFormat:@"%f",timeInterval]UTF8String]);
}

-(void)updateDateWithTimestamp:(double)timeStamp{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    if(actionSheet){
        for (int i = 0; i < [[actionSheet subviews] count]; i++) {
            if ([[actionSheet.subviews objectAtIndex:i] class] == [UIDatePicker class]) {
                UIDatePicker* datepicker = (UIDatePicker*)[actionSheet.subviews objectAtIndex:i];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [datepicker setDate:date animated:YES];
                });
                break;
            }
        }
        
    }else if(popover){
        //UIView* contentView =  [[popover contentViewController] view];
        //UIView* contentView =  [[popover contentViewController] view];
        UIView* contentView =  popover.view;
        for (int i = 0; i < [[contentView subviews] count]; i++) {
            if ([[contentView.subviews objectAtIndex:i] class] == [UIDatePicker class]) {
                UIDatePicker* datepicker = (UIDatePicker*)[contentView.subviews objectAtIndex:i];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [datepicker setDate:date animated:YES];
                });
                break;
            }
        }
    }
    
    
}


#pragma mark - UIPopoverControllerDelegate

//- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
- (BOOL) popoverControllerShouldDismissPopover:(UIAlertController *)popoverController
{
    FREDispatchStatusEventAsync(freContext, (const uint8_t *)"nativeDialog_pressedOutside", (const uint8_t *)"-1");
    //return NO;
    
    return cancelable;
}

-(void)popoverControllerDidDismissPopover:(UIAlertController *)popoverController{
//-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    
    FREDispatchStatusEventAsync(freContext, nativeDialog_canceled, (const uint8_t *)"-1");
    [popover autorelease];
    popover = nil;
    datePicker = nil;
}


#pragma mark - Progress Dialog
-(void)showProgressPopup: (NSString *)title
                   style: (int32_t)style
                 message: (NSString*)message
                progress: (NSNumber*)progress
            showActivity:(Boolean)showActivity
               cancleble:(Boolean)cancleble{
    BOOL isIOS_7 = [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0;
    if (isIOS_7) {
        tsalertView = [[TSAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:nil];
        
    }else{
        //alert = [[UIAlertView alloc] initWithTitle:title
        //alert = [[UIAlertController alloc] initWithTitle:title
          //                                       message:message
            //                                    delegate:self
              //                         cancelButtonTitle:nil
                //                       otherButtonTitles:nil];
        
       alert = [UIAlertController
        alertControllerWithTitle:title
                         message:message
                  preferredStyle:UIAlertControllerStyleAlert];
    }
    
    //alphas
    alert.view.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
    
    if (style== 0 || showActivity) {
        
        UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityWheel.frame = CGRectMake(142.0f-activityWheel.bounds.size.width*.5, 80.0f, activityWheel.bounds.size.width, activityWheel.bounds.size.height);
        
        if (alert) {
            // [alert addSubview:activityWheel];
            [alert.view addSubview:activityWheel];
        }else{
            [tsalertView setCustomSubview:activityWheel];
        }
        [activityWheel startAnimating];
        [activityWheel release];
        
    } else {
        
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 90.0f, 225.0f, 90.0f)];
        if (alert) {
            //[alert addSubview:progressView];
            [alert.view addSubview:progressView];
        }else{
            [tsalertView setCustomSubview:progressView];
            BOOL iOS_7andUP = [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0;
            if (iOS_7andUP) {
                tsalertView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            }
            BOOL iOS_13andUp = [[[UIDevice currentDevice] systemVersion] floatValue]>=13.0;
            if (iOS_13andUp) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunguarded-availability-new"
              if([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark){
                    tsalertView.backgroundColor = [UIColor darkGrayColor];
                    [tsalertView setAlpha:0.9];
                }
            }
            #pragma clang diagnostic pop
        }
        [progressView setProgressViewStyle: UIProgressViewStyleBar];
        progressView.progress=[progress floatValue];
    }
    [tsalertView setDelegate:self];
       
    if ([NSThread isMainThread]) {
        //[alert show];
        [tsalertView show];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //[alert show];
            //[ [[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
            [tsalertView show];
        });
    }

    FREDispatchStatusEventAsync(freContext, nativeDialog_opened, (uint8_t*)"-1");
}


-(void)updateProgress: (CGFloat)perc
{
    [self performSelectorOnMainThread: @selector(updateProgressBar:)
                           withObject: [NSNumber numberWithFloat:perc] waitUntilDone:NO];

}


- (void) updateProgressBar:(NSNumber*)num {
    
    if(progressView)
        progressView.progress=[num floatValue];
}

#pragma mark - Text Input Dialog



-(void)textFieldDidChange:(id)sender {
    // whatever you wanted to do
    int8_t index = 0;
    //if(sender != [alert textFieldAtIndex:0])
    if(sender != [alert textFields][0])
        index =1;
    NSString* returnString = [NSString stringWithFormat:@"%i#_#%@",index,((UITextField *)sender).text];
    
    FREDispatchStatusEventAsync(freContext, (uint8_t*)"change", (uint8_t*)[returnString UTF8String]);
    // [returnString release];
}



-(void)textFieldDidPressReturn:(id)sender
{
    int8_t index = 0;
    [sender resignFirstResponder];
    
    //if(sender != [alert textFieldAtIndex:0])
    if(sender != [alert textFields][0])
        index =1;
    NSString* returnString = [NSString stringWithFormat:@"%i",index];
    
    FREDispatchStatusEventAsync(freContext, (uint8_t*)"returnPressed", (uint8_t*)[returnString UTF8String]);
}



UIReturnKeyType getReturnKeyTypeFormChar(const char* type){
    if(strcmp(type, "done")==0){
        return UIReturnKeyDone;
    }else if(strcmp(type, "go")==0){
        return UIReturnKeyGo;
    }else if(strcmp(type, "next")==0){
        return UIReturnKeyNext;
    }else if(strcmp(type, "search")==0){
        return UIReturnKeySearch;
    }else {
        return UIReturnKeyDefault;
    }
}



UIKeyboardType getKeyboardTypeFormChar(const char* type){
    if(strcmp(type, "punctuation")==0){
        return UIKeyboardTypeNumbersAndPunctuation;
    }else if(strcmp(type, "url")==0){
        return UIKeyboardTypeURL;
    }else if(strcmp(type, "number")==0){
        return UIKeyboardTypeNumberPad;
    }else if(strcmp(type, "contact")==0){
        return UIKeyboardTypePhonePad;
    }else if(strcmp(type, "email")==0){
        return UIKeyboardTypeEmailAddress;
    }else {
        return UIKeyboardTypeDefault;
    }
}

UITextAutocorrectionType getAutocapitalizationTypeFormChar(const char* type){
    
    if(strcmp(type, "word")==0){
        return UITextAutocapitalizationTypeWords;
    }else if(strcmp(type, "sentence")==0){
        return UITextAutocapitalizationTypeSentences;
    }else if(strcmp(type, "all")==0){
        return UITextAutocapitalizationTypeAllCharacters;
    }else {
        return UITextAutocorrectionTypeNo;
    }
}


-(void)setupTextInput:(UITextField*) textfiel
        withParamsFormFREOBJ: (FREObject) obj{
    
    FREObject returnKeyObj,autocapitalizationTypeObj, keyboardTypeObj,prompTextObj,textObj, autoCorrectObj,displayAsPasswordObj;
    
    FREGetObjectProperty(obj, (const uint8_t *)"returnKeyLabel", &returnKeyObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"softKeyboardType", &keyboardTypeObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"autoCapitalize", &autocapitalizationTypeObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"prompText", &prompTextObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"text", &textObj, NULL);
    
    FREGetObjectProperty(obj, (const uint8_t *)"autoCorrect", &autoCorrectObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"displayAsPassword", &displayAsPasswordObj, NULL);
    
    uint32_t returnKeyTypeLength , autocapitalizationTypeLength , keyboardTypeLength, prompTextLength , textLength , autoCorrect,displayAsPassword;
    const uint8_t* returnKeyType;
    const uint8_t* autocapitalizationType;
    const uint8_t* keyboardType;
    const uint8_t* prompText;
    const uint8_t* text;
    
    FREGetObjectAsUTF8(autocapitalizationTypeObj, &autocapitalizationTypeLength, &autocapitalizationType);
    FREGetObjectAsUTF8(returnKeyObj, &returnKeyTypeLength, &returnKeyType);
    FREGetObjectAsUTF8(keyboardTypeObj, &keyboardTypeLength, &keyboardType);
    FREGetObjectAsUTF8(textObj, &textLength, &text);
    FREGetObjectAsUTF8(prompTextObj, &prompTextLength, &prompText);
    
    FREGetObjectAsBool(autoCorrectObj, &autoCorrect);
    FREGetObjectAsBool(displayAsPasswordObj, &displayAsPassword);
    
    if(displayAsPassword)
        textfiel.secureTextEntry = YES;
    else
        textfiel.secureTextEntry = NO;
    
    if(autoCorrect)
        textfiel.autocorrectionType = UITextAutocorrectionTypeYes;
    else
        textfiel.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [textfiel setText:[NSString stringWithUTF8String:(const char *)text]];
    [textfiel setPlaceholder:[NSString stringWithUTF8String:(const char *)prompText]];
    
    textfiel.keyboardType = getKeyboardTypeFormChar((const char *)keyboardType);
    textfiel.autocapitalizationType = getAutocapitalizationTypeFormChar((const char *)autocapitalizationType);
    textfiel.returnKeyType = getReturnKeyTypeFormChar((const char *)returnKeyType);
}

-(void)showTextInputDialog: (NSString *)title
                   message: (NSString*)message
                textInputs: (FREObject*)textInputs
                   buttons: (FREObject*)buttons
{
    [self dismissWithButtonIndex:0];
    
    NSString* closeLabel=nil;
    
    uint32_t buttons_len;
    FREGetArrayLength(buttons, &buttons_len);
    
    if(buttons_len>0){
        FREObject button0;
        FREGetArrayElementAt(buttons, 0, &button0);
        
        uint32_t button0LabelLength;
        const uint8_t *button0Label;
        FREGetObjectAsUTF8(button0, &button0LabelLength, &button0Label);
        
        closeLabel = [NSString stringWithUTF8String:(char*)button0Label];
    }else{
        closeLabel = NSLocalizedString(@"OK", nil);
    }
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused"
        BOOL isIOS_5 = [[[UIDevice currentDevice] systemVersion] floatValue]>=5.0;
    #pragma clang diagnostic pop
        
        

    
    //Create our alert.
    /*
    if( isIOS_5){
        alert = [[UIAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:self
                                       cancelButtonTitle:closeLabel
                                       otherButtonTitles:nil];
    }else{
        alert = [[AlertTextView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:closeLabel
                                         otherButtonTitles:nil];
    }
    */
    
    alert = [UIAlertController alertControllerWithTitle:title
       message:message
       preferredStyle:UIAlertControllerStyleAlert];
       
    UIAlertAction * closeButton = [UIAlertAction actionWithTitle:closeLabel style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
       }];
    [alert addAction:closeButton];
    
    if(buttons_len>1){
        FREObject button1;
        FREGetArrayElementAt(buttons, 1, &button1);
        
        uint32_t button1LabelLength;
        const uint8_t *button1Label;
        FREGetObjectAsUTF8(button1, &button1LabelLength, &button1Label);
        NSString* otherButton=[NSString stringWithUTF8String:(char*)button1Label];
        
        if(otherButton!=nil && ![otherButton isEqualToString:@""]){
            //[alert addButtonWithTitle:otherButton];
            UIAlertAction * otherBtn = [UIAlertAction actionWithTitle:otherButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                  }];
            [alert addAction:otherBtn];
                        
        }
    }
    
    uint32_t textInputs_len;
    FREGetArrayLength(textInputs, &textInputs_len);
    
    int8_t index =0;
    if(message!=nil && ![message isEqualToString:@""])
        index++;
    
    if (textInputs_len > index) {
        //UITextField *textField=nil;
        //FREObject textObj;
        
        if(textInputs_len==(index+1)){
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                FREObject textObj;
               /* textField.placeholder = @"password";
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.secureTextEntry = YES;
                */
                ///
                [textField addTarget:self action:@selector(textFieldDidPressReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
                [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                FREGetArrayElementAt(textInputs, index, &textObj);
                [self setupTextInput:textField withParamsFormFREOBJ:textObj];
                ///
            }];
            
        }else if(textInputs_len > (index+1)){
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                FREObject textObj;
                /*textField.placeholder = @"password";
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.secureTextEntry = YES;
                 */
                ///
                [self setupTextInput:textField withParamsFormFREOBJ:textObj];
                //textField = [alert textFieldAtIndex:1];
                [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
                FREGetArrayElementAt(textInputs, index+1, &textObj);
                [self setupTextInput:textField withParamsFormFREOBJ:textObj];
                ///
            }];
        }
        
        /*
        if(textInputs_len==(index+1)){
            if(isIOS_5)
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            else
                [alert setAlertViewStyle:AlertTextViewStylePlainTextInput];
            textField = [alert textFieldAtIndex:0];
            
            [textField addTarget:self action:@selector(textFieldDidPressReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            FREGetArrayElementAt(textInputs, index, &textObj);
            [self setupTextInput:textField withParamsFormFREOBJ:textObj];
            
        }else if(textInputs_len > (index+1)){
            if(isIOS_5)
                [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            else
                [alert setAlertViewStyle:AlertTextViewStyleLoginAndPasswordInput];
            
            textField = [alert textFieldAtIndex:0];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            FREGetArrayElementAt(textInputs, index, &textObj);
            [self setupTextInput:textField withParamsFormFREOBJ:textObj];
            textField = [alert textFieldAtIndex:1];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
            FREGetArrayElementAt(textInputs, index+1, &textObj);
            [self setupTextInput:textField withParamsFormFREOBJ:textObj];
        }
         */
        
    }
    
    UIViewController *rootWindow = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootWindow presentViewController:alert animated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // [alert show];
       
    });
    
    FREDispatchStatusEventAsync(freContext, nativeDialog_opened, (uint8_t*)"-1");
}


#pragma mark - ListDialog

-(void)selectionChanged:(id)sender
                withRow:(NSInteger)row{
    FREDispatchStatusEventAsync(freContext, nativeListDialog_change, (const uint8_t *)[[NSString stringWithFormat:@"%lD",(long)row] UTF8String]);
}
-(void)selectionChanged:(id)sender
                withRow:(NSInteger)row
           andComponent:(NSInteger)component{
    FREDispatchStatusEventAsync(freContext, nativeListDialog_change, (const uint8_t *)[[NSString stringWithFormat:@"%lD_%lD",(long)component,(long)row] UTF8String]);
}

-(void)showSelectDialogWithTitle: (NSString*)title
                         message: (NSString*)message
                            type: (uint32_t)displayType
                         options: (FREObject*)options
                         checked: (FREObject*)checked
                         buttons: (FREObject*)buttons{
    
    FREObjectType type;
    
    
    if(displayType == 6)
    {
        uint32_t checkedEntry =-1;
        if(FREGetObjectAsUint32(checked, &checkedEntry)!=FRE_OK){
            checkedEntry = -1;
        }

        [self showSingleOptionsPickerWithTitle:title message:message options:options checked:checkedEntry buttons:buttons];
    }
    else
    {
        
        NSString* closeLabel=nil;
        NSString* otherLabel=nil;
        
        uint32_t buttons_len;
        if(buttons && FREGetArrayLength(buttons, &buttons_len)==FRE_OK){
            if(buttons_len>0){
                FREObject button;
                FREGetArrayElementAt(buttons, 0, &button);
                
                uint32_t buttonLabelLength;
                const uint8_t *buttonLabel;
                if(button){
                    FREGetObjectAsUTF8(button, &buttonLabelLength, &buttonLabel);
                    closeLabel = [NSString stringWithUTF8String:(char*)buttonLabel];
                }
                if(buttons_len>1){
                    FREObject button1;
                    FREGetArrayElementAt(buttons, 1, &button1);
                    if(button1){
                        FREGetObjectAsUTF8(button1, &buttonLabelLength, &buttonLabel);
                        otherLabel = [NSString stringWithUTF8String:(char*)buttonLabel];
                    }
                }
            }
        }
        if(!closeLabel || [closeLabel isEqualToString:@""]){
            closeLabel = [NSLocalizedString(@"Done", nil) autorelease];
        }
        
        
        //Create our alert.
        sbAlert = [[SBTableAlert alloc] initWithTitle:title cancelButtonTitle:closeLabel messageFormat: message];
        [sbAlert setDataSource:self];
        [sbAlert setDelegate:self];
        
        BOOL iOS_7andUP = [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0;
        if (iOS_7andUP) {
            //[sbAlert.view setBackgroundColor:[UIColor whiteColor]];
            sbAlert.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            
            BOOL iOS_13andUp = [[[UIDevice currentDevice] systemVersion] floatValue]>=13.0;
            if (iOS_13andUp) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunguarded-availability-new"
              if([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark){
                  sbAlert.view.backgroundColor = [UIColor darkGrayColor];
                }
            }
            #pragma clang diagnostic pop
        }
        
        if(otherLabel && ![otherLabel isEqualToString:@""])
        {
            [sbAlert.view addButtonWithTitle:otherLabel ];
        }
        
        uint32_t options_len; // array length
        if(options && FREGetArrayLength(options, &options_len)==FRE_OK){
            
            FREObject element;
            
            for(int32_t i=0; i<options_len;++i){
                
                // get an element at index
                if(FREGetArrayElementAt(options, i, &element)==FRE_OK){
                    if(element){
                        uint32_t elementLength;
                        const uint8_t *elementLabel;
                        if(FREGetObjectAsUTF8(element, &elementLength, &elementLabel)==FRE_OK){
                            ListItem* item = [ListItem listItemWithText:[NSString stringWithUTF8String:(char*)elementLabel]] ;
                            
                            if(!tableItemList)
                                tableItemList= [[NSMutableArray alloc] init];
                            [tableItemList addObject:item];
                        }
                    }
                }
            }
            
            // options
            if(checked){
                FREGetObjectType(checked, &type);
                if(type == FRE_TYPE_NUMBER){
                    
                    int32_t checkedValue;
                    FREGetObjectAsInt32(checked, &checkedValue);
                    
                    if(checkedValue>=0 || checkedValue< options_len){
                        ListItem* item = [tableItemList objectAtIndex:checkedValue];
                        if(item){
                            item.selected = YES;
                        }
                    }
                    [sbAlert setType:SBTableAlertTypeSingleSelect];
                    [sbAlert setStyle:SBTableAlertStyleApple];
                    
                    [self showList];
                    
                }else if(type ==FRE_TYPE_VECTOR || type ==FRE_TYPE_ARRAY){
                    [sbAlert setType:SBTableAlertTypeMultipleSelct];
                    
                    uint32_t checkedItems_len; // array length
                    FREGetArrayLength(checked, &checkedItems_len);
                    if(tableItemList && checkedItems_len == options_len){
                        for(int32_t i=checkedItems_len-1; i>=0;i--){
                            // get an element at index
                            FREObject checkedListItem;
                            FREGetArrayElementAt(checked, i, &checkedListItem);
                            if(checkedListItem){
                                uint32_t boolean;
                                if(FREGetObjectAsBool(checkedListItem, &boolean)==FRE_OK){
                                    ListItem* item = [tableItemList objectAtIndex:i];
                                    if(item){
                                        item.selected = boolean;
                                    }
                                }
                            }
                        }
                    }
                    
                    [self showList];
                    
                }
            }else{
                [sbAlert setType:SBTableAlertTypeMultipleSelct];
                [self showList];
            }
        }
    }
}


-(void)showList{
    
    if ([NSThread isMainThread]) {
        [sbAlert show];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [sbAlert show];
        });
    }
    FREDispatchStatusEventAsync(freContext, nativeDialog_opened, (uint8_t*)"-1");
}


#pragma mark - SBTableAlertDataSource

//*****

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SBTableAlertCell *cell = [[SBTableAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    
    if(tableItemList){
        ListItem* item = [tableItemList objectAtIndex:indexPath.row];
        [cell.textLabel setText: [NSString stringWithString:item.text]];
        if(item.selected)
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
  
    return [cell autorelease];
}


- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section{
    if(tableItemList)
        return [tableItemList count];
    else
        return 0;
}





#pragma mark - SBTableAlertDelegate


- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *returnString =nil;
    if (tableAlert.type == SBTableAlertTypeMultipleSelct) {
        UITableViewCell *cell = [tableAlert.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryNone){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            returnString = [NSString stringWithFormat:@"%ld_true",(long)[indexPath row]];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            returnString = [NSString stringWithFormat:@"%ld_false",(long)[indexPath row]];
        }
        [tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else
        returnString = [NSString stringWithFormat:@"%ld", (long)[indexPath row]];
    
    FREDispatchStatusEventAsync(freContext, nativeListDialog_change, (uint8_t*)[returnString UTF8String]);
     
}




- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex{

    NSString *buttonID = [NSString stringWithFormat:@"%ld", (long)buttonIndex];
    if(cancelable && buttonIndex == 1)
    {
        FREDispatchStatusEventAsync(freContext, nativeDialog_canceled, (uint8_t*)[buttonID UTF8String]);
    }else{
        FREDispatchStatusEventAsync(freContext, nativeDialog_closed, (uint8_t*)[buttonID UTF8String]);
    }
    
    //Cleanup references.
    
    [tableItemList release];
    tableItemList = nil;
    [sbAlert release];
    sbAlert = nil;
    

}









#pragma mark - All

-(void)setCancelable:(uint32_t)can{
    cancelable = can;
}
-(void)dismissWithButtonIndex:(int32_t)index{
    
    @try {
        //No animated
        BOOL isIOS_8 = [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0;
        if( isIOS_8 ) {
            //[popover dismissPopoverAnimated:NO];
            [popover dismissViewControllerAnimated:NO completion:nil];
            //[actionSheet dismissWithClickedButtonIndex:index animated:NO];
            [alert dismissViewControllerAnimated:NO completion:nil];
            //[alert dismissWithClickedButtonIndex:index animated:NO];
            [tsalertView dismissWithClickedButtonIndex:index animated:NO];
            [sbAlert.view dismissWithClickedButtonIndex:index animated:NO];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[popover dismissPopoverAnimated:YES];
                [popover dismissViewControllerAnimated:YES completion:nil];   //YES
                //[actionSheet dismissWithClickedButtonIndex:index animated:YES];
                [alert dismissViewControllerAnimated:YES completion:nil];   //YES
                //[alert dismissWithClickedButtonIndex:index animated:YES];
                [tsalertView dismissWithClickedButtonIndex:index animated:YES];
                [sbAlert.view dismissWithClickedButtonIndex:index animated:YES];
            });
        }
        
        
    }
    @catch (NSException *exception) {
        FREDispatchStatusEventAsync(freContext, error, (const uint8_t *)[[exception reason] UTF8String]);
    }

}

-(UIView*)getView{
    NSLog(@"Getting View");
    UIView *u = nil;
    if(popover ){
        //u = popover.contentViewController.view;
        u = popover.view;
   // }else if(alert && alert.isHidden==NO){
    }else if(alert && alert.view.isHidden==NO){
        u = alert.view;
    }
    else if(tsalertView){
        u = tsalertView;
    }
    else if(sbAlert && sbAlert.view.isHidden==NO){
        u = sbAlert.view;
    }
    NSLog(@"Got View %@",u);
    return u;
}

-(void)shake{
    #ifdef MYDEBUG
        NSLog(@"shake");
#endif
    UIView* u= [self getView];
    if(u){
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect r = u.frame;
        oldX = r.origin.x;
        r.origin.x = r.origin.x - r.origin.x * 0.1;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.1f];
        [UIView setAnimationRepeatCount:5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
        [UIView setAnimationRepeatAutoreverses:NO];
        [u setFrame:r];
        
        [UIView commitAnimations];
    });
    }
}
-(void)animationFinished:(NSString*)animationID{
    
    UIView* u= [self getView];
    CGRect r = u.frame;
    r.origin.x = oldX;
    [u setFrame:r];
    
#ifdef MYDEBUG
    NSLog(@"Finished shake");
#endif
}

-(void)updateMessage:(NSString*)message
{
    #ifdef MYDEBUG
        NSLog(@"updateMessage to %@",message);
    #endif
    
    [self performSelectorOnMainThread: @selector(updateMessageWithSt:)
                           withObject: message waitUntilDone:NO];
}
- (void) updateMessageWithSt:(NSString*)message {
    if(sbAlert){
        sbAlert.view.message = message;
    }else if(tsalertView){
        tsalertView.message = message;
    }
    else if(alert){
        alert.message = message;
    }
}
-(void)updateTitle:(NSString*)title{
    #ifdef MYDEBUG
        NSLog(@"updateTitle to %@",title);
    #endif
    
    [self performSelectorOnMainThread: @selector(updateTitleWithSt:)
                           withObject: title waitUntilDone:NO];
    
}
- (void) updateTitleWithSt:(NSString*)title {
    if(sbAlert){
        sbAlert.view.title =title;
    }else if(tsalertView){
        tsalertView.title = title;
    }
    else if(alert){
        [alert setTitle:title];
    }
}

-(BOOL)isShowing{
    #ifdef MYDEBUG
        NSLog(@"isShowing");
    #endif
    if(sbAlert){
        if(sbAlert.view.isHidden==NO){
            return YES;
        }else{
            return NO;
        }
    }
    else if(tsalertView){
        return tsalertView.isVisible;
    }
    else if(alert){
        //return [alert isVisible];
        return [alert presentedViewController];
    }
    return NO;
}






#pragma mark - UIAlertViewDelegate


//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
- (void)alertView:(UIAlertController *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView isKindOfClass:[TSAlertView class]]) {
        
    }else{
        BOOL isIOS_5OrLater = [[[UIDevice currentDevice] systemVersion] floatValue]>=5.0;
        if(isIOS_5OrLater){
            NSLog(@"isIOS_5OrLater");
            
            /*
             NSLog(@"isIOS_5OrLater");
            if([alertView alertViewStyle]!=UIAlertViewStyleDefault && [alertView alertViewStyle]!=AlertTextViewStyleDefault){
                [[alertView textFieldAtIndex:0] resignFirstResponder];
                if([alertView alertViewStyle]==UIAlertViewStyleLoginAndPasswordInput || [alertView alertViewStyle]==AlertTextViewStyleLoginAndPasswordInput){
                    [[alertView textFieldAtIndex:1] resignFirstResponder];
                }
            }
             */
        }
    }
    //Create our params to pass to the event dispatcher.
    NSString *buttonID = [NSString stringWithFormat:@"%ld", (long)buttonIndex];
    
    FREDispatchStatusEventAsync(freContext, nativeDialog_closed, (uint8_t*)[buttonID UTF8String]);
    
    [progressView release];
    progressView = nil;
    
    //Cleanup references.
    [tsalertView release];
    tsalertView = nil;
    
    [alert release];
    alert = nil;

    
    
}


-(void)dealloc{
    
    picker.delegate = nil;
    [picker release];
    
    //
    blackBG = nil;
    [blackBG release];
    viewToPresentCurrent = nil;
    [viewToPresentCurrent release];
    datePicker = nil;
    [datePicker release];
    //
    [tableItemList release];
    [delegate release];
    [popover navigationController].delegate = nil;
    [popview release];
    popview= nil;
    [popover release];
    popview= nil;
    [alert release];
    [actionSheet release];
    [tsalertView release];
    tsalertView = nil;
    [sbAlert release];
    [progressView release];
    
    freContext = nil;
    
    NSLog(@"Controllers dealloc");
    [super dealloc];
    NSLog(@"Controllers dealloc AFTER");
}


#pragma mark - Utilities

+(NSArray*)arrayOfStringsFormFreArray:(FREObject*)objects{
    
    uint32_t stringsLength = 0;
    
    if(FREGetArrayLength(objects, &stringsLength)==FRE_OK && stringsLength>0){
        
        NSMutableArray* strings = [[NSMutableArray alloc]init];
        uint32_t stingLen;
        const uint8_t *label;
        for (int i = 0; i<stringsLength; i++) {
            FREObject newString = nil;
            if(FREGetArrayElementAt(objects, i, &newString)==FRE_OK){
                if(FREGetObjectAsUTF8(newString, &stingLen, &label)==FRE_OK  && label){
                    NSString * s= [NSString stringWithUTF8String:(char*)label];
                    if(s && ![s isEqualToString:@""]){
                        [strings addObject:s];
                    }
                }
            }
        }
        return strings;
    }
    return nil;
}



@end



