import processing.serial.*;
import cc.arduino.*;


Arduino arduino;
float potentiometer=0;
float eSize=100;
float eColor=200;

void setup(){
size(400,400);
println(Arduino.list());
arduino = new Arduino(this, Arduino.list()[4], 57600);
}

void draw(){
background(0);
potentiometer = arduino.analogRead(0);
print("pot: ");
println(potentiometer);
eSize = map(potentiometer,0,1023,10,350);
fill(eColor,40,40);
ellipse(width/2,height/2,eSize,eSize);
}
