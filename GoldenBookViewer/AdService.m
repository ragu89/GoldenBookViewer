//
//  AdService.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 12.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import "AdService.h"
#import "RestClient.h"

@implementation AdService

-(void)downloadImageWithcompletionHandler:(void (^)(NSData *responseData, NSError *error))completionHandler
{
    NSString *photoId = @"photo-50894e48f37f4e1499f56192bd2fb49b";
    
    [[RestClient sharedInstance] downloadImageDataForPhotoId:photoId
                                           completionHandler:completionHandler];
}

@end
