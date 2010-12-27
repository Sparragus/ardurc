#include "LCD_Driver.h"
#include "LCD_Pins.h"
#include "LCD_Geometry.h"

#include "arduRC_states.h"
#include "arduRC_controller.h"

#include <stdio.h>

#include <Math.h>
#include <Wire.h>

#define __DEBUG 

#define BUTTON_LEFT 2
#define BUTTON_RIGHT 3
#define BUTTON_CONTROL 18
#define BUTTON_PICTURE 19

#define LEFT 0
#define RIGHT 1

#define throttle_pot_in A0
#define throttle_led 7

#define signal_rssi A1
#define signal_led_red 41  //
#define signal_led_green 39 //7
#define signal_led_blue 37 //

#define batt_status_in A2
#define batt_led_red 40 //
#define batt_led_green 38 //
#define batt_led_blue 36 //

#define SDA 20
#define SDL 21

#define gyro_data_size 8

#define gyroAddr 0x69 //Gyro address is either 0x68 or 0x69.

#ifdef __DEBUG
int states[] = {MAIN, SPEED, DEBUG};
#else
int states[] = {MAIN, SPEED, ALTITUDE, GPS, TEMP, DEBUG};
#endif

int statesLen = sizeof(states)/sizeof(int);
int currentState = states[0];
int oldState = currentState; 
//int oldState = 1; 
int currentStatePos = 0;

//gyro variables
const float samplingtime = 1000.0; //milliseconds
const float synctime = 100.0; //milliseconds
boolean gyro_toggle = false;
float pitch = 0;
float yaw = 0;
float roll = 0;
int temperature = 0;

//Previous values for Runge-Kutta integration algorithm.
float pitchvel[4];
float yawvel[4];
float rollvel[4];

//status variables
int batt_status = 0;
int signal_status = 0;
int throttle_status = 0;

int throttle_value = 0;
int throttle_value_mapped = 0;

boolean armed_motors = false;

boolean sendNavInfo = false;

char navCommandNotArmed[27];

void setup()
{
	Wire.begin();
	
	//Initializes Serial comunication
	initSerial();

	// Initializes gyro 
	initGyro();
	
	// Initializes IO pins
	ioInit();
	
	// Timer Inits
	timer1init();
	timer3init();

	// Init LCD
	LCDInit();
	LCDClear(WHITE);
	
	//LCDSplashScreen();
	

	/**
#ifdef __DEBUG
	//char someString[] = "another string!";
	//printString(someString, 10, 10);

	Serial.println("Screen test: Started!");

	//SetPixel - OKAY
	LCDSetPixel(RED, ROW_LENGTH/2, COL_HEIGHT/2 - 10); // North
	LCDSetPixel(RED, ROW_LENGTH/2 + 10, COL_HEIGHT/2); // East
	LCDSetPixel(RED, ROW_LENGTH/2, COL_HEIGHT/2 + 10); // South
	LCDSetPixel(RED, ROW_LENGTH/2 - 10, COL_HEIGHT/2); // West

	//SetLine - OKAY
	LCDSetLine(ROW_LENGTH/2 - 15, COL_HEIGHT/2 - 15, ROW_LENGTH/2 + 15, COL_HEIGHT/2 + 15, BLACK);
	LCDSetLine(ROW_LENGTH/2 + 15, COL_HEIGHT/2 - 15, ROW_LENGTH/2 - 15, COL_HEIGHT/2 + 15, RED);

	//SetRect, NOFILL - OKAY
	LCDSetRect(ROW_LENGTH/2 - 20, COL_HEIGHT/2 - 20, 20*2, 20*2, NOFILL, ORANGE);

	//SetRect, FILL - OKAY
	LCDSetRect(ROW_LENGTH/2 - 5, COL_HEIGHT/2 - 35, 5*2, 5*2, FILL, GREEN);
	LCDSetRect(ROW_LENGTH/2 + 25, COL_HEIGHT/2 - 5, 5*2, 5*2, FILL, BLUE);
	LCDSetRect(ROW_LENGTH/2 - 5, COL_HEIGHT/2 + 25, 5*2, 5*2, FILL, YELLOW);
	LCDSetRect(ROW_LENGTH/2 - 35, COL_HEIGHT/2 - 5, 5*2, 5*2, FILL, RED);


	// PutChar - OKAY
	// * should be on the right
	LCDPutChar('*', ROW_LENGTH - 5*8, COL_HEIGHT - 16*2, LARGE, BLACK, WHITE);
	// # should be on the left
	LCDPutChar('#', 2 + 4*8 - 1*8, COL_HEIGHT - 16*2, LARGE, BLACK, WHITE);

	// PutStr - OKAY
	LCDPutStr("RIGHT", ROW_LENGTH - 5*8, COL_HEIGHT - 16, LARGE, BLACK, WHITE);
	LCDPutStr("LEFT", 2, COL_HEIGHT - 16, LARGE, BLACK, WHITE);

	Serial.println("Screen test: Finished!");
	delay(500);

	//Serial.println("MVC test: Started!");
	//currentState = DEBUG;
	//controller(currentState);
	//Serial.println("MVC test: Finished!");

#endif
**/

}

