//
//  ViewController.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 11.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import "SlideshowViewController.h"
#import "AdService.h"

@interface SlideshowViewController ()

@property(nonatomic, strong) AdService *adService;

@end

@implementation SlideshowViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _adService = [AdService new]; //TODO : Use IoC
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _adService = [AdService new]; //TODO : Use IoC
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _adService = [AdService new]; //TODO : Use IoC
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startSlideshow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startSlideshow {
    NSArray *ads = [_adService getAdsList];
}





@end
