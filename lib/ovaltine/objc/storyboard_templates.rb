
module Ovaltine
  class StoryboardTemplates

    VIEW_CONTROLLER_DEFINITION_TEMPLATE='+(UIViewController *)instantiate{IDENTIFIER};'
    VIEW_CONTROLLER_IMPLEMENTATION_TEMPLATE='+(UIViewController *)instantiate{CAPITALIZED_IDENTIFIER} { return [[self storyboard] instantiateViewControllerWithIdentifier:{IDENTIFIER}]; }'

    STATIC_IDENTIFIER_TEMPLATE='static NSString *const {IDENTIFIER_CONSTANT_NAME} = @"{IDENTIFIER}";'
    SEGUE_DEFINITION_TEMPLATE='+(NSString *){IDENTIFIER};'
    SEGUE_IMPLEMENTATION_TEMPLATE='+(NSString *){IDENTIFIER} { return {IDENTIFIER_CONSTANT_NAME}; }'

    REUSE_DEFINITION_TEMPLATE='+(NSString *){IDENTIFIER};'
    REUSE_IMPLEMENTATION_TEMPLATE='+(NSString *){IDENTIFIER} { return {IDENTIFIER_CONSTANT_NAME}; }'
    STORYBOARD_IMPLEMENTATION_TEMPLATE='[UIStoryboard storyboardWithName:{IDENTIFIER_CONSTANT_NAME} bundle:[NSBundle mainBundle]]'
    STORYBOARD_SECTION_TITLE_TEMPLATE="/** {TITLE} */"

    HEADER_TEMPLATE='''//
// {FILENAME}
// File generated using Ovaltine

#import <Foundation/Foundation.h>

@interface {CLASS_NAME} : NSObject

+(UIStoryboard *)storyboard;

{REUSE_IDENTIFIERS}

{SEGUE_IDENTIFIERS}

{VIEW_CONTROLLERS}

@end
'''

    IMPLEMENTATION_TEMPLATE='''//
// {FILENAME}
// File generated using Ovaltine

#import <UIKit/UIKit.h>
#import "{CLASS_NAME}.h"

static UIStoryboard *_storyboard = nil;
{STATIC_VARIABLES}

@implementation {CLASS_NAME}

+(UIStoryboard *)storyboard { return _storyboard ?: (_storyboard = {STORYBOARD}); }

{REUSE_IDENTIFIERS}

{SEGUE_IDENTIFIERS}

{VIEW_CONTROLLERS}

@end
'''
  end
end