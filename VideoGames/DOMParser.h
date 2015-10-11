//
//  DOMParser.h
//  VideoGames
//
//  Created by Brian Moakley on 6/4/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOMParser : NSObject

@property (strong, nonatomic) NSString * xml;

-(NSArray *) parseFeed;

@end
