//
//  QuickSnippetsWindowController.m
//
//  Created by Taichiro Yoshida on 09/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuickSnippetsWindowController.h"
#import <Vermilion/Vermilion.h>

@implementation QuickSnippetsWindowController

- (IBAction)cancel:(id)sender {
  [self close];
  [self release];
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

    [_label setStringValue:@"Registration succeed."];
  }
  @catch (NSException * e) {
    HGSLog(@"%@", [e description]);
  }
  
  [_keyTextView setStringValue:@""];
  [_valueTextView setStringValue:@""];
  
  [[self window] makeFirstResponder:_keyTextView];
}

@end
