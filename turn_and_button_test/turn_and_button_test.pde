//import the libraries for serial communication
//and for arduino/firmata specifically
//and firmata
import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;
import cc.arduino.*;
 
//this object represents your board
Arduino arduino;
//this is the minim environment
Minim minim;
AudioOutput   out;
Oscil         osc;
Multiplier    multiplier;

 
//this is the object that plays your file
AudioPlayer player;
AudioPlayer player2;
 
//like in an arduino sketch it's good to
//use variables for pin numbers 
int sensorPin = 0;
//float potentiometer=0;

int photosensorPin = 7;
 
//this is the minimum value from the sensor that will trigger the sound
int threshold = 360;
int threshold2 = 1;

float potentiometer=0;

 
void setup()
{
  size(640, 200);
 
  //the arduino object needs to be created at the beginning
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[4], 57600);
 
  //once it's created I set the pin modes  
  arduino.pinMode(sensorPin, Arduino.INPUT);
  arduino.pinMode(photosensorPin, Arduino.INPUT);

 
  //initialize minim
  minim = new Minim(this);
 
 
  // get a line out from Minim. It's important that the file is the same audio format 
  // as our output (i.e. same sample rate, number of channels, etc).
  out = minim.getLineOut();
  
  osc = new Oscil( 440, 1 );
  multiplier = new Multiplier( 0.5f );
  
  // normally we wouldn't use a multiplier with an Oscil like this
  // because we could simply set the amplitude of the Oscil itself.
  osc.patch( multiplier ).patch( out );
  
  
  
  // loadFile will look for a file in the data folder
  // mp3, wav, ogg should all work
//  player = minim.loadFile("chime.wav");
 //player2 = minim.loadFile("cymbals.wav");
}
 
void draw()
{
  potentiometer = arduino.analogRead(0);

  // map the mouse position to a new value for the multiplier
  float value = map(potentiometer,0,1023,0,1);
  
  // set the new value.
  // this is equivalent to multiplier.amplitude.setLastValue( value )
  // you'll also notice this causes audible clicks if you move the mouse quickly
  // to keep that from happening, you will usually want to use a Line patched 
  // to the Multiplier's amplitude input.
  multiplier.setValue( value );
  
  // erase the window to black
  background( 0 );
  // draw using a white stroke
  stroke( 255 );
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }   
//  //read an analog value from the sensor pin
//  int analogValue =  arduino.analogRead(sensorPin);
//  println(analogValue); //print it for testing purposes
// 
//  //check if the reproduction is in process if not don't trigger another sound
//  if ( player.isPlaying() == false && analogValue > threshold)
//  {
//    //it's weird but you have to rewind a file to play it
//    player.rewind();
//    player.play();
//  }

//    //read an analog value from the sensor pin
//  int photoanalogValue =  arduino.digitalRead(photosensorPin);
//  println(photoanalogValue); //print it for testing purposes
//  //check if the reproduction is in process if not don't trigger another sound
//  if ( player2.isPlaying() == false && photoanalogValue < threshold2)
//  {
//    //it's weird but you have to rewind a file to play it
//    player2.rewind();
//    player2.play();
//  }
}
 
//stop is called when you hit stop on processing. Just leave this here
void stop()
{
 // player.close();
  minim.stop();
 // player2.close();
//  minim2.stop();
  super.stop();
}
