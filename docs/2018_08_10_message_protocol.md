# README

In order for VVVV to set different Threshold for each sensor a new message protocol has been designed.

Here all the messages VVVV can send to Arduino:

## SET THRESHOLD (single sensor)

This message will set the distance threshold for each individual sensor.

Message starts with a capital 'S' followed by the sensor index (from 0 to 7). A comma and the threshold value. The message is terminated by a semicolon ';'.

Example:

	S1,245; will set the second sensor (index 1) threshold to 245;
	S5,342; will set the sixth sensor (index 5) threshold to 342;

## SET THRESHOLD (for all the sensors simultaneously)

This message will set the same threshold for all the sonsors simultaneously;

Message starts with a capital 'A' followed by a comma and the threshold value. The message is terminated by a semicolon ';'.

Example:

	SA,128; will set threshold to 128 for all the sensors;

## SERIAL COMMUNCATION ON/OFF

This message will cause Arduino to start/finish sending messages via serial.

Message starts with one or zero to respectively start/finish receiving responses from Arduino.

Example:

	1; will turn communication on;
	0; will turn communication off;

Responses can be differnet accoding to the selected operatoin mode (see below).

## DEBUG MODE

This message will cause Arduino to send a more verbose serial output.

The message is made of a capital 'D' and a final semicolon.

Example:

	D; - will set Debug operational mode;

The response from Arduino will be made of 3 numerical values for each sensors. Values are comma separated, and the message is terminated with a semicolon.

Here's the meanimg of each of these three values:

1. distance read by the sensor;
2. threshold of the sensor;
3. boolean value representing presence/absence of people below the sensor;

Presence/absence is calculated with the following formula:

	if( distance < threshold ) presence = true;
	else presence = false;

Response example (using 2 sensors):

	30,150,1,379,170,0;

First sensor is reding a distance of 30 which is less than the threshold of 150 so presence for the sensor is 1. Second sensor is reading 379 which is more than the sensor threshold (170) so presence is 0 for this sensor.

Note: Setting Debug Mode will automatically turn serial communication on.

## PRESENCE ONLY MODE

This message will cause Arduino to send a less verbose serial output.

The message is made of a capital 'P' and a final semicolon.

Example:

	P; - will set Presence only operational mode;

The response from Arduino will be made of one single value for each sensor representing presence/absence of people below the sensor (0 and 1 respectively).

Response example (using 2 sensors):

	01; - first sensor reading no presence. Second one instead is reading a presence.

Note: Setting Presence Only Mode will automatically turn serial communication on.
