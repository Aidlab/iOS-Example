//
//  AidlabInterop.hpp
//  Aidlab-SDK
//
//  Created by Kuba Domaszewicz on 10.11.2016.
//  Copyright © 2016-2020 Aidmed Sp. z o.o. All rights reserved.
//

#ifndef AIDLAB_INTEROP_HPP
#define AIDLAB_INTEROP_HPP

#import <Foundation/Foundation.h>
#include "AidlabEnum.h"

@protocol AidlabInteropDelegate
- (void) didReceiveECG: (uint64_t) timestamp value: (float) value;
- (void) didReceiveRespiration: (uint64_t) timestamp value: (float) value;
- (void) didReceiveBatteryLevel: (uint8_t) stateOfCharge;
- (void) didReceiveSteps: (uint64_t) timestamp value: (uint64_t) value;
- (void) didReceiveSkinTemperature: (uint64_t) timestamp value: (float) value;
- (void) didReceiveAccelerometer: (uint64_t) timestamp ax: (float) ax ay: (float) ay az: (float) az;
- (void) didReceiveGyroscope: (uint64_t) timestamp gx: (float) gx gy: (float) gy gz: (float) gz;
- (void) didReceiveMagnetometer: (uint64_t) timestamp mx: (float) mx my: (float) my mz: (float) mz;
- (void) didReceiveQuaternion: (uint64_t) timestamp qw: (float) qw qx: (float) qx qy: (float) qy qz: (float) qz;
- (void) didReceiveOrientation: (uint64_t) timestamp roll: (float) roll pitch: (float) pitch yaw: (float) yaw;
- (void) didReceiveHeartRate: (uint64_t) timestamp hrv: (int*) hrv heartRate: (int) heartRate;
- (void) didReceiveRespirationRate: (uint64_t) timestamp value: (uint32_t) value;
- (void) wearStateDidChange: (WearState) state;
- (void) didReceiveSoundVolume: (uint64_t) timestamp soundVolume: (uint16_t) soundVolume;
- (void) didDetectExercise: (Exercise) exercise;
- (void) didDetectActivity: (uint64_t) timestamp activity: (ActivityType) activity;
- (void) didReceiveCommand;

// AidlabSynchronizationDelegate
- (void) didReceivePastECG: (uint64_t) timestamp value: (float) value;
- (void) didReceivePastRespiration: (uint64_t) timestamp value: (float) value;
- (void) didReceivePastSkinTemperature: (uint64_t) timestamp value: (float) value;
- (void) didReceivePastHeartRate: (uint64_t) timestamp hrv: (int*) hrv heartRate: (int) heartRate;
- (void) syncStateDidChange: (SyncState) syncState;
- (void) didReceiveUnsynchronizedSize: (uint16_t) unsynchronizedSize;
- (void) didReceivePastRespirationRate: (uint64_t) timestamp value: (uint32_t) value;
- (void) didReceivePastActivity: (uint64_t) timestamp activity: (ActivityType) activity;
- (void) didReceivePastSteps: (uint64_t) timestamp value: (uint64_t) value;

// AidlabUpdateDelegate
- (void) didReceiveUpdateError: (UpdateError) error;
- (void) didReceiveUpdateProgress: (uint8_t) progress;
- (void) didFinishUpdate;
- (void) sendFirmwareChunk: (uint8_t*) buffer;

@end

@interface AidlabInterop : NSObject

- (instancetype) init;
- (void) processECGPackage: (uint8_t*) sample size:(int) size;
- (void) processRespirationPackage: (uint8_t*) sample size:(int) size;
- (void) processTemperaturePackage: (uint8_t*) sample size:(int) size;
- (void) processMotionPackage: (uint8_t*) sample size:(int) size;
- (void) processBatteryPackage: (uint8_t*) sample size:(int) size;
- (void) processActivityPackage: (uint8_t*) sample size:(int) size;
- (void) processStepsPackage: (uint8_t*) sample size:(int) size;
- (void) processOrientationPackage: (uint8_t*) sample size:(int) size;
- (void) processHealthThermometerPackage: (uint8_t*) sample size:(int) size;
- (void) processHeartRatePackage: (uint8_t*) sample size:(int) size;
- (void) processCommandPackage: (uint8_t*) sample size:(int) size;
- (void) processSoundVolumePackage: (uint8_t*) sample size:(int) size;
- (void) setHardwareRevision: (unsigned char*) hwRevision size:(int) size;
- (void) setFirmwareRevision: (unsigned char*) fwRevision size:(int) size;
- (void) setAggressiveECGFiltration: (bool) value;
- (void) setUserCallback;
- (void) didConnect;
- (uint32_t) getTime;
- (uint8_t*) prepareCommand: (NSString *) command;
- (void) startFirmwareUpdate: (uint8_t*) firmware firmwareSize: (int) firmwareSize;

@property (nonatomic, weak) id <AidlabInteropDelegate> aidlabInteropDelegate;
@end

#endif /* AIDLAB_INTEROP_HPP */
