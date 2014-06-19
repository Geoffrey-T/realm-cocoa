//
//  RLMRealmNode.m
//  RealmVisualEditor
//
//  Created by Jesper Zuschlag on 20/05/14.
//  Copyright (c) 2014 Realm inc. All rights reserved.
//

#import "RLMRealmNode.h"

#import <Realm/Realm.h>

@interface RLMRealm ()

+ (instancetype)realmWithPath:(NSString *)path
                     readOnly:(BOOL)readonly
                      dynamic:(BOOL)dynamic
                        error:(NSError **)outError;

@end


@implementation RLMRealmNode

- (instancetype)init
{
    return self = [self initWithName:@"Unknown name"
                                 url:@"Unknown location"];
}

- (instancetype)initWithName:(NSString *)name url:(NSString *)url
{
    if (self = [super init]) {
        _name = name;
        _url = url;        
    }
    return self;
}

- (BOOL)connect:(NSError **)error
{
    _realm = [RLMRealm realmWithPath:_url
                            readOnly:NO
                             dynamic:YES
                               error:error];
    
    if (*error != nil) {
        NSLog(@"Realm was opened with error: %@", *error);
    }
    else {
        _topLevelClazzes = [self constructTopLevelClazzes];    
    }
    
    return error != nil;
}


- (void)addTable:(RLMClazzNode *)table
{

}

#pragma mark - RLMRealmOutlineNode implementation

- (BOOL)isRootNode
{
    return YES;
}

- (BOOL)isExpandable
{
    return [self topLevelClazzes].count != 0;
}

- (NSUInteger)numberOfChildNodes
{
    return [self topLevelClazzes].count;
}

- (id<RLMRealmOutlineNode>)childNodeAtIndex:(NSUInteger)index
{
    return [self topLevelClazzes][index];
}

- (id)nodeElementForColumnWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"CLASSES";
            
        default:
            return nil;
    }
}

- (BOOL)hasToolTip
{
    return YES;
}

- (NSString *)toolTipString
{
    return _url;
}

#pragma mark - Private methods

- (NSArray *)constructTopLevelClazzes
{
    RLMSchema *realmSchema = _realm.schema;
    NSArray *allObjectSchemas = realmSchema.objectSchema;
    
    NSUInteger clazzCount = allObjectSchemas.count;
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:clazzCount];
    
    for (NSUInteger index = 0; index < clazzCount; index++) {
        RLMObjectSchema *objectSchema = allObjectSchemas[index];        
        RLMClazzNode *tableNode = [[RLMClazzNode alloc] initWithSchema:objectSchema
                                                               inRealm:_realm];
        
        [result addObject:tableNode];
    }
    
    return result;
}

@end
