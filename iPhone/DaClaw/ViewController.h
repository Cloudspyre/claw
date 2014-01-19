// The MIT License (MIT)
//
// Copyright (c) 2013-2014 Cloudspyre, LLC and Atlantic Apps, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
//  ViewController.h
//  DaClaw
//
//  Created by Stephen Jernigan on 12/12/13.
//  Copyright (c) 2013 Stephen Jernigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

#define BUFFER_LEN 1024


@interface ViewController : UIViewController<UIAccelerometerDelegate, BLEDelegate> {

    IBOutlet UILabel *xlabel;
    IBOutlet UILabel *ylabel;
    IBOutlet UILabel *clawlabel;
    IBOutlet UIButton *btnConnect;
    
    IBOutlet UITextView *serialView;
    IBOutlet UILabel *lblConnectButton;
    IBOutlet UIActivityIndicatorView *indConnecting;

}

@property (strong, nonatomic) BLE *ble;
@property NSInteger x;
@property NSInteger y;
@property NSInteger distance;
@property (strong, nonatomic) NSMutableData *responseData;

- (IBAction)sendEmail;
- (IBAction)btnScanForPeripherals:(id)sender;

@end
