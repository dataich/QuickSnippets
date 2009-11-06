//
//  QuickSnippetsSource.m
//  QuickSnippets
//
//  Created by Taichiro Yoshida on 09/11/05.
//  Copyright LANCARD.COM inc. 2009. All rights reserved.
//

#import <Vermilion/Vermilion.h>
#import <GTM/GTMNSString+URLArguments.h>

static NSString *const kQuickSnippetsBundleIdentifier = @"com.dataich.QuickSnippets";
static NSString *const kQuickSnippetsUrlScheme = @"quicksnippets://Snippet";
static NSString *const kQuickSnippetsPasteAction = @"com.dataich.action.QuickSnippets";
static NSString *const kQuickSnippetsPlist = @"QuickSnippets.plist";

@interface QuickSnippetsSource : HGSCallbackSearchSource
@end

@implementation QuickSnippetsSource

- (BOOL)isValidSourceForQuery:(HGSQuery *)query {
  return YES;
}

- (void)performSearchOperation:(HGSCallbackSearchOperation*)operation {
  id<HGSDelegate> delegate = [[HGSPluginLoader sharedPluginLoader] delegate];
  NSString *path = [[delegate userApplicationSupportFolderForApp]
                    stringByAppendingPathComponent:kQuickSnippetsPlist];
  HGSLogDebug(@"%@", path);

  if(path) {
    NSArray *snippets = [NSArray arrayWithContentsOfFile:path];
  
    HGSQuery *query = [operation query];
    NSString *rawQueryString = [query rawQueryString];
    NSMutableArray *results = [NSMutableArray array];
    
    NSBundle *bundle = HGSGetPluginBundle();
    NSString *iconPath = [bundle pathForResource:@"QuickSnippets" ofType:@"png"];
    NSImage *icon = [[NSImage alloc] initByReferencingFile:iconPath];
    
    for(NSArray *snippet in snippets) {
      if (([[snippet objectAtIndex:0] rangeOfString:rawQueryString]).location != NSNotFound) {
        NSString *name = (NSString*)[snippet objectAtIndex:1];
        HGSLogDebug(@"%@", name);
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    name, kHGSObjectAttributeNameKey,
                                    kHGSTypeOnebox, kHGSObjectAttributeTypeKey,
                                    kQuickSnippetsUrlScheme, kHGSObjectAttributeURIKey,
                                    icon, kHGSObjectAttributeIconKey,
                                    nil];

        HGSAction *action = [[HGSExtensionPoint actionsPoint]
                             extensionWithIdentifier:kQuickSnippetsPasteAction];
        if (action) {
          [dictionary setObject:action forKey:kHGSObjectAttributeDefaultActionKey];
        }
        
        HGSResult *result = [HGSResult resultWithDictionary:dictionary source:self];
        [results addObject:result];
      }
    }
    
    [operation setResults:results];
  }

  [operation finishQuery];
}

- (BOOL)isSearchConcurrent {
  return YES;
}

@end
