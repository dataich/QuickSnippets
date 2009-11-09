//
//  QuickSnippetsWindowController.h
//
//  Created by Taichiro Yoshida on 09/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QuickSnippetsWindowController : NSWindowController {
  IBOutlet id _label;
  IBOutlet id _keyTextView;
  IBOutlet id _valueTextView;
}

- (IBAction)cancel:(id)sender;
- (IBAction)regist:(id)sender;

@end
