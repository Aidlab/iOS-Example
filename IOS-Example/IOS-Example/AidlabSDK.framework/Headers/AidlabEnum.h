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

    placedProperly,
    placedUpsideDown,
    loose,
    detached,
    unknown,
    unsettled

} WearState;

typedef enum {
    
    none = -1,
    pushUp,
    jump,
    sitUp,
    burpee,
    pullUp,
    squat,
    plankStart,
    plankEnd

} Exercise;

typedef enum {

    automotive = 1,
    walking = 2,
    running = 4,
    cycling = 8,
    still = 16    

} ActivityType;

typedef enum {

    start,
    end,
    stop,
    empty,
    unavailable,
    
} SyncState;

typedef enum {
    oldFirmware,
    crcError,
    stopped,
    fail,
    unknownResponse
} UpdateError;


typedef enum {
    undefined,
    front,
    back,
    leftSide,
    rightSide,
} BodyPosition;


#endif /* AIDLAB_ENUM_H */
