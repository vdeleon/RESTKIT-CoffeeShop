//
//  Venue.h
//  CoffeeShop
//
//  Created by Romy Ilano on 9/23/12.
//  Copyright (c) 2012 Snowyla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Location *location;

@end
