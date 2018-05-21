# README

## Note

Il tempo di calcolo richiesto dal processing dell'immagine da parte di una singola istanza della classe D6T e BinaryImg è inferiore ai 20ms.
Tenendo in considerazione che saranno 4 dispositivi da controllare simultaneamente, siamo nell'ordinde dei 100ms.

Occorre dunque mettere a punto un qualche tipo di sistema per la corretta temporizzazione delle letture tra gli stessi sensori dal momento che il refresch rate è di 4Hz

* Omron DT6
* I2C multiplexer: [robot italy](https://www.robot-italy.com/it/adafruit-tca9548a-i2c-multiplexer.html),  [adafruit](https://learn.adafruit.com/adafruit-tca9548a-1-to-8-i2c-multiplexer-breakout/overview)
