//
//  RowDescriptor.h
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFAction.h"

@class TFSectionDescriptor;

typedef void (^TFCellConfigureBlock)(UITableViewCell *cell);
typedef TFCellConfigureBlock TFCustomRowAnimation;

@interface TFRowDescriptor : NSObject

@property (nonatomic) Class rowClass;
@property (nonatomic) id data;
@property (nonatomic) NSString *tag;
@property (nonatomic, weak) TFSectionDescriptor *section;
@property (nonatomic, copy) void (^actionBlock)(TFAction *action);
@property (nonatomic, strong) NSNumber *cellHeight;

@property (nonatomic,getter=isHidden) BOOL hidden;

+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data;
+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data tag:(NSString *)tag;

- (void)setTarget:(id)target withSelector:(SEL)selector;
- (void)setActionBlock:(void(^)(TFAction *action))actionBlock;

/// Determine if action can be triggered
- (BOOL)canTriggerAction;
- (void)triggerAction:(TFAction *)action;

#pragma mark - Visibility

- (void)setHidden:(BOOL)hidden withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)setHidden:(BOOL)hidden withCustomAnimation:(TFCustomRowAnimation)rowAnimation;

@end



@interface TFRowDescriptor (PrivateMethods)

- (void)setHidden:(BOOL)hidden checkIfUpdating:(BOOL)check;

@end