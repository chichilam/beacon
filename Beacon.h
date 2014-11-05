//
//  Beacon.h
//  Copyright (c) 2014年 apc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@protocol BeaconDelegate  <NSObject>

@optional
-(void) didEnterRegion:(CLRegion *)region;
-(void) didRangeBeacon:(CLBeacon *)ibeacon inRegion:(CLBeaconRegion *)region;

@end

@interface Beacon : NSObject<CLLocationManagerDelegate>

@property (nonatomic, weak) id <BeaconDelegate> delegate;

-(instancetype) initScanBeaconWithUuidArray:(NSMutableArray*) uuids;

-(void) scanBeacon;
-(void) stopScanBeacon;

@end
