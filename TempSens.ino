
#include <OneWire.h>
#include <DallasTemperature.h>
 
// Data wire is plugged into pin 2 on the Arduino
#define ONE_WIRE_BUS 2
 
// Setup a oneWire instance to communicate with any OneWire devices 
// (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);
 
// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);
unsigned long previousMillis = 0;// will store last time was updated
const long interval = 299999; // interval (milliseconds)
                            // 60000 = 1 min
                            // 5 mins = 300000
 
void setup(void)
{
  Serial.begin(9600);
  sensors.begin();
  sensors.requestTemperatures(); // Send the command to get temperatures
  Serial.println(sensors.getTempFByIndex(0));
}
 
 
void loop(void)
{
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval)
  {
     previousMillis = currentMillis; 
     sensors.requestTemperatures(); // Send the command to get temperatures
      Serial.println(sensors.getTempFByIndex(0));
  }
  
}
