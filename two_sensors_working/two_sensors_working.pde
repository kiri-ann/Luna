//import the libraries for serial communication
//and for arduino/firmata specifically
//and firmata
import ddf.minim.*;
import processing.serial.*;
import cc.arduino.*;
 
//this object represents your board
Arduino arduino;
//this is the minim environment
Minim minim;
//Minim minim2;

 
//this is the object that plays your file
AudioPlayer player;
AudioPlayer player2;
 
//like in an arduino sketch it's good to
//use variables for pin numbers 
int sensorPin = 0;
int photosensorPin = 7;
 
//this is the minimum value from the sensor that will trigger the sound
int threshold = 360;
int threshold2 = 1;

 
void setup()
{
  size(300, 300);
 
  //the arduino object needs to be created at the beginning
  arduino = new Arduino(this, Arduino.list()[4], 57600);
 
  //once it's created I set the pin modes  
  arduino.pinMode(sensorPin, Arduino.INPUT);
  arduino.pinMode(photosensorPin, Arduino.INPUT);

 
  //initialize minim
  minim = new Minim(this);
//  minim2 = new Minim(this);
 
  // loadFile will look for a file in the data folder
  // mp3, wav, ogg should all work
  player = minim.loadFile("chime.wav");
 player2 = minim.loadFile("cymbals.wav");
}
 
void draw()
{
  background(0);
 
  //read an analog value from the sensor pin
  int analogValue =  arduino.analogRead(sensorPin);
  println(analogValue); //print it for testing purposes
 
  //check if the reproduction is in process if not don't trigger another sound
  if ( player.isPlaying() == false && analogValue > threshold)
  {
    //it's weird but you have to rewind a file to play it
    player.rewind();
    player.play();
  }

    //read an analog value from the sensor pin
  int photoanalogValue =  arduino.digitalRead(photosensorPin);
  println(photoanalogValue); //print it for testing purposes
  //check if the reproduction is in process if not don't trigger another sound
  if ( player2.isPlaying() == false && photoanalogValue < threshold2)
  {
    //it's weird but you have to rewind a file to play it
    player2.rewind();
    player2.play();
  }
}
 
//stop is called when you hit stop on processing. Just leave this here
void stop()
{
  player.close();
  minim.stop();
  player2.close();
//  minim2.stop();
  super.stop();
}
