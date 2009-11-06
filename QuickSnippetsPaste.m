//
//  QuickSnippetsPaste.m
//  QuickSnippets
//
//  Created by Taichiro Yoshida on 09/11/06.
//  Copyright LANCARD.COM inc. 2009. All rights reserved.
//

#import <Vermilion/Vermilion.h>

@interface QuickSnippetsPaste : HGSAction
@end

@implementation  QuickSnippetsPaste

- (BOOL)performWithInfo:(NSDictionary*)info {
  HGSResultArray *directObjects = [info objectForKey:kHGSActionDirectObjectsKey];
  BOOL success = NO;

  if ([directObjects count] == 1) {
    CGEventSourceRef eventSourceRef = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);

    if (!eventSourceRef) {
      HGSLog(@"cannot get CGEventSourceRef");
      success = NO;
    } else {
      NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
      [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
      NSString *name = [directObjects displayName];      
      [pasteboard setString:name forType:NSStringPboardType];

      CGKeyCode vKey = 9;
      CGEventRef vKeyDown = CGEventCreateKeyboardEvent(eventSourceRef, vKey, true);
      CGEventRef vKeyUp = CGEventCreateKeyboardEvent(eventSourceRef, vKey, false);
      CGEventSetFlags(vKeyDown, kCGEventFlagMaskCommand);
      CGEventPost(kCGSessionEventTap, vKeyDown);
      CGEventPost(kCGSessionEventTap, vKeyUp);
      CFRelease(vKeyDown);
      CFRelease(vKeyUp);
      CFRelease(eventSourceRef);

      success = YES;
    }
  }
  return success;
}

@end
