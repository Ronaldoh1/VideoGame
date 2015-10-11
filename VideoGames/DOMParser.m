//
//  DOMParser.m
//  VideoGames
//
//  Created by Brian Moakley on 6/4/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "DOMParser.h"
#import "RWTVideoGame.h"
#import "RXMLElement.h"

@interface DOMParser()

@property (strong, nonatomic) NSMutableString * xmlText;

@end

@implementation DOMParser

-(NSArray *) parseFeed
{
    
    NSMutableArray * videoGames = [@[] mutableCopy];
    if (self.xml)
    {
        RXMLElement * element = [RXMLElement elementFromXMLData:[self.xml dataUsingEncoding:NSUTF8StringEncoding]];
        NSArray * elements = [element children:@"video_game"];

        for (RXMLElement * currentElement in elements)
        {
            RWTVideoGame * videoGame = [[RWTVideoGame alloc] init];
            videoGame.name = [currentElement child:@"name"].text;
            videoGame.genre = [currentElement child:@"genre"].text;
            
            NSNumber * number = @([currentElement child:@"rating"].text.intValue);
            videoGame.rating = number.shortValue;
            videoGame.synopsis = [currentElement child:@"synopsis"].text;
            [videoGames addObject:videoGame];
        }
        
    }
    return videoGames;
}

@end
