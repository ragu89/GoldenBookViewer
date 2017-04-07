//
//  Ad.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 12.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import "Ad.h"

@implementation Ad

-(NSDictionary*)convertToNSDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setValue:self.adId forKey:@"adId"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.message forKey:@"message"];
    [dict setValue:self.photoId forKey:@"photoId"];
    
    return dict;
}

@end
