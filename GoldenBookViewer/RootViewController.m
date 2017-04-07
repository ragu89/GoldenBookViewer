//
//  RootViewController.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 07.04.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import "RootViewController.h"
#import "AdService.h"

@interface RootViewController ()

@property(nonatomic, strong) AdService *adService;

@end

@implementation RootViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _adService = [AdService new]; //TODO : Use IoC
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _progressRing.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)synchronizeButton_clicked:(id)sender {
    [_progressRing startAnimating];
    _progressRing.hidden = NO;
    _synchronizeButton.enabled = NO;
    _startButton.enabled = NO;
    
    [self.adService synchronizeAdsWithCompletionHandler:^{
        [_progressRing stopAnimating];
        _progressRing.hidden = YES;
        _synchronizeButton.enabled = YES;
        _startButton.enabled = YES;
    }];
}
@end
