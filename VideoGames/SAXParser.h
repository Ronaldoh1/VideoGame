//
//  RWTXMLParser.h
//  VideoGames
//
//  Created by Brian Moakley on 4/14/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAXParser : NSObject

@property (strong, nonatomic) NSString * xml;

-(NSArray *) parseFeed;

@end
