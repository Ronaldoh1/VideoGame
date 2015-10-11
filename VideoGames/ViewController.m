//
//  ViewController.m
//  VideoGames
//
//  Created by Brian Moakley on 4/14/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "ViewController.h"
#import "SAXParser.h"
#import "RWTVideoGame.h"
#import "DOMParser.h"
#import "XMLWriter.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *genre;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UITextView *synopsis;
@property (strong, nonatomic) NSArray *videoGames;
@property (assign, nonatomic) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SAXParser *videoGameParser = [[SAXParser alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"video_games" ofType:@"xml"];
    videoGameParser.xml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString * anotherFilePath = [[NSBundle mainBundle] pathForResource:@"other_video_games" ofType:@"xml"];
    DOMParser * parser = [[DOMParser alloc] init];
    parser.xml = [NSString stringWithContentsOfFile:anotherFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray * reviews = [parser parseFeed];
    
    NSMutableArray * combinedReviews = [NSMutableArray arrayWithArray:reviews];
    self.videoGames = [videoGameParser parseFeed];
    self.index = 0;
    
    [combinedReviews addObjectsFromArray:self.videoGames];
    self.videoGames = [NSArray arrayWithArray:combinedReviews];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * documentDirectory = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL * saveFile = [documentDirectory URLByAppendingPathComponent:@"combined.xml"];
    
    XMLWriter * writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    [writer writeStartElement:@"video_games"];
    for (RWTVideoGame * videoGame in self.videoGames)
    {
        [writer writeStartElement:@"video_game"];
            [writer writeStartElement:@"name"];
            [writer writeCharacters:videoGame.name];
            [writer writeEndElement];

            [writer writeStartElement:@"genre"];
            [writer writeCharacters:videoGame.name];
            [writer writeEndElement];

            [writer writeStartElement:@"rating"];
            [writer writeCharacters:[NSString stringWithFormat:@"%hd",videoGame.rating]];
            [writer writeEndElement];

            [writer writeStartElement:@"synopsis"];
            [writer writeCharacters:videoGame.synopsis];
            [writer writeEndElement];
        [writer writeEndElement];
    }
    [writer writeEndElement];
    [writer writeEndDocument];
    
    NSString * xml = [writer toString];
    [xml writeToURL:saveFile atomically:YES encoding:NSUTF8StringEncoding error:nil];

    //creating the structure of JSON

    NSMutableArray *topLevelContiner = [@[] mutableCopy];
    for (RWTVideoGame *game in self.videoGames){

        NSMutableDictionary *object = [@{}mutableCopy];
        object[@"name"] = game.name;
        object[@"genre"] = game.genre;
        object[@"rating"] = @(game.rating);
        object[@"synopsis"] = game.synopsis;
        [topLevelContiner addObject: object];

        //create a save file.

        NSURL * library = [fileManager URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *jsonFile = [library URLByAppendingPathComponent:@"video_games.json"];

        NSData *json = [NSJSONSerialization dataWithJSONObject:topLevelContiner options:NSJSONWritingPrettyPrinted error:nil];

        //write it out
        [json writeToURL:jsonFile atomically:YES];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (IBAction)previousTap:(id)sender {
    if (self.index > 0)
    {
        self.index -= 1;
    }
    [self updateUI];
}

- (IBAction)nextTap:(id)sender
{
    if (self.index < self.videoGames.count-1)
    {
        self.index += 1;
    }
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateUI
{
    RWTVideoGame *videoGame = self.videoGames[self.index];
    self.gameName.text = videoGame.name;
    self.genre.text = videoGame.genre;
    self.rating.text = [NSString stringWithFormat:@"%d", videoGame.rating];
    self.synopsis.text = videoGame.synopsis;
}


@end
