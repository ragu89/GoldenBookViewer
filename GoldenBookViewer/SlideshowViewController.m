//
//  ViewController.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 11.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import "SlideshowViewController.h"
#import "AdService.h"
#import "Ad.h"

@interface SlideshowViewController ()

@property(nonatomic, strong) AdService *adService;
@property(nonatomic, strong) NSArray *ads;
@property(atomic, assign) int slideShowPosition;

@end

@implementation SlideshowViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.adService = [AdService new]; //TODO : Use IoC
        self.slideShowPosition = 0;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.adService = [AdService new]; //TODO : Use IoC
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.adService = [AdService new]; //TODO : Use IoC
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.ads = [self.adService getAdsList];
    [self startSlideshow];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopSlideshow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startSlideshow {
    //TODO start the timer
    
    [self showNextAd];
}

- (void)stopSlideshow {
    //TODO: stop the timer
}

- (void)showNextAd {
    if(self.ads == nil || self.ads.count == 0) return;
    
    Ad *ad;
    while (ad == nil)
    {
        ad = self.ads[self.slideShowPosition];
        self.slideShowPosition++;
        
        if(self.slideShowPosition >= self.ads.count - 1) {
            self.slideShowPosition = 0;
        }
    }
    
    if([ad.photoId isKindOfClass:[NSString class]]) {
        NSData *data = [self.adService getPhotoForId:ad.photoId];
        if(data != nil) {
            self.imageView.image = [UIImage imageWithData:data];
        }
    }
}

@end
