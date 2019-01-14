#!/bin/bash


mkdir /sys/kernel/config/usb_gadget/js$1
cd /sys/kernel/config/usb_gadget/js$1

echo 0x0100 > bcdDevice
echo 0x0200 > bcdUSB
echo 0x00 > bDeviceClass
echo 0x00 > bDeviceProtocol
echo 0x00 > bDeviceSubClass
echo 0x10 > bMaxPacketSize0
echo 0x0104 > idProduct
echo 0x1d6b > idVendor

mkdir strings/0x409

echo "Nintendo" > strings/0x409/manufacturer
echo "N64 Controllers" > strings/0x409/product
echo "64" > strings/0x409/serialnumber

mkdir configs/c.1
mkdir configs/c.1/strings/0x409

echo 0x80 > configs/c.1/bmAttributes
echo 500 > configs/c.1/MaxPower
echo "N64 Controllers" > configs/c.1/strings/0x409/configuration

create_joystick()
{
	mkdir functions/hid.usb$1

	echo 0 > functions/hid.usb$1/protocol
	echo 10 > functions/hid.usb$1/report_length
	echo 0 > functions/hid.usb$1/subclass
	echo -ne \\x05\\x01\\x09\\x05\\xa1\\x01\\x75\\x10\\x16\\x00\\x80\\x26\\xff\\x7f\\x36\\x00\\x80\\x46\\xff\\x7f\\x09\\x01\\xa1\\x00\\x95\\x02\\x09\\x30\\x09\\x31\\x81\\x02\\xc0\\x09\\x01\\xa1\\x00\\x95\\x02\\x09\\x33\\x09\\x34\\x81\\x02\\xc0\\x05\\x09\\x19\\x01\\x29\\x10\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x10\\x81\\x02\\xc0 > functions/hid.usb$1/report_desc

	ln -s functions/hid.usb$1 configs/c.1
}

create_joystick 0
create_joystick 1
create_joystick 2
create_joystick 3

ls /sys/class/udc > UDC
