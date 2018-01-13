//
//  JETAppDelegate.h
//  ParkingSpotter
//
//  Created by Lyudmyla Ivanova on 1/12/18.
//  Copyright © 2018 Lyudmyla Ivanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JETAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

