//
//  AppStatus.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

typedef enum {
    AudioSourceTypeDownloads,
    AudioSourceTypeFileSharing
}AudioSourceType;

typedef struct {
    AudioSourceType audioSourceType;
} AppStatus;