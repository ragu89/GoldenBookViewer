//
//  ViewController.h
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 11.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideshowViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