void loop()
{

	if (stateChanged())
	{
		controller(currentState, true);
	}
	else
	{
		controller(currentState, false);
	}

	/*
	if( gyro_toggle ){
		getGyroData();
		gyro_toggle = false;
	}
	*/

	throttle();
	batteryStatus();
	signalStatus();
	
	//throttle_status = map(analogRead(throttle_pot_in), 0, 1023, 255, 0); 
	//analogWrite(throttle_led,throttle_status);
	//Serial.println(throttle_status);
	
}


void LCDSplashScreen(){

	//int xSize = 128+4;
	//int ySize = 128;
	
	int xSize = ROW_LENGTH;
	int ySize = COL_HEIGHT-4;
	
	
	// void LCDSetLine(int x0, int y0, int x1, int y1, int color);
	
	
	// LCDSetRect(32,32,10,10,FILL,BLUE); -- RC

	LCDSetRect( (xSize/4) , (ySize/2), ((3*xSize)/4) - (xSize/4) , (((3*ySize)/4) - (ySize/4))/2, FILL, BLUE );
	
	// LCDSetRect( x , y ,  width ,  height , FILL, BLUE ); -- ANTENA

	LCDSetRect(  ((3*xSize)/4) - 4   , 32 ,  4 ,  32 , FILL, BLACK );

	// Draw Antenna Signals
	LCDSplashScreen_Antenna_Signal();
	
	// LCDPutStr(char *pString, int x, int y, int Size, int fColor, int bColor) -- TEXT

	LCDPutStr(" ArduRC",  (xSize/4)+1 ,  (ySize/4)+((3*ySize)/8) , LARGE, WHITE, BLUE);
	
	LCDSplashScreen_Flash_Init(8, 500, 250);	
}

void LCDSplashScreen_Flash_Init(int flash_times, int delay_text, int delay_blank)
{
	for(int i = 0; i < flash_times; i++){
		LCDPutStr("Initializing...",  7 ,  110 , LARGE, BLACK, WHITE);
		delay(delay_text);
		LCDPutStr("               ",  7 ,  110 , LARGE, BLACK, WHITE);
		delay(delay_blank);
	}
}

void LCDSplashScreen_Antenna_Signal()
{
	// Give width to line
	
	int delay_time = 150;
	
	for(int i = 0; i < 5; i++)
	{
		LCDSetLine( ((3*ROW_LENGTH)/4) - 4 + i , 30, ROW_LENGTH/2 + 12*0 + i, 18, RED);
		delay(delay_time);
		LCDSetLine( ((3*ROW_LENGTH)/4) - 4 + i , 30, ROW_LENGTH/2 + 12*1 + i, 18, RED);
		delay(delay_time);
		LCDSetLine( ((3*ROW_LENGTH)/4) - 4 + i , 30, ROW_LENGTH/2 + 12*2 + i, 18, RED);
		delay(delay_time);
		LCDSetLine( ((3*ROW_LENGTH)/4) - 4 + i , 30, ROW_LENGTH/2 + 12*3 + i, 18, RED);
		delay(delay_time);
		LCDSetLine( ((3*ROW_LENGTH)/4) - 4 + i , 30, ROW_LENGTH/2 + 12*4 + i, 18, RED);
		delay(delay_time);
	}	
}

