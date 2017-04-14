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

#pragma mark - Service methods

-(void)synchronizeAdsWithCompletionHandler:(void (^)())completionHandler
{
    [[RestClient sharedInstance] getAdsWithCompletionHandler:^(NSArray *ads, NSError *error) {
        
        if(error != nil) return;
        
        [self saveInJSONFile:ads];
        
        [self downloadImagesForPhotos:ads withCompletionHandler:completionHandler];
    }];
}

-(void)downloadImagesForPhotos:(NSArray*)ads withCompletionHandler:(void (^)())completionHandler
{
    __block int i = 0;
    for(Ad *ad in ads) {
        
        if(ad.photoId != nil && [self isPhotoMissing:ad.photoId]) {
            [[RestClient sharedInstance] downloadImageDataForPhotoId:ad.photoId
                                                   completionHandler:^(NSData *responseData, NSError *error) {
                                                       
                                                       i++;
                                                       
                                                       if(error == nil) {
                                                           [self savePhoto:responseData filename:ad.photoId];
                                                       }
                                                       
                                                       if(i >= ads.count) {
                                                           NSLog(@"All the photos have been downloaded");
                                                           completionHandler();
                                                       }
                                                   }];
        } else {
            i++;
            
            if(i >= ads.count) {
                NSLog(@"All the photos have been downloaded");
                completionHandler(); // Doesn't work
            }
        }
    }
}

-(NSArray*)getAdsList {
    NSString *fileName = @"ads.json";
    NSString *cacheDir = [self getCacheFilepath];
    NSString *filepath = [cacheDir stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:filepath]) {
        NSLog(@"The file %@ doesn't exist in %@", fileName, cacheDir);
        return [NSArray new];
    }
    
    NSLog(@"Trying to deserialize json file %@", filepath);
    
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    NSError *error = nil;
    NSArray *jsonAds = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    if(error != nil || jsonAds == nil) {
        NSLog(@"KO - Error when trying to deserialize the json file : %@", error);
    } else {
        NSLog(@"OK - JSON file correctly deserialized. %lu items found.", (unsigned long)jsonAds.count);
    }
    
    NSMutableArray *ads = [NSMutableArray new];
    for(NSDictionary *dictAd in jsonAds) {
        if(![dictAd isKindOfClass:[NSDictionary class]]) continue;
        
        Ad *ad = [Ad new];
        
        if([dictAd[@"adId"] isKindOfClass:[NSString class]]) {
            ad.adId = dictAd[@"adId"];
        }
        if([dictAd[@"message"] isKindOfClass:[NSString class]]) {
            ad.message = dictAd[@"message"];
        }
        if([dictAd[@"name"] isKindOfClass:[NSString class]]) {
            ad.name = dictAd[@"name"];
        }
        if([dictAd[@"photoId"] isKindOfClass:[NSString class]]) {
            ad.photoId = dictAd[@"photoId"];
        }
        
        [ads addObject:ad];
    }
    
    NSLog(@"%lu entities created from the json", (unsigned long)ads.count);
    
    return [NSArray arrayWithArray:ads];
}

-(NSData*)getPhotoForId:(NSString*)photoId {
    
    NSString *filepath = [[self getCacheFilepath] stringByAppendingString:[NSString stringWithFormat:@"/%@", photoId]];
    NSError *error;
    
    NSLog(@"Trying to recover the photo from filepath %@", filepath);
    
    NSData *photo = [NSData dataWithContentsOfFile:filepath
                                           options:NSDataReadingUncached
                                             error:&error];
    
    if(error != nil || photo == nil) {
        NSLog(@"KO - Error when trying to recover NSData from file");
        return nil;
    } else {
        NSLog(@"OK - photo correctly recovered");
        return photo;
    }
}

#pragma mark - Private methods

-(BOOL)isPhotoMissing:(NSString*)photoId {
    NSString *filepath = [[self getCacheFilepath] stringByAppendingString:[NSString stringWithFormat:@"/%@", photoId]];
    
    NSData *file = [NSData dataWithContentsOfFile:filepath];
    
    if(file == nil) {
        return YES;
    } else {
        return NO;
    }
}

-(void)saveInJSONFile:(NSArray*)ads {
    NSString *filename = @"ads.json";
    NSString *filepath = [[self getCacheFilepath] stringByAppendingString:[NSString stringWithFormat:@"/%@", filename]];
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
