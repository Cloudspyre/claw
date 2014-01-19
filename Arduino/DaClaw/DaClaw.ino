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


#include <Servo.h>
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>
#include "Boards.h"


Servo servo1;
Servo servo2;
Servo servo3;

/* Values used for Lift */
int min1 = 80;
int max1 = 150;
int mid1 = 70;

/* Values used for claw */
int min2 = 15;
int max2 = 145;
int mid2 = 90;

/* Values used for rotation */
int minpoint3 = 20;
int maxpoint3 = 180;
int midpoint3 = 180;

void setup()
{

SPI.setDataMode(SPI_MODE0);
SPI.setBitOrder(LSBFIRST);
SPI.setClockDivider(SPI_CLOCK_DIV16);
SPI.begin();

ble_begin();


servo1.attach(2); // Lift and Lower
servo2.attach(3); // Claw
servo3.attach(4); // Left/Right

//  Serial.begin(9600); 
//  Serial.println("XXXhello");

}

void loop()
{
static boolean analog_enabled = false;
static byte old_state = LOW;


while(ble_available())
{
// read out command and data
byte data0 = ble_read();
byte data1 = ble_read();
byte data2 = ble_read();

if (data0 == 0x01)  // Command is to control digital out pin
{
int value1 = (int)data1; 

value1 = value1 * 1.3;
value1 = value1 + 20; 

servo3.write(value1);  

}
else if (data0 == 0x02) // Command is to LIFT AND LOWER CLAW.

{
 // Serial.println("Command 2 received");

  int value1 = (int)data1;

  value1 = value1 * 0.707070;
  value1 = value1 + 80;

  servo1.write(value1);

}
else if (data0 == 0x03) // Command to move Claw open/closed positions.
{

//      Serial.println("Command 3 received");

int value1 = (int)data1;

value1 = value1 * 1.31;
value1 = value1 + 15;

servo2.write(value1);

}
else if (data0 == 0x04) // Command is to enable analog in reading
{

//    digitalWrite(LEFT_OUT_PIN, LOW);
//    digitalWrite(RIGHT_OUT_PIN, LOW);

}
}

if (!ble_connected())
{
analog_enabled = false;
//    digitalWrite(LEFT_OUT_PIN, LOW);
//    digitalWrite(RIGHT_OUT_PIN, LOW);
}

// Allow BLE Shield to send/receive data
ble_do_events(); 
}  
