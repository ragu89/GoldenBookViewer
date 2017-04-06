//
//  AdService.h
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 12.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdService : NSObject

-(void)synchronizeAdsWithCompletionHandler:(void (^)())completionHandler;

-(void)downloadImagesForPhotos:(NSArray*)photoIds withCompletionHandler:(void (^)())completionHandler;

@end
