#include <FastMap.h>
#include <SPI.h>
#include <FastGPIO.h>

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit)) // Macro to clear a bit
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit)) // Macro to set a bit

//Reserve pins 9 (TX) and 8 (RX) for AltSoftSerial

SPISettings MCP3008(2000000, MSBFIRST, SPI_MODE0); // External ADC setup
FastMap mapper; // A faster map() function

/**
 * ADC pins and memory locations
 */
const int  CS_MCP3008      = 10;         // ADC Chip Select
const byte adc_ch0         = (0x08);     // ADC Channel 0
const byte adc_ch1         = (0x09);     // ADC Channel 1
const byte adc_ch2         = (0x0A);     // ADC Channel 2
const byte adc_ch3         = (0x0B);     // ADC Channel 3
const byte adc_ch4         = (0x0C);     // ADC Channel 4
const byte adc_ch5         = (0x0D);     // ADC Channel 5

/**
 * Shift Register pins
 */
const int dataPin = 2;  // SR-SER
const int latchPin = 3; // SR-RCK
const int clockPin = 4; // SR-SCK

/**
 * Multiplexer pins
 */
const int selectPins[3] = {5, 6, 7}; // Multiplexer controls
const int rowMap[8] = {3, 0, 1, 2, 4, 6, 7, 5}; // Translates row number to multiplexer pin

bool sendData = false;
int inputVal = 1;

void setup() {

  SPI.begin     ();
  pinMode       (CS_MCP3008, OUTPUT);
  digitalWrite  (CS_MCP3008, LOW);
  digitalWrite  (CS_MCP3008, HIGH);
  pinMode(latchPin, OUTPUT);
  digitalWrite(latchPin, HIGH);
  pinMode(dataPin, OUTPUT);
  digitalWrite(dataPin, LOW);
  pinMode(clockPin, OUTPUT);
  digitalWrite(clockPin, HIGH);
  for (int i=0; i<3; i++)
  {
    pinMode(selectPins[i], OUTPUT);
//    digitalWrite(selectPins[i], HIGH);
  }

  int pin = rowMap[1];
  FastGPIO::Pin<5>::setOutput(bitRead(pin,0)); // Select multiplexer pin
  FastGPIO::Pin<6>::setOutput(bitRead(pin,1)); // Select multiplexer pin
  FastGPIO::Pin<7>::setOutput(bitRead(pin,2)); // Select multiplexer pin

  
  Serial.begin(115200);
  delay(100);
//  Serial.write(0); // 0 indicates start of new frame
  SPI.beginTransaction (MCP3008);
  mapper.init(0, 1023, 1, 255);
  
}

void loop() {
    for (int row=0; row<24; row++) // Changing rows is slow, so it's the outer loop
    {
        int pin = rowMap[row%8];
        FastGPIO::Pin<5>::setOutput(bitRead(pin,0)); // Select multiplexer pin
        FastGPIO::Pin<6>::setOutput(bitRead(pin,1)); // Select multiplexer pin
        FastGPIO::Pin<7>::setOutput(bitRead(pin,2)); // Select multiplexer pin
  
        FastGPIO::Pin<latchPin>::setOutput(LOW);  // Send 1 high bit to the shift register chain
        FastGPIO::Pin<dataPin>::setOutput(HIGH);  // Send 1 high bit to the shift register chain
        FastGPIO::Pin<clockPin>::setOutput(LOW);  // Send 1 high bit to the shift register chain
        //delayMicroseconds(2);
        FastGPIO::Pin<clockPin>::setOutput(HIGH); // Send 1 high bit to the shift register chain
        //delayMicroseconds(2);
        FastGPIO::Pin<clockPin>::setOutput(LOW);  // Send 1 high bit to the shift register chain
        FastGPIO::Pin<dataPin>::setOutput(LOW);   // Send 1 high bit to the shift register chain
        FastGPIO::Pin<latchPin>::setOutput(HIGH); // Send 1 high bit to the shift register chain
        delayMicroseconds(300);
  //      delay(5);
        
        for (int col=0; col<24; col++) // Changing cols is fast, so it's the inner loop
        {
          inputVal = readMux(row);
          Serial.write((byte)mapper.map(inputVal)); // Actually write 1 byte to serial
          FastGPIO::Pin<latchPin>::setOutput(LOW);  // Shift shift register data 1 step
          FastGPIO::Pin<clockPin>::setOutput(HIGH); // Shift shift register data 1 step
          //delayMicroseconds(2);
          FastGPIO::Pin<latchPin>::setOutput(HIGH); // Shift shift register data 1 step
          FastGPIO::Pin<clockPin>::setOutput(LOW);  // Shift shift register data 1 step
          delayMicroseconds(300);
  //        delay(5);
        }
    }
  Serial.write(0); // Mark the beginning of the next frame
}

int readMux(int row)
{
  if (row <8)
    return adc_single_channel_read(adc_ch0);
  else if (row < 16)
    return adc_single_channel_read(adc_ch1);
  else if (row < 24)
    return adc_single_channel_read(adc_ch2);
//  else if (row < 32)
//    return adc_single_channel_read(adc_ch3);
//  else if (row < 40)
//    return adc_single_channel_read(adc_ch4);
//  else
//    return adc_single_channel_read(adc_ch5);
}

int adc_single_channel_read(byte readAddress)
{
  byte dataMSB =    0;
  byte dataLSB =    0;
  byte JUNK    = 0x00;

  
  FastGPIO::Pin<CS_MCP3008>::setOutput(LOW);
  SPI.transfer         (0x01);                                 // Start Bit
  dataMSB =            SPI.transfer(readAddress << 4) & 0x03;  // Send readAddress and receive MSB data, masked to two bits
  dataLSB =            SPI.transfer(JUNK);                     // Push junk data and get LSB byte return
  FastGPIO::Pin<CS_MCP3008>::setOutput(HIGH);
  
  return               dataMSB << 8 | dataLSB;
}
