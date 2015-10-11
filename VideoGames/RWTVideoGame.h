//
//  RWTVideoGame.h
//  VideoGames
//
//  Created by Brian Moakley on 4/14/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTVideoGame : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * genre;
@property (assign, nonatomic) short rating;
@property (strong, nonatomic) NSString * synopsis;

@end
