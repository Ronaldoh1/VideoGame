//
//  RWTXMLParser.m
//  VideoGames
//
//  Created by Brian Moakley on 4/14/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "SAXParser.h"
#import "RWTVideoGame.h"

@interface SAXParser()<NSXMLParserDelegate>

@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (strong, nonatomic) NSMutableArray *videoGames;
@property (strong, nonatomic) NSMutableString *xmlText;
@property (strong, nonatomic) RWTVideoGame *currentVideoGame;

@end

@implementation SAXParser

-(NSArray *) parseFeed
{
    self.videoGames = [@[] mutableCopy];
    if (self.xml)
    {
        self.xmlParser = [[NSXMLParser alloc] initWithData:[self.xml dataUsingEncoding:NSUTF8StringEncoding]];
        self.xmlParser.delegate = self;
        [self.xmlParser parse];
    }
    return [NSArray arrayWithArray:self.videoGames];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.xmlText = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:@"video_game"])
    {
        self.currentVideoGame = [[RWTVideoGame alloc] init];
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"name"])
    {
        self.currentVideoGame.name = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if ([elementName isEqualToString:@"genre"])
    {
        self.currentVideoGame.genre = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if ([elementName isEqualToString:@"rating"])
    {
        self.currentVideoGame.rating = [self.xmlText intValue];
    }
    if ([elementName isEqualToString:@"synopsis"])
    {
        self.currentVideoGame.synopsis = [self.xmlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if ([elementName isEqualToString:@"video_game"])
    {
        [self.videoGames addObject:self.currentVideoGame];
    }
    
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.xmlText appendString:string];
}

@end
