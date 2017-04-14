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
    [[RestClient sharedInstance] getAdsWithCompletionHandler:^(NSArray *ads, NSError *error) {
        
        if(error != nil) return;
        
        [self saveInPlistFile:ads];
        
        [self downloadImagesForPhotos:ads withCompletionHandler:completionHandler];
    }];
}

-(void)saveInPlistFile:(NSArray*)ads {
    NSString *plistName = @"ads.json";
    NSString *filepath = [[self getCacheFilepath] stringByAppendingString:[NSString stringWithFormat:@"/%@", plistName]];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:filepath]) {
        [fm removeItemAtPath:filepath error:nil];
    }
    
    NSMutableArray *adsForJson = [NSMutableArray new];
    for(Ad *ad in ads) {
        [adsForJson addObject:[ad convertToNSDictionary]];
    }
    
    NSError *writeError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:adsForJson options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Try to save json file in %@", filepath);
    
    writeError = nil;
    BOOL isFileSaved = [jsonString writeToFile:filepath
                                    atomically:YES
                                      encoding:NSUTF8StringEncoding
                                         error:&writeError];
    
    if(!isFileSaved) {
        NSLog(@"KO - JSON file not correctly saved");
    } else {
        NSLog(@"OK - JSON file correctly saved");
    }
}

-(void)downloadImagesForPhotos:(NSArray*)ads withCompletionHandler:(void (^)())completionHandler
{
    __block int i = 0;
    for(Ad *ad in ads) {
        
        i++;
        
        if(ad.photoId != nil && [self isPhotoMissing:ad.photoId]) {
            [[RestClient sharedInstance] downloadImageDataForPhotoId:ad.photoId
                                                   completionHandler:^(NSData *responseData, NSError *error) {
                                                       
                                                       if(error == nil) {
                                                           [self savePhoto:responseData filename:ad.photoId];
                                                       }
                                                       
                                                       if(i >= ads.count) {
                                                           completionHandler(); // Doesn't work
                                                       }
                                                   }];
        }
    }
}

-(BOOL)isPhotoMissing:(NSString*)photoId {
    NSString *filepath = [[self getCacheFilepath] stringByAppendingString:[NSString stringWithFormat:@"/%@", photoId]];
    
    NSData *file = [NSData dataWithContentsOfFile:filepath];
    
    if(file == nil) {
        return YES;
    } else {
        return NO;
    }
}

-(void)savePhoto:(NSData*)data filename:(NSString*)filename {
    NSString *filepath = [[self getCacheFilepath] stringByAppendingString:[NSString stringWithFormat:@"/%@", filename]];
    
    NSLog(@"Try to save photo in %@", filepath);
    
    NSError *error;
    [data writeToFile:filepath options:NSDataWritingAtomic error:&error];
    
    if(error == nil) {
        NSLog(@"OK - photo correctly saved");
    } else {
        NSLog(@"KO - photo not correctly saved");
    }
}

-(NSString*)getCacheFilepath {
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheDir = [libraryDir stringByAppendingPathComponent:@"Caches"];
    return cacheDir;
}

@end
