//
//  TFFormDescriptor.m
//  Pods
//
//  Created by Aleš Kocur on 26/04/15.
//
//

#import "TFFormDescriptor.h"
#import "TFTableDescriptor.h"
#import "TFFormBaseField.h"
#import "TFTableDescriptor+FormReference.h"


#pragma mark - TFFormDescriptor

@interface TFFormDescriptor ()<TFTableDescriptorDelegate>

@property (strong, nonatomic) TFTableDescriptor *tableDescriptor;

@property (strong, nonatomic) NSMutableArray *sections;

@end

@implementation TFFormDescriptor

+ (instancetype)descriptorWithTable:(UITableView *)tableView {
    
    TFFormDescriptor *formDescriptor = [[[self class] alloc] init];
    
    formDescriptor.tableDescriptor = [TFTableDescriptor descriptorWithTable:tableView];
    formDescriptor.tableDescriptor.delegate = formDescriptor;
    formDescriptor.tableDescriptor.formDescriptor = formDescriptor;
    [formDescriptor registerDefaultFormClasses];
    
    return formDescriptor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)registerDefaultFormClasses {
    for (Class c in [TFFormDescriptor defaultFormsClasses]) {
        REGISTER_CELL_FOR_TABLE(c, self.tableDescriptor.tableView);
    }
}

+ (NSArray *)defaultFormsClasses {
    return @[[TFFormTitledTextField class], [TFFormTitledSwitchField class], [TFFormTitledTextViewField class]];
}

#pragma mark - Adding sections and rows

- (NSMutableArray *)sections{
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (void)addSection:(TFFormSectionDescriptor *)formSectionDescriptor; {
    [self.tableDescriptor addSection:formSectionDescriptor.sectionDescriptor];
    [self.sections addObject:formSectionDescriptor];
    formSectionDescriptor.formDescriptor = self;
    [self updateContentVisibility];
}

#pragma mark - TFTableDescriptor delegate

- (void)tableDescriptor:(TFTableDescriptor *)descriptor didSelectRow:(TFRowDescriptor *)rowDescriptor {
    TFFormBaseField *field = (TFFormBaseField *)[descriptor cellForRow:rowDescriptor];
    if ([field isKindOfClass:[TFFormBaseField class]]) {
        [field wasSelected];
    }
}
- (void)tableDescriptor:(TFTableDescriptor *)descriptor didDeselectRow:(TFRowDescriptor *)rowDescriptor {
    TFFormBaseField *field = (TFFormBaseField *)[descriptor cellForRow:rowDescriptor];
    if ([field isKindOfClass:[TFFormBaseField class]]) {
        [field wasDeselected];
    }
}



#pragma mark - Field value - getters
- (id)valueAtFieldWithTag:(NSString *)tag {
    TFRowDescriptor *rowDescriptor = [self.tableDescriptor rowForTag:tag];
    NSAssert(rowDescriptor != nil, ([NSString stringWithFormat:@"Row with tag %@ not found", tag]));
    
    return [self valueAtField:rowDescriptor.formFieldDescriptor];
}

- (id)valueAtField:(TFFormFieldDescriptor *)fieldDescriptor {
    return fieldDescriptor.value;
}

- (NSDictionary *)allValues {
    
    NSMutableDictionary *mutableDict = [@{} mutableCopy];
    
    for (TFRowDescriptor *rowDescriptor in [self.tableDescriptor allRows]) {
        if (rowDescriptor.tag) {
            id value = [self valueAtField:rowDescriptor.formFieldDescriptor];
            if (value){
                [mutableDict setObject:value forKey:rowDescriptor.tag];
            }
        }
    }
    
    return [mutableDict copy];
}

- (void)updateValueDataAtField:(TFFormFieldDescriptor *)fieldDescriptor{
    TFFormBaseField *field = (TFFormBaseField *)[self.tableDescriptor cellForRow:fieldDescriptor.rowDescriptor];
    if ([field isKindOfClass:[TFFormBaseField class]]) {
        [field updateValueData];
    }
}

#pragma mark Field value - settings
- (void)setValue:(id)value atFieldWithTag:(NSString *)tag{
    TFRowDescriptor *rowDescriptor = [self.tableDescriptor rowForTag:tag];
    NSAssert(rowDescriptor != nil, ([NSString stringWithFormat:@"Row with tag %@ not found", tag]));
    
//    TFFormBaseField *field = (TFFormBaseField *)[self.tableDescriptor cellForRow:rowDescriptor];
    NSAssert(rowDescriptor.formFieldDescriptor != nil, ([NSString stringWithFormat:@"Form field for tag %@ not found", tag]));
    
    return [self setValue:value atField:rowDescriptor.formFieldDescriptor];
}

- (void)setValue:(id)value atField:(TFFormFieldDescriptor *)fieldDescriptor{
    [self setValue:value atRow:fieldDescriptor.rowDescriptor];
}
- (void)setValue:(id)value atRow:(TFRowDescriptor *)rowDescriptor {
//    TFFormBaseField *field = (TFFormBaseField *)[self.tableDescriptor cellForRow:rowDescriptor];
//    NSAssert(field != nil, ([NSString stringWithFormat:@"Form field for tag %@ not found", field.rowDescriptor.tag]));
    
    [rowDescriptor.formFieldDescriptor setValue:value];
    [self updateValueDataAtField:rowDescriptor.formFieldDescriptor];
}


#pragma mark - Actions

- (void)triggerAction:(TFFormAction)formAction forField:(TFFormBaseField *)field{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formDescriptor:didTriggerAction:field:tag:)]) {
        [self.delegate formDescriptor:self didTriggerAction:formAction field:field.rowDescriptor.formFieldDescriptor tag:field.rowDescriptor.tag];
    }
    if (formAction == TFFormActionStateValueDidChange) {
        [self updateContentVisibility];
    }
}


#pragma mark - Visibility

- (void)updateContentVisibility{
    [self.tableDescriptor beginUpdates];
    
    for (TFSectionDescriptor *section in self.sections) {
        TFFormSectionDescriptor *formSection = section;
        if ([section isKindOfClass:[TFFormSectionDescriptor class]] && formSection.displayBlock) {
            formSection.sectionDescriptor.hidden = !formSection.displayBlock(self);
        }else formSection.sectionDescriptor.hidden = NO;
    }

    for (TFRowDescriptor *row in [self.tableDescriptor allRows]) {
        TFFormFieldDescriptor *fieldDescriptor = row.formFieldDescriptor;
        if ([fieldDescriptor isKindOfClass:[TFFormFieldDescriptor class]] && fieldDescriptor.displayBlock) {
            row.hidden = !fieldDescriptor.displayBlock(self);
        }else row.hidden = NO;
    }
    
    [self.tableDescriptor endUpdates];
}

@end