//timer function, it runs every 1 second
ISR(TIMER1_OVF_vect) {
	//Serial.println("timer1");
	//TCNT1=0x0BDC;  // set initial value for one second
	TCNT1 = 0xFFFF - (samplingtime/0.016);
	gyro_toggle = true;
}

ISR(TIMER3_OVF_vect) {
	//Serial.println("timer3");
	TCNT3=0xFFFF - (synctime/0.016);
	//here we will send control data to the copter via xbee
	
		
	//if(sendNavInfo)
	if(false)
	{

	}
	else
	{
		//Send default values:
		// Roll, Pitch;Yaw;Aux1HIGH;Aux3_1200;Aux2LOW;Throttle
		
		//If not armed
		if(!armed_motors)
		{	
			sprintf(navCommandNotArmed, "V1545;1500;1498;2003;994;1200;%d", throttle_value_mapped);
		}
		else
		{
			sprintf(navCommandNotArmed, "V1545;1500;1498;2003;994;1400;%d", throttle_value_mapped);
		}
		
			// Serial.print("NavCommand: ");
			// Serial.println(navCommandNotArmed);
			
			// Serial3.println(navCommandNotArmed);
	}
}

void getGyroData(){

	Wire.beginTransmission(gyroAddr); 
	Wire.send(0x1B); //Set to the first sensor register.
	Wire.endTransmission();
	
	delayMicroseconds(500); //Wait for the transmission to complete.

	Wire.requestFrom(gyroAddr, gyro_data_size); //Get the sensors output.
	
	delayMicroseconds(500); //Wait for the bytes to arrive.  
	
	Serial.println("Waiting for sensors data... ");

	while(Wire.available() < gyro_data_size);

	if(8 <= Wire.available()){
		
		//Get the temperature reading.
		temperature = Wire.receive();
		temperature = temperature << 8;
		temperature |= Wire.receive(); 
		
		//Convert this reading to degrees Celsius.
		temperature = 35.0 + ((temperature + 13200) / 280.0);
		
		//Remove one of the old readings for each axis.
		for(int i = 1; i < 4; i++){
			pitchvel[i-1] = pitchvel[i];
			yawvel[i-1] = yawvel[i];
			rollvel[i-1] = rollvel[i];
		}
		
		//Get the angular velocity of the x axis.
		int x = Wire.receive();
		x = x << 8;
		x |= Wire.receive();
		pitchvel[3] = (float) x / 14.375;

		//Get the angular velocity of the y axis.
		int y = Wire.receive();
		y = y << 8;
		y |= Wire.receive();
		rollvel[3] = (float) y / 14.375;

		//Get the angular velocity of the z axis.
		int z = Wire.receive();
		z = z << 8;
		z |= Wire.receive();
		yawvel[3] = (float) z / 14.375;

		//Convert x, y, z to pitch, yaw and roll.
		pitch = pitch + samplingtime * (pitchvel[0] + pitchvel[1] + pitchvel[2] + pitchvel[3]) / 6.0;
		yaw = yaw + samplingtime * (yawvel[0] + yawvel[1] + yawvel[2] + yawvel[3]) / 6.0;
		roll = pitch + samplingtime * (rollvel[0] + rollvel[1] + rollvel[2] + rollvel[3]) / 6.0;

		//Limit to 0-359 degrees.
		pitch = fmod(pitch, 360.0);
		yaw = fmod(yaw, 360.0);
		roll = fmod(roll, 360.0);

		Serial.println(pitch, DEC);
		Serial.println(yaw, DEC);
		Serial.println(roll, DEC);		
	}

	else{ 
		Serial.println("No info was found.");
	}
}

