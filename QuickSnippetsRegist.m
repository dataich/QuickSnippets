//
//  QuickSnippetsRegist.m
//  QuickSnippets
//
//  Created by Taichiro Yoshida on 09/11/06.
//  Copyright LANCARD.COM inc. 2009. All rights reserved.
//

#import <Vermilion/Vermilion.h>

@interface QuickSnippetsRegist : HGSAction
@end

@implementation  QuickSnippetsRegist

- (BOOL)performWithInfo:(NSDictionary*)info {
  HGSLogDebug(@"QuickSnippetsRegist:performWithInfo");

  HGSResultArray *directObjects = [info objectForKey:kHGSActionDirectObjectsKey];
  BOOL success = NO;

  if ([directObjects count] == 1) {
    @try {
      id<HGSDelegate> delegate = [[HGSPluginLoader sharedPluginLoader] delegate];
      NSString *path = [[delegate userApplicationSupportFolderForApp]
                        stringByAppendingPathComponent:kQuickSnippetsPlist];
      
      NSString *name = [directObjects displayName];
      
      NSRange firstLineRange = [name lineRangeForRange: NSMakeRange(0, 0)];
      NSString *key = [name substringWithRange:firstLineRange];
      NSRange remainingLineRange = [name lineRangeForRange:
                                    NSMakeRange(firstLineRange.length, [name length] - firstLineRange.length)];
      NSString *value = [name substringWithRange:remainingLineRange];
      
      NSMutableArray *snippets = [NSMutableArray arrayWithContentsOfFile:path];
      [snippets addObject:[NSArray arrayWithObjects:key, value, nil]];
      [snippets writeToFile:path atomically:YES];
      
      success = YES;
    }
    @catch (NSException * e) {
      HGSLog(@"%@", [e description]);
    }
  }
  return success;
}

@end