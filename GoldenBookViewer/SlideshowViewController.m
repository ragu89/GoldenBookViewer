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
@property(nonatomic, strong) UIGestureRecognizer *tapOnPhotoGesture;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation SlideshowViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.adService = [AdService new]; //TODO : Use IoC
    self.slideShowPosition = 0;
    self.tapOnPhotoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(showNextAd)];
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
    [self.imageView addGestureRecognizer:self.tapOnPhotoGesture];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                 repeats:YES
                                                   block:^(NSTimer * _Nonnull timer) {
                                                       [self showNextAd];
                                                   }];
    [self showNextAd]; // Show the first ad manually, before the first timer interval 
}

- (void)stopSlideshow {
    [self.timer invalidate];
    [self.imageView removeGestureRecognizer:self.tapOnPhotoGesture];
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
    
    if([ad.name isKindOfClass:[NSString class]]) {
        self.nameLabel.text = ad.name;
    } else {
        self.nameLabel.text = @"";
    }
    
    if([ad.message isKindOfClass:[NSString class]]) {
        self.messageLabel.text = ad.message;
    } else {
        self.messageLabel.text = @"";
    }
    
    self.imageView.image = nil;
    if([ad.photoId isKindOfClass:[NSString class]]) {
        NSData *data = [self.adService getPhotoForId:ad.photoId];
        if(data != nil) {
            self.imageView.image = [UIImage imageWithData:data];
        }
    }
    
    [self.view layoutIfNeeded];
}

@end
