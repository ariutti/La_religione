# README

## SOUNDS

Some sounds are created from the ground up:

* _organ_;

Some sound are taken from:

* WIP

## Note sull'uso dei D6T temperatura:

Il tempo di calcolo richiesto dal processing dell'immagine da parte di una singola istanza della classe D6T e BinaryImg è inferiore ai 20ms.
Tenendo in considerazione che saranno 4 dispositivi da controllare simultaneamente, siamo nell'ordinde dei 100ms.

Occorre dunque mettere a punto un qualche tipo di sistema per la corretta temporizzazione delle letture tra gli stessi sensori dal momento che il refresch rate è di 4Hz

* Omron DT6
* I2C multiplexer: [robot italy](https://www.robot-italy.com/it/adafruit-tca9548a-i2c-multiplexer.html),  [adafruit](https://learn.adafruit.com/adafruit-tca9548a-1-to-8-i2c-multiplexer-breakout/overview)

## Note sull'uso degli ultrasonici

Da una confronto è emerso che in casi come il nostro i sensori ultrasonici migliori in questi casi (detecting delle persone) sono i MaxBotix (è uno standard).
Nella situazione in cui ci troviamo (soffitto a 3m) funzioneranno bene i sensori il cui diagramma polare A e B presenta un lobo di lunghezza pari o superiore a 3m.

Quali sono i sensori maxbotix che hanno dfigura polare A di 3mt?
* XL MaxSonar MB 1200-1300 EZ0 [link:https://www.digikey.it/product-detail/it/maxbotix-inc/MB1200-000/1863-1013-ND/7896785]


