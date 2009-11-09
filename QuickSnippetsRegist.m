//
//  QuickSnippetsRegist.m
//  QuickSnippets
//
//  Created by Taichiro Yoshida on 09/11/06.
//  Copyright Taichiro Yoshida 2009. All rights reserved.
//

#import <Vermilion/Vermilion.h>

@interface QuickSnippetsRegist : HGSAction {
}

@end

@implementation  QuickSnippetsRegist

- (BOOL)performWithInfo:(NSDictionary*)info {
  NSBundle *bundle = HGSGetPluginBundle();
  NSString *nibPath = [bundle pathForResource:@"QuickSnippets" ofType:@"nib"];
  NSWindowController *controller = [[NSWindowController alloc] initWithWindowNibPath:nibPath owner:self];
  
  [controller showWindow:self];
  
  return YES;
}

- (BOOL)appliesToResult:(HGSResult *)result {
  return NO;  
}

- (BOOL)appliesToResults:(HGSResultArray *)results {
  return NO;
}

@end
