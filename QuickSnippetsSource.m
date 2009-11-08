//
//  QuickSnippetsSource.m
//  QuickSnippets
//
//  Created by Taichiro Yoshida on 09/11/05.
//  Copyright Taichiro Yoshida 2009. All rights reserved.
//

#import <Vermilion/Vermilion.h>
#import <GTM/GTMNSString+URLArguments.h>

static NSString *const kQuickSnippetsBundleIdentifier = @"com.dataich.QuickSnippets";
static NSString *const kQuickSnippetsUrlSchemePaste = @"quicksnippets://Snippet/Paste";
static NSString *const kQuickSnippetsUrlSchemeRegist = @"quicksnippets://Snippet/Regist";
static NSString *const kQuickSnippetsPasteAction = @"com.dataich.action.QuickSnippets.Paste";
static NSString *const kQuickSnippetsRegistAction = @"com.dataich.action.QuickSnippets.Regist";

@interface QuickSnippetsSource : HGSMemorySearchSource
@end

@implementation QuickSnippetsSource

- (id)initWithConfiguration:(NSDictionary *)configuration {
  if ((self = [super initWithConfiguration:configuration])) {
    id<HGSDelegate> delegate = [[HGSPluginLoader sharedPluginLoader] delegate];
    NSString *path = [[delegate userApplicationSupportFolderForApp]
                      stringByAppendingPathComponent:kQuickSnippetsPlist];
    HGSLogDebug(@"%@", path);
    
    NSBundle *bundle = HGSGetPluginBundle();
    NSString *iconPath = [bundle pathForResource:@"paste" ofType:@"png"];
    NSImage *icon = [[NSImage alloc] initByReferencingFile:iconPath];
    
    if(path) {
      NSArray *snippets = [NSArray arrayWithContentsOfFile:path];
         
      for(NSArray *snippet in snippets) {
        NSString *key = (NSString*)[snippet objectAtIndex:0];
        NSString *name = (NSString*)[snippet objectAtIndex:1];
        HGSLogDebug(@"%@", name);
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           name,
                                           kHGSObjectAttributeNameKey,
                                           HGS_SUBTYPE(kHGSTypeText, @"quicksnippets"), kHGSObjectAttributeTypeKey,
                                           [NSString stringWithFormat:@"%@?%@", kQuickSnippetsUrlSchemePaste, name],
                                           kHGSObjectAttributeURIKey,
                                           icon,
                                           kHGSObjectAttributeIconKey,
                                           nil];
        
        HGSAction *action = [[HGSExtensionPoint actionsPoint]
                             extensionWithIdentifier:kQuickSnippetsPasteAction];
        if (action) {
          [dictionary setObject:action forKey:kHGSObjectAttributeDefaultActionKey];
        }
        
        HGSResult *result = [HGSResult resultWithDictionary:dictionary source:self];
        [self indexResult:result
                     name:key
               otherTerms:nil];
      }
    } 
    
    iconPath = [bundle pathForResource:@"regist" ofType:@"png"];
    icon = [[NSImage alloc] initByReferencingFile:iconPath];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"QuickSnippets Regist", kHGSObjectAttributeNameKey,
                                       HGS_SUBTYPE(kHGSTypeOnebox, @"quicksnippets"), kHGSObjectAttributeTypeKey,
                                       kQuickSnippetsUrlSchemeRegist, kHGSObjectAttributeURIKey,
                                       icon, kHGSObjectAttributeIconKey,
                                       nil];
    
    HGSAction *action = [[HGSExtensionPoint actionsPoint]
                         extensionWithIdentifier:kQuickSnippetsRegistAction];
    if (action) {
      [dictionary setObject:action forKey:kHGSObjectAttributeDefaultActionKey];
    }
    
    HGSResult *result = [HGSResult resultWithDictionary:dictionary source:self];
    [self indexResult:result
                 name:@"QuickSnippets"
           otherTerms:nil];
  }
  return self;
}

- (NSMutableDictionary *)archiveRepresentationForResult:(HGSResult*)result {
  return nil;
}

- (HGSResult *)resultWithArchivedRepresentation:(NSDictionary *)representation {
  return nil;
}

@end
