//
//  ViewController.m
//  HockeySDK
//
//  Created by Lalit Paliwal on 13/05/14.
//  Copyright (c) 2014 YASH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)showAlert:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:@"Success Alert" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(IBAction)doCrash:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
    [array insertObject:@"abc" atIndex:4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
