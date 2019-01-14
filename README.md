# RaspberryPiZeroN64JoystickDriver
This tool allows an Raspberry Pi Zero configured with the gamecon_gpio_rpi driver available at https://github.com/marqs85/gamecon_gpio_rpi/ to emulate four game controllers.

## Setup  
I used an RPi Zero W. I flashed Raspbian and connected it to my wifi to configure it by writing the wpa_supplicant.conf and ssh files to the boot partition.

## Wiring  
I connected all four controllers to pin 1 for VCC and pin 6 for ground. Here are the pins the data lines connect to:

```
Player 1 - Pin 27
Player 2 - Pin 28
Player 3 - Pin 7
Player 4 - Pin 26
```

Official Nintendo cables use Red for VCC, Black for Ground, and Green for Data. I also have a third-party cable that does NOT follow this spec, and instead uses Black for VCC, White for Ground, and Red for Data.

I put the files in `/opt/n64` . If you want to put them somewhere else edit the paths in `n64.service` and `start.sh`.

Copy `n64.service` to `/etc/systemd/system` and run
```
systemctl enable n64
systemctl start n64
```
The service doesn't support stopping, if you want to reload it you'll have to reboot.

## Usage  
Once it's set up to auto-start and the controllers are wired you can plug just the USB port to the host and it'll get power off it too.
It shows up on the host as four normal USB gamepads. I have tested it on my PC and on another RPi running RetroPie.


## Description  
This tool uses the Raspberry Pi's USB Gadget mode to emulate four USB gamepads with an analog stick, two more axis for the DPAD, and all buttons.  
The gamepads currently have 16 buttons instead of 10, I was unable to get the HID descriptors to work with the padding bytes in there for 10. Buttons 11-16 can't be pressed.

### n64.service  
Configures systemd to run `start.sh`.

### start.sh  
Loads the gamecon_gpio_rpi driver, calls the script that configures the USB gadget, then runs `joy1.py` through `joy4.py` in screen sessions.

### create_joysticks.sh  
Initializes the gadget, adds 4 HID devices for each controller. 

Here is the HID descriptor I used:
```
char ReportDescriptor[63] = {
    0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
    0x09, 0x05,                    // USAGE (Game Pad)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x75, 0x10,                    //   REPORT_SIZE (16)
    0x16, 0x00, 0x80,              //   LOGICAL_MINIMUM (-32768)
    0x26, 0xff, 0x7f,              //   LOGICAL_MAXIMUM (32767)
    0x36, 0x00, 0x80,              //   PHYSICAL_MINIMUM (-32768)
    0x46, 0xff, 0x7f,              //   PHYSICAL_MAXIMUM (32767)
    0x09, 0x01,                    //   USAGE (Pointer)
    0xa1, 0x00,                    //   COLLECTION (Physical)
    0x95, 0x02,                    //     REPORT_COUNT (2)
    0x09, 0x30,                    //     USAGE (X)
    0x09, 0x31,                    //     USAGE (Y)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0xc0,                          //   END_COLLECTION
    0x09, 0x01,                    //   USAGE (Pointer)
    0xa1, 0x00,                    //   COLLECTION (Physical)
    0x95, 0x02,                    //     REPORT_COUNT (2)
    0x09, 0x33,                    //     USAGE (Rx)
    0x09, 0x34,                    //     USAGE (Ry)
    0x81, 0x02,                    //     INPUT (Data,Var,Abs)
    0xc0,                          //   END_COLLECTION
    0x05, 0x09,                    //   USAGE_PAGE (Button)
    0x19, 0x01,                    //   USAGE_MINIMUM (Button 1)
    0x29, 0x10,                    //   USAGE_MAXIMUM (Button 16)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x25, 0x01,                    //   LOGICAL_MAXIMUM (1)
    0x75, 0x01,                    //   REPORT_SIZE (1)
    0x95, 0x10,                    //   REPORT_COUNT (16)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)
    0xc0                           // END_COLLECTION
};
```

### joyX.py  
Listens for input from the gamecon driver at `/dev/input/jsX`, unpacks the struct, tracks buttons/axis, repacks the struct into the format that the HID device needs, outputs the HID device's output to `/dev/hidgX`

## Project  
I took a 5"x3"x1.5" project box, drilled holes on the long faces on the sides  
 1 on the rear at the dead center  
 4 on the front, centered vertically, at 1" spacing  
5 rubber wire grommets in each hole to cover the cuts/prevent cable wear  
4 N64 extension cables with the male ends cut off ran out of the front holes. I soldered the pins I needed onto the RPi and and soldered/heat shrunk all of the controller connections together.  
 I tied knots on the extension cables so they can't get pulled through.  
I cut a 10' USB Micro cable, ran it through the hole on the back, and soldered/heat shrunk the cable back together. I also tied a knot in this cable.  

Once that was done I tested that the controllers were working and screwed the box together.  
