//
//  RestClient.h
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 12.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestClient : NSObject <NSURLSessionDownloadDelegate>

+ (instancetype)sharedInstance;

-(void)downloadImageDataForPhotoId:(NSString*)photoId
                 completionHandler:(void (^)(NSData *responseData, NSError *error))completionHandler;

@end