void batteryStatus()
{
	
	batt_status = map(analogRead(batt_status_in),0,1023,0,3);
	

	
	if(batt_status == 3){
		digitalWrite(batt_led_red, LOW);
		digitalWrite(batt_led_green, HIGH);
		digitalWrite(batt_led_blue, LOW);
	} 

	else if(batt_status == 2){
		digitalWrite(batt_led_red, LOW);
		digitalWrite(batt_led_green, LOW);
		digitalWrite(batt_led_blue, HIGH);
	} 
	else if  (batt_status <= 1 ){
		//else{
		digitalWrite(batt_led_red, HIGH);
		digitalWrite(batt_led_green, LOW);
		digitalWrite(batt_led_blue, LOW);
	} 

}

void signalStatus()
{
	signal_status = pulseIn(signal_rssi, LOW, 200);

	if(signal_status <= 35){ //high
		digitalWrite(signal_led_red, LOW);
		digitalWrite(signal_led_green, HIGH);
		digitalWrite(signal_led_blue, LOW);
	}
	else if(signal_status > 35 && signal_status < 39){ //medium
		digitalWrite(signal_led_red, LOW);
		digitalWrite(signal_led_green, LOW);
		digitalWrite(signal_led_blue, HIGH);
	}
	if(signal_status >= 39){ //low
		//else{
		digitalWrite(signal_led_red, HIGH);
		digitalWrite(signal_led_green, LOW);
		digitalWrite(signal_led_blue, LOW);
	}
} 


void throttle(){
	throttle_value = analogRead(throttle_pot_in);
	
	// Send throttle values to ArduCopter
	throttle_value_mapped = map(throttle_value, 0, 1023, 1091,1895); 
	
	//throttle_led_func(throttle_value);
}

void throttle_led_func(int throttle_value){
	throttle_status = map(throttle_value, 0, 1023, 0, 255); 
	analogWrite(throttle_led,throttle_status);
}


bool stateChanged()
{
	if (oldState == currentState)
	{
		return false;
	}
	oldState = currentState;
	return true;
}

void initSerial(){

	Serial.begin(9600);
	Serial.println("Initialized Serial0!");

	Serial3.begin(115200);
	Serial3.println("Initialized Serial3!");

}

void initGyro(){

	for(int i = 0; i < 3; i++){
		pitchvel[i] = 0;
		yawvel[i] = 0;
		rollvel[i] = 0;
	}

	Wire.beginTransmission(gyroAddr);
	Wire.send(0x15); //Set which gyro register to update.
	Wire.send(0x00); //Set Sample Rate divider to 0.
	//Wire.send(0x18); //Set Low Pass Filter Bandwidth to 256 Hz and Sampling rate to 8 kHz.
	//Wire.send(0x01); //Set the interrupt pin to turn on when there is data available.
	//Wire.send(0x00); //Disable the interrupt pin.
	Wire.endTransmission();
	delay(10);

}

