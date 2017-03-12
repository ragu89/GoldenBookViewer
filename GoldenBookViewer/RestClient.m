//
//  RestClient.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 12.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import "RestClient.h"

@implementation RestClient

+ (instancetype)sharedInstance
{
    static RestClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RestClient alloc] init];
    });
    return sharedInstance;
}

-(void)downloadImageDataForPhotoId:(NSString*)photoId
                 completionHandler:(void (^)(NSData *responseData, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"https://goldenbook.blob.core.windows.net/golden-book-photos/%@", photoId]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:30.0];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: configuration
                                                                 delegate: self
                                                            delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               completionHandler(data, nil);
                                                           }
                                                           else
                                                           {
                                                               completionHandler(nil, error);
                                                           }
                                                           
                                                       }];
    [dataTask resume];
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

@end
