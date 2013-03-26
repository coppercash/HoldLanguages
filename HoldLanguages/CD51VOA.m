//
//  CD51VOA.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CD51VOA.h"

@implementation CD51VOA
- (id)init{
    self = [super initWithHostName:@"www.51voa.com"];
    return self;
}

- (LAHOperation *)homePage{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"51VOA" ofType:@"lah"];
    LAHOperation *operation = [self operationWithFile:path key:@"ope"];
    return operation;
}

- (LAHOperation *)itemAtPath:(NSString *)path{
    NSString *lahPath = [[NSBundle mainBundle] pathForResource:@"51VOAItem" ofType:@"lah"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    LAHOperation *operation = [self operationWithFile:lahPath key:@"ope" dictionary:dic];
    
    operation.link = path;
    
    return operation;
}

- (LAHOperation *)listAt:(NSString *)link inRange:(NSRange)range{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"51VOAList" ofType:@"lah"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    LAHOperation *operation = [self operationWithFile:path key:@"ope" dictionary:dic];
    
    LAHRecognizer *identifier = [dic objectForKey:@"id"];
    identifier.range = range;
    
    operation.link = link;
    
    return operation;
}

@end

NSString * const g51PathHome = @"www.51voa.com";
NSString * const g51PathStandard = @"/VOA_Standard_1.html";