void ioInit()
{
#ifdef _USE_ARDUINO_FOR_NOKIA_
	// IOInit the LCD control lines
	pinMode(CS_PIN,			OUTPUT);
	pinMode(DIO_PIN,		OUTPUT);
	pinMode(SCK_PIN,		OUTPUT);
	pinMode(LCD_RES_PIN,	OUTPUT);
#endif

	//No need to define pins for xBee. It uses RX/TX

	//Disable internal pullups that Wire actividated for SDA and SDL
	pinMode(SDA,INPUT);
	digitalWrite(SDA,LOW);
	pinMode(SDA,OUTPUT);
	pinMode(SDL,INPUT);
	digitalWrite(SDL,LOW);
	pinMode(SDL,OUTPUT);
	
	//Enable internal pull-up resistor for BUTTON_RIGHT
	pinMode(BUTTON_RIGHT,INPUT);
	digitalWrite(BUTTON_RIGHT,HIGH);
	attachInterrupt(0, buttonLeft, FALLING);
	
	//Enable internal pull-up resistor for BUTTON_LEFT
	pinMode(BUTTON_RIGHT,INPUT);
	digitalWrite(BUTTON_RIGHT,HIGH);
	attachInterrupt(1, buttonRight, FALLING);

	//Enable internal pull-up resistor for BUTTON_CONTROL
	pinMode(BUTTON_CONTROL,INPUT);
	digitalWrite(BUTTON_CONTROL,HIGH);
	attachInterrupt(5, buttonControl, FALLING);
	
	//Enable internal pull-up resistor for BUTTON_PICTURE
	pinMode(BUTTON_PICTURE,INPUT);
	digitalWrite(BUTTON_PICTURE,HIGH);
	attachInterrupt(4, buttonPicture, FALLING);
	
	//Set pinMode for throttle potenciometer and led indicator
	pinMode(throttle_pot_in, INPUT);
	pinMode(throttle_led, OUTPUT);
	//Set pinMode for battery indicators
	pinMode(batt_led_red, OUTPUT);
	pinMode(batt_led_green, OUTPUT);
	pinMode(batt_led_blue, OUTPUT);
	pinMode(batt_status_in, INPUT);
	//set pinMode for xbee signal indicators and rssi pin
	pinMode(signal_led_red, OUTPUT);
	pinMode(signal_led_green, OUTPUT);
	pinMode(signal_led_blue, OUTPUT);
	pinMode(signal_rssi, INPUT);
	

}

void timer1init(){

	TIMSK1=0x01; // enable global and timer overflow interrupt
	TCCR1A = 0x00; // normal operation (mode0)
	TCNT1=0x0000; // 16bit counter register
	TCCR1B = 0x04; // start timer/ set clock
	//TCNT1=0x0BDC; // set initial value for one second
	TCNT1 = 0xFFFF - (samplingtime/0.016);

}

void timer3init(){

	TIMSK3=0x01; // enabled global and timer overflow interrupt;
	TCCR3A = 0x00; // normal operation page 148 (mode0);
	TCCR3B = 0x04; // start timer/ set clock
	TCNT3 = 0xFFFF - (synctime/0.016);

}

void stateManager(int dir)
{
	if(dir == LEFT)
	{
		if(currentState == states[0])
		{
			currentStatePos = statesLen - 1;
			currentState = states[currentStatePos];

		}
		else
		{
			currentStatePos--;
			currentState = states[currentStatePos];
		}
	}
	else if(dir == RIGHT)
	{
		if(currentState == states[statesLen - 1])
		{
			currentStatePos = 0;
			currentState = states[currentStatePos];
		}
		else
		{
			currentStatePos++;
			currentState = states[currentStatePos];
		}
	}
}

void buttonLeft()
{

	Serial.println("button_left");

	static unsigned long last_millis = 0;
	unsigned long m = millis();
	if (m - last_millis < 200)
	{

	}
	else{
		last_millis = m;
		stateManager(LEFT);
	}
}

void buttonRight()
{

	Serial.println("button_right");
	
	static unsigned long last_millis = 0;
	unsigned long m = millis();
	if (m - last_millis < 200)
	{

	}
	else{
		last_millis = m;
		stateManager(RIGHT);
	}
}

void buttonControl()
{

	Serial.println("button_control");

	//static unsigned long last_millis = 0;
	//unsigned long m = millis();
	//if (m - last_millis < 200)
	//{

	//}
	//else{
		//last_millis = m;
		
		
		// Toggle sendNavInfo control var
		sendNavInfo = !sendNavInfo;
		
		//}
		Serial.print ("Control: ");
		//sendNavInfo ? Serial.println("TRUE") : Serial.println("FALSE");
}

void buttonPicture()
{

	Serial.println("button_picture");

	static unsigned long last_millis = 0;
	unsigned long m = millis();
	if (m - last_millis < 200)
	{

	}
	else{
		last_millis = m;
		
		
		armed_motors = !armed_motors;
		}
		
		Serial.print ("Motors: ");
		armed_motors ? Serial.println("TRUE") : Serial.println("FALSE");

}