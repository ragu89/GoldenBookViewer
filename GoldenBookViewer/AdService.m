//
//  AdService.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 12.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import "AdService.h"
#import "RestClient.h"
#import "Ad.h"
#import <Foundation/Foundation.h>

@implementation AdService

-(void)synchronizeAdsWithCompletionHandler:(void (^)())completionHandler
{
    NSMutableDictionary *adsDict = [[NSMutableDictionary alloc] init];
    
    [[RestClient sharedInstance] getAdsWithCompletionHandler:^(NSArray *ads, NSError *error) {
        
        if(error != nil) return;
        
        for (Ad *ad in ads) {
            [adsDict setObject:ad.photoId forKey:ad.adId];
        }
        
        [self downloadImagesForPhotos:[adsDict allValues] withCompletionHandler:completionHandler];
    }];
}

-(void)downloadImagesForPhotos:(NSArray*)photoIds withCompletionHandler:(void (^)())completionHandler
{
    __block int i = 0;
    for(NSString *photoId in photoIds) {
        
        i++;
        
        if(photoId != nil && [self isPhotoMissing:photoId]) {
            [[RestClient sharedInstance] downloadImageDataForPhotoId:photoId
                                                   completionHandler:^(NSData *responseData, NSError *error) {
                                                       
                                                       if(error == nil) {
                                                           [self savePhoto:responseData filename:photoId];
                                                       }
                                                       
                                                       if(i >= photoIds.count) {
                                                           completionHandler(); // Doesn't work
                                                       }
                                                   }];
        }
    }
}

-(BOOL)isPhotoMissing:(NSString*)photoId {
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheDir = [libraryDir stringByAppendingPathComponent:@"Caches"];
    NSString *filepath = [cacheDir stringByAppendingString:[NSString stringWithFormat:@"/%@", photoId]];
    
    NSData *file = [NSData dataWithContentsOfFile:filepath];
    
    if(file == nil) {
        return YES;
    } else {
        return NO;
    }
}

-(void)savePhoto:(NSData*)data filename:(NSString*)filename {
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheDir = [libraryDir stringByAppendingPathComponent:@"Caches"];
    NSString *filepath = [cacheDir stringByAppendingString:[NSString stringWithFormat:@"/%@", filename]];
    
    NSError *error;
    [data writeToFile:filepath options:NSDataWritingAtomic error:&error];
    
    if(error != nil) {
        NSLog(@"Error when trying to save file %@", filename);
    }
}

@end
