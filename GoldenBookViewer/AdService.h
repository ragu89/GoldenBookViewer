//
//  AdService.h
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 12.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdService : NSObject

-(void)downloadImageWithcompletionHandler:(void (^)(NSData *responseData, NSError *error))completionHandler;

@end
