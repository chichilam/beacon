//
//  Beacon.m
//  Copyright (c) 2014年 apc. All rights reserved.
//

#import "Beacon.h"

#if 0
#define SHOWLOG
#endif

@interface Beacon()
{
    CLLocationManager *locationManager;
    NSMutableArray *uuidArr;
}

@end

@implementation Beacon

-(instancetype) initScanBeaconWithUuidArray:(NSMutableArray*) uuids
{
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        
        uuidArr = uuids;
    }
    
    return self;
}

-(void) scanBeacon
{
    for (NSInteger i = 0; i < uuidArr.count; i++) {
        NSString *uuid = uuidArr[i];
        
        if(uuid == nil || uuid.length == 0) {
            continue;
        }
        
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                          identifier:[@"apc.tdl." stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)i]]];
        [locationManager startMonitoringForRegion:beaconRegion];
    }
}

-(void) stopScanBeacon
{
    for (NSInteger i = 0; i < uuidArr.count; i++) {
        NSString *uuid = uuidArr[i];
        
        if(uuid == nil || uuid.length == 0) {
            continue;
        }
        
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                          identifier:[@"apc.tdl." stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)i]]];
        [locationManager stopMonitoringForRegion:beaconRegion];
    }
}

//beacon領域進入
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
#ifdef SHOWLOG
    NSLog(@"didEnterRegion:%@",region);
#endif
    
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        [self.delegate didEnterRegion:region];
    }
}

//beacon領域離れる
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{

}

//検索開始
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [locationManager requestStateForRegion:region];
}

//beacon距離変更
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
#ifdef SHOWLOG
        NSLog(@"CLRegionStateInside:%@",region);
#endif
    }
    else if(state == CLRegionStateOutside)
    {
#ifdef SHOWLOG
        NSLog(@"CLRegionStateOutside:%@",region);
#endif
    }
    else if(state == CLRegionStateUnknown)
    {
#ifdef SHOWLOG
        NSLog(@"CLRegionStateUnknown:%@",region);
#endif
    }
}

//beacon取得失敗
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@",[error description]);
}

//beacon情報
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons == nil) {
        return;
    }
    
    if(beacons.count == 1) {
        CLBeacon *ibeacon = beacons.firstObject;
        [self.delegate didRangeBeacon:ibeacon inRegion:region];
        
#ifdef SHOWLOG
        NSLog(@"didRangeBeacons:%@",ibeacon);
#endif
        
    } else {
        for (int i = 0; i < beacons.count; i++) {
            CLBeacon *ibeacon = beacons[i];
            [self.delegate didRangeBeacon:ibeacon inRegion:region];
            
#ifdef SHOWLOG
            NSLog(@"didRangeBeacons:%@",ibeacon);
#endif
        }
    }
}

@end
