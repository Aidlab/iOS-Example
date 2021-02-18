//
//  AidlabEnum.h
//  Aidlab-SDK
//
//  Created by Szymon Gesicki on 27.05.2020.
//  Copyright © 2020 Aidlab. All rights reserved.
//

#ifndef AIDLAB_ENUM_H
#define AIDLAB_ENUM_H

/// unfortunately the enums must be in a separate file 
/// and they must be typedef because they are used in objective c

typedef enum {

    placedProperly = 0,
    placedUpsideDown = 1,
    loose = 2,
    detached = 3,
    unknown = 4,
    unsettled = 5

} WearState;

typedef enum {
    
    none = -1,
    pushUp = 0,
    jump = 1,
    sitUp = 2,
    burpee = 3,
    pullUp = 4,
    squat = 5,
    plankStart = 6,
    plankEnd = 7

} Exercise;

typedef enum {

    automotive = 1,
    walking = 2,
    running = 4,
    cycling = 8,
    still = 16    

} ActivityType;

typedef enum {

    start = 0,
    end = 1,
    stop = 2,
    empty = 3,
    unavailable = 4,
    
} SyncState;

typedef enum {
    oldFirmware,
    crcError,
    stopped,
    fail,
    unknownResponse
} UpdateError;


typedef enum {
    undefined = 0,
    front = 1,
    back = 2,
    leftSide = 3,
    rightSide = 4
} BodyPosition;


#endif /* AIDLAB_ENUM_H */
