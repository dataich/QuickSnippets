//
//  QuickSnippetsWindowController.m
//
//  Created by Taichiro Yoshida on 09/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuickSnippetsWindowController.h"
#import <Vermilion/Vermilion.h>

@implementation QuickSnippetsWindowController

- (void)awakeFromNib {
  [NSApp activateIgnoringOtherApps:YES];
  NSWindow *theKeyWindow = [NSApp keyWindow];
  NSInteger keyLevel = [theKeyWindow level];
  [[self window] setLevel:keyLevel + 1];
  [[self window] makeKeyAndOrderFront:self];
  [[self window] center];
}

- (IBAction)regist:(id)sender {
  @try {
    id<HGSDelegate> delegate = [[HGSPluginLoader sharedPluginLoader] delegate];
    NSString *path = [[delegate userApplicationSupportFolderForApp]
                      stringByAppendingPathComponent:kQuickSnippetsPlist];
    
    NSString *key = [_keyTextView stringValue];
    NSString *value = [_valueTextView stringValue];
    
    unichar LSC = NSLineSeparatorCharacter;
    NSString *lineSepearator = [NSString stringWithCharacters:&LSC length: 1];
    value = [value stringByReplacingOccurrencesOfString:lineSepearator withString:@"\n"];
    
    NSMutableArray *snippets = [NSMutableArray arrayWithContentsOfFile:path];

    if([snippets count] == 0) {
      snippets = [NSMutableArray array];
    }

    NSArray *snippet = [NSArray arrayWithObjects:key, value, nil];
    [snippets addObject:snippet];
    [snippets writeToFile:path atomically:YES];

    [_label setStringValue:@"Registration is completed."];
  }
  @catch (NSException * e) {
    HGSLog(@"%@", [e description]);
  }
  
  [_keyTextView setStringValue:@""];
  [_valueTextView setStringValue:@""];
  
  [[self window] makeFirstResponder:_keyTextView];
}

@end
