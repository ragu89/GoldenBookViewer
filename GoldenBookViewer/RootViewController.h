//
//  RootViewController.h
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 07.04.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressRing;
@property (weak, nonatomic) IBOutlet UIButton *synchronizeButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)synchronizeButton_clicked:(id)sender;

@end
