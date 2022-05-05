#include <pitches.h>
#include <LiquidCrystal.h>
#include <Wire.h>
#include "RTClib.h"
#define FIS_TYPE float
#define FIS_RESOLUSION 101
#define FIS_MIN -3.4028235E+38
#define FIS_MAX 3.4028235E+38
typedef FIS_TYPE(*_FIS_MF)(FIS_TYPE, FIS_TYPE*);
typedef FIS_TYPE(*_FIS_ARR_OP)(FIS_TYPE, FIS_TYPE);
typedef FIS_TYPE(*_FIS_ARR)(FIS_TYPE*, int, _FIS_ARR_OP);
// Number of inputs to the fuzzy inference system
const int fis_gcI = 6;
// Number of outputs to the fuzzy inference system
const int fis_gcO = 1;
// Number of rules to the fuzzy inference system
const int fis_gcR = 99;

FIS_TYPE g_fisInput[fis_gcI];
FIS_TYPE g_fisOutput[fis_gcO];
//LiquidCrystal lcd(12,11,5,4,3,2);
LiquidCrystal lcd(2,3,4,5,6,7);
RTC_DS3231 rtc;
int duration=1000;
// Setup routine runs once when you press reset:
void setup()
{
  Serial.begin(9600);
  lcd.begin(16,2);
  lcd.setCursor(0,0);
  lcd.print("Fuzzy Logic!");
  if (! rtc.begin()) {
    Serial.println("Couldn't find RTC");
    while (1);
  }
  if (rtc.lostPower()) {
    Serial.println("RTC lost power, lets set the time!");
  }
  //rtc.adjust(DateTime(2022, 4, 26, 15, 24, 0));
}

// Loop routine runs over and over again forever:
void loop()
{
 DateTime now = rtc.now();
 float in_analog1=now.hour(); //sun
 float in_analog2=now.day(); //edl_price
 float in_analog3=now.day() ; //generator_price
 float in_analog4=now.hour(); //edl_supply
 float in_analog5=now.hour(); //generator_supply
 float in_analog6=19.45; //battery


//float in_analog1=6.19; //sun
//float in_analog2=15.4; //edl_price
//float in_analog3=3.07; //generator_price
//float in_analog4=5.7; //edl_supply
//float in_analog5=22.6; //generator_supply
//float in_analog6=7.14; //battery

// float in_analog1=5.52; //sun
// float in_analog2=5.43; //edl_price
// float in_analog3=3.075; //generator_price
// float in_analog4=8.222; //edl_supply
// float in_analog5=19.2; //generator_supply
// float in_analog6=79.45; //battery
//
// float in_analog1=5.52; //sun
// float in_analog2=5.43; //edl_price
// float in_analog3=3.075; //generator_price
// float in_analog4=15.73; //edl_supply
// float in_analog5=11; //generator_supply
// float in_analog6=19.45; //battery
//
// float in_analog1=21.5; //sun
// float in_analog2=5.43; //edl_price
// float in_analog3=5.43; //generator_price
// float in_analog4=21.5; //edl_supply
// float in_analog5=21.5; //generator_supply
// float in_analog6=19.45; //battery
//
//
// float in_analog1=21.5; //sun
// float in_analog2=5.43; //edl_price
// float in_analog3=25.43; //generator_price
// float in_analog4=21.5; //edl_supply
// float in_analog5=21.5; //generator_supply
// float in_analog6=60.45; //battery
    // Read Input: SUN
    g_fisInput[0] = in_analog1;
    // Read Input: EDL-price
    g_fisInput[1] = in_analog2;
    // Read Input: Generator-price
    g_fisInput[2] = in_analog3;
    // Read Input: battery
    g_fisInput[3] =in_analog6;
    // Read Input: EDL_Supply
    g_fisInput[4] = in_analog4;
    // Read Input: Generator_supply
    g_fisInput[5] = in_analog5;

    g_fisOutput[0] = 0;
    //Serial.println("Current Date & Time: ");
    //Serial.println(now.day(), DEC);
    //Serial.println(now.hour(), DEC);
    fis_evaluate();
    // Set output vlaue: decision
    analogWrite(6 , g_fisOutput[0]);

}

//***********************************************************************
// Support functions for Fuzzy Inference System                          
//***********************************************************************
// Trapezoidal Member Function
FIS_TYPE fis_trapmf(FIS_TYPE x, FIS_TYPE* p)
{
    FIS_TYPE a = p[0], b = p[1], c = p[2], d = p[3];
    FIS_TYPE t1 = ((x <= c) ? 1 : ((d < x) ? 0 : ((c != d) ? ((d - x) / (d - c)) : 0)));
    FIS_TYPE t2 = ((b <= x) ? 1 : ((x < a) ? 0 : ((a != b) ? ((x - a) / (b - a)) : 0)));
    return (FIS_TYPE) min(t1, t2);
}

FIS_TYPE fis_min(FIS_TYPE a, FIS_TYPE b)
{
    return min(a, b);
}

FIS_TYPE fis_max(FIS_TYPE a, FIS_TYPE b)
{
    return max(a, b);
}

FIS_TYPE fis_array_operation(FIS_TYPE *array, int size, _FIS_ARR_OP pfnOp)
{
    int i;
    FIS_TYPE ret = 0;

    if (size == 0) return ret;
    if (size == 1) return array[0];

    ret = array[0];
    for (i = 1; i < size; i++)
    {
        ret = (*pfnOp)(ret, array[i]);
    }

    return ret;
}


//***********************************************************************
// Data for Fuzzy Inference System                                       
//***********************************************************************
// Pointers to the implementations of member functions
_FIS_MF fis_gMF[] =
{
    fis_trapmf
};

// Count of member function for each Input
int fis_gIMFCount[] = { 3, 3, 3, 3, 3, 2 };

// Count of member function for each Output 
int fis_gOMFCount[] = { 4 };

// Coefficients for the Input Member Functions
FIS_TYPE fis_gMFI0Coeff1[] = { 4, 7, 24, 24 };
FIS_TYPE fis_gMFI0Coeff2[] = { 7.5, 9, 12, 16 };
FIS_TYPE fis_gMFI0Coeff3[] = { 9, 14, 16, 21 };
FIS_TYPE* fis_gMFI0Coeff[] = { fis_gMFI0Coeff1, fis_gMFI0Coeff2, fis_gMFI0Coeff3 };
FIS_TYPE fis_gMFI1Coeff1[] = { 0, 3, 7, 12.5 };
FIS_TYPE fis_gMFI1Coeff2[] = { 6, 13, 17, 25 };
FIS_TYPE fis_gMFI1Coeff3[] = { 18, 23, 30, 30 };
FIS_TYPE* fis_gMFI1Coeff[] = { fis_gMFI1Coeff1, fis_gMFI1Coeff2, fis_gMFI1Coeff3 };
FIS_TYPE fis_gMFI2Coeff1[] = { 0, 3, 7, 13 };
FIS_TYPE fis_gMFI2Coeff2[] = { 6, 13, 17, 24 };
FIS_TYPE fis_gMFI2Coeff3[] = { 18, 23, 30, 30 };
FIS_TYPE* fis_gMFI2Coeff[] = { fis_gMFI2Coeff1, fis_gMFI2Coeff2, fis_gMFI2Coeff3 };
FIS_TYPE fis_gMFI3Coeff1[] = { 0, 15, 25, 39 };
FIS_TYPE fis_gMFI3Coeff2[] = { 24, 44, 56, 76 };
FIS_TYPE fis_gMFI3Coeff3[] = { 60, 75, 85, 100 };
FIS_TYPE* fis_gMFI3Coeff[] = { fis_gMFI3Coeff1, fis_gMFI3Coeff2, fis_gMFI3Coeff3 };
FIS_TYPE fis_gMFI4Coeff1[] = { 14, 14, 16, 16 };
FIS_TYPE fis_gMFI4Coeff2[] = { 0, 0, 13.8, 13.8 };
FIS_TYPE fis_gMFI4Coeff3[] = { 16.1, 16.1, 24, 24 };
FIS_TYPE* fis_gMFI4Coeff[] = { fis_gMFI4Coeff1, fis_gMFI4Coeff2, fis_gMFI4Coeff3 };
FIS_TYPE fis_gMFI5Coeff1[] = { 17, 17, 24, 24 };
FIS_TYPE fis_gMFI5Coeff2[] = { 0, 0, 16.9, 16.9 };
FIS_TYPE* fis_gMFI5Coeff[] = { fis_gMFI5Coeff1, fis_gMFI5Coeff2 };
FIS_TYPE** fis_gMFICoeff[] = { fis_gMFI0Coeff, fis_gMFI1Coeff, fis_gMFI2Coeff, fis_gMFI3Coeff, fis_gMFI4Coeff, fis_gMFI5Coeff };

// Coefficients for the Output Member Functions
FIS_TYPE fis_gMFO0Coeff1[] = { 5, 5, 15, 15 };
FIS_TYPE fis_gMFO0Coeff2[] = { 14, 14, 16, 16 };
FIS_TYPE fis_gMFO0Coeff3[] = { 18, 18, 23.9, 23.9 };
FIS_TYPE fis_gMFO0Coeff4[] = { 0, 0, 5, 5 };
FIS_TYPE* fis_gMFO0Coeff[] = { fis_gMFO0Coeff1, fis_gMFO0Coeff2, fis_gMFO0Coeff3, fis_gMFO0Coeff4 };
FIS_TYPE** fis_gMFOCoeff[] = { fis_gMFO0Coeff };

// Input membership function set
int fis_gMFI0[] = { 0, 0, 0 };
int fis_gMFI1[] = { 0, 0, 0 };
int fis_gMFI2[] = { 0, 0, 0 };
int fis_gMFI3[] = { 0, 0, 0 };
int fis_gMFI4[] = { 0, 0, 0 };
int fis_gMFI5[] = { 0, 0 };
int* fis_gMFI[] = { fis_gMFI0, fis_gMFI1, fis_gMFI2, fis_gMFI3, fis_gMFI4, fis_gMFI5};

// Output membership function set
int fis_gMFO0[] = { 0, 0, 0, 0 };
int* fis_gMFO[] = { fis_gMFO0};

// Rule Weights
FIS_TYPE fis_gRWeight[] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };

// Rule Type
int fis_gRType[] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };

// Rule Inputs
int fis_gRI0[] = { 3, 0, 0, 0, 0, 0 };
int fis_gRI1[] = { 3, 1, 1, 1, 1, 0 };
int fis_gRI2[] = { 3, 1, 1, 1, 0, 1 };
int fis_gRI3[] = { 3, 1, 1, 2, 0, 1 };
int fis_gRI4[] = { 3, 1, 1, 3, 0, 1 };
int fis_gRI5[] = { 3, 1, 1, 1, 1, 0 };
int fis_gRI6[] = { 3, 1, 1, 2, 1, 0 };
int fis_gRI7[] = { 3, 1, 1, 3, 1, 0 };
int fis_gRI8[] = { 3, 1, 2, 1, 1, 0 };
int fis_gRI9[] = { 3, 1, 3, 1, 1, 0 };
int fis_gRI10[] = { 3, 2, 1, 1, 1, 0 };
int fis_gRI11[] = { 3, 3, 1, 1, 1, 0 };
int fis_gRI12[] = { 3, 1, 2, 2, 1, 0 };
int fis_gRI13[] = { 3, 1, 2, 3, 1, 0 };
int fis_gRI14[] = { 3, 1, 3, 2, 1, 0 };
int fis_gRI15[] = { 3, 1, 3, 3, 1, 0 };
int fis_gRI16[] = { 3, 2, 1, 2, 1, 0 };
int fis_gRI17[] = { 3, 2, 1, 3, 1, 0 };
int fis_gRI18[] = { 3, 3, 1, 2, 1, 0 };
int fis_gRI19[] = { 3, 3, 1, 3, 1, 0 };
int fis_gRI20[] = { 3, 1, 1, 2, 0, 1 };
int fis_gRI21[] = { 3, 1, 2, 2, 0, 1 };
int fis_gRI22[] = { 3, 1, 3, 2, 0, 1 };
int fis_gRI23[] = { 3, 2, 1, 2, 0, 1 };
int fis_gRI24[] = { 3, 2, 3, 2, 0, 1 };
int fis_gRI25[] = { 3, 3, 1, 2, 0, 1 };
int fis_gRI26[] = { 3, 3, 2, 2, 0, 1 };
int fis_gRI27[] = { 3, 3, 3, 2, 0, 1 };
int fis_gRI28[] = { 3, 1, 1, 3, 0, 1 };
int fis_gRI29[] = { 3, 1, 3, 3, 0, 1 };
int fis_gRI30[] = { 3, 1, 2, 3, 0, 1 };
int fis_gRI31[] = { 3, 2, 1, 3, 0, 1 };
int fis_gRI32[] = { 3, 2, 2, 3, 0, 1 };
int fis_gRI33[] = { 3, 2, 3, 3, 0, 1 };
int fis_gRI34[] = { 3, 3, 1, 3, 0, 1 };
int fis_gRI35[] = { 3, 3, 2, 3, 0, 1 };
int fis_gRI36[] = { 3, 3, 3, 3, 0, 1 };
int fis_gRI37[] = { 2, 1, 1, 1, 0, 1 };
int fis_gRI38[] = { 2, 1, 1, 1, 1, 0 };
int fis_gRI39[] = { 2, 1, 1, 2, 0, 1 };
int fis_gRI40[] = { 2, 1, 1, 3, 0, 1 };
int fis_gRI41[] = { 2, 1, 1, 2, 1, 0 };
int fis_gRI42[] = { 2, 1, 1, 3, 1, 0 };
int fis_gRI43[] = { 2, 1, 2, 2, 0, 1 };
int fis_gRI44[] = { 2, 1, 3, 2, 0, 1 };
int fis_gRI45[] = { 2, 1, 2, 3, 0, 1 };
int fis_gRI46[] = { 2, 1, 3, 3, 0, 1 };
int fis_gRI47[] = { 2, 1, 2, 2, 1, 0 };
int fis_gRI48[] = { 2, 1, 3, 2, 1, 0 };
int fis_gRI49[] = { 2, 1, 2, 3, 1, 0 };
int fis_gRI50[] = { 2, 1, 3, 3, 1, 0 };
int fis_gRI51[] = { 2, 2, 1, 1, 1, 0 };
int fis_gRI52[] = { 2, 3, 1, 1, 1, 0 };
int fis_gRI53[] = { 2, 1, 2, 1, 1, 0 };
int fis_gRI54[] = { 2, 2, 2, 1, 1, 0 };
int fis_gRI55[] = { 2, 3, 2, 1, 1, 0 };
int fis_gRI56[] = { 2, 1, 3, 1, 1, 0 };
int fis_gRI57[] = { 2, 2, 3, 1, 1, 0 };
int fis_gRI58[] = { 2, 3, 3, 1, 1, 0 };
int fis_gRI59[] = { 2, 1, 1, 2, 1, 0 };
int fis_gRI60[] = { 2, 1, 2, 2, 1, 0 };
int fis_gRI61[] = { 2, 1, 3, 2, 1, 0 };
int fis_gRI62[] = { 2, 2, 1, 2, 1, 0 };
int fis_gRI63[] = { 2, 2, 2, 2, 1, 0 };
int fis_gRI64[] = { 2, 2, 3, 2, 1, 0 };
int fis_gRI65[] = { 2, 3, 3, 2, 1, 0 };
int fis_gRI66[] = { 2, 3, 3, 2, 1, 0 };
int fis_gRI67[] = { 2, 3, 2, 2, 1, 0 };
int fis_gRI68[] = { 2, 3, 1, 2, 1, 0 };
int fis_gRI69[] = { 2, 1, 1, 3, 1, 0 };
int fis_gRI70[] = { 2, 1, 3, 3, 1, 0 };
int fis_gRI71[] = { 2, 1, 2, 3, 1, 0 };
int fis_gRI72[] = { 2, 2, 1, 3, 1, 0 };
int fis_gRI73[] = { 2, 2, 2, 3, 1, 0 };
int fis_gRI74[] = { 2, 2, 3, 3, 1, 0 };
int fis_gRI75[] = { 2, 3, 1, 3, 1, 0 };
int fis_gRI76[] = { 2, 3, 2, 3, 1, 0 };
int fis_gRI77[] = { 2, 3, 3, 3, 1, 0 };
int fis_gRI78[] = { 2, 0, 0, 0, 0, 0 };
int fis_gRI79[] = { 1, 1, 1, 1, 1, 0 };
int fis_gRI80[] = { 1, 1, 1, 2, 1, 0 };
int fis_gRI81[] = { 1, 1, 1, 3, 1, 0 };
int fis_gRI82[] = { 1, 1, 2, 3, 1, 0 };
int fis_gRI83[] = { 1, 1, 3, 3, 1, 0 };
int fis_gRI84[] = { 1, 1, 3, 1, 1, 0 };
int fis_gRI85[] = { 1, 1, 2, 1, 1, 0 };
int fis_gRI86[] = { 1, 1, 3, 3, 1, 0 };
int fis_gRI87[] = { 1, 1, 2, 3, 1, 0 };
int fis_gRI88[] = { 1, 2, 0, 3, 1, 0 };
int fis_gRI89[] = { 1, 2, 0, -3, 1, 0 };
int fis_gRI90[] = { 1, 3, 0, 3, 1, 0 };
int fis_gRI91[] = { 1, 3, 0, -3, 1, 0 };
int fis_gRI92[] = { 1, 0, 0, 3, 0, 0 };
int fis_gRI93[] = { 1, 0, -1, 2, 0, 0 };
int fis_gRI94[] = { 1, 0, -1, 2, 0, 1 };
int fis_gRI95[] = { 1, 0, -1, 3, 0, 1 };
int fis_gRI96[] = { 1, 0, -1, 1, 0, 1 };
int fis_gRI97[] = { 1, 0, -3, 1, 0, 1 };
int fis_gRI98[] = { 1, 0, -2, 1, 0, 1 };
int fis_gRI99[] = { 1, 0, 0, 3, 0, 0 };
int* fis_gRI[] = { fis_gRI0, fis_gRI1, fis_gRI2, fis_gRI3, fis_gRI4, fis_gRI5, fis_gRI6, fis_gRI7, fis_gRI8, fis_gRI9, fis_gRI10, fis_gRI11, fis_gRI12, fis_gRI13, fis_gRI14, fis_gRI15, fis_gRI16, fis_gRI17, fis_gRI18, fis_gRI19, fis_gRI20, fis_gRI21, fis_gRI22, fis_gRI23, fis_gRI24, fis_gRI25, fis_gRI26, fis_gRI27, fis_gRI28, fis_gRI29, fis_gRI30, fis_gRI31, fis_gRI32, fis_gRI33, fis_gRI34, fis_gRI35, fis_gRI36, fis_gRI37, fis_gRI38, fis_gRI39, fis_gRI40, fis_gRI41, fis_gRI42, fis_gRI43, fis_gRI44, fis_gRI45, fis_gRI46, fis_gRI47, fis_gRI48, fis_gRI49, fis_gRI50, fis_gRI51, fis_gRI52, fis_gRI53, fis_gRI54, fis_gRI55, fis_gRI56, fis_gRI57, fis_gRI58, fis_gRI59, fis_gRI60, fis_gRI61, fis_gRI62, fis_gRI63, fis_gRI64, fis_gRI65, fis_gRI66, fis_gRI67, fis_gRI68, fis_gRI69, fis_gRI70, fis_gRI71, fis_gRI72, fis_gRI73, fis_gRI74, fis_gRI75, fis_gRI76, fis_gRI77, fis_gRI78, fis_gRI79, fis_gRI80, fis_gRI81, fis_gRI82, fis_gRI83, fis_gRI84, fis_gRI85, fis_gRI86, fis_gRI87, fis_gRI88, fis_gRI89, fis_gRI90, fis_gRI91, fis_gRI92, fis_gRI93, fis_gRI94, fis_gRI95, fis_gRI96, fis_gRI97, fis_gRI98, fis_gRI99 };

// Rule Outputs
int fis_gRO0[] = { 1 };
int fis_gRO1[] = { 1 };
int fis_gRO2[] = { 1 };
int fis_gRO3[] = { 1 };
int fis_gRO4[] = { 1 };
int fis_gRO5[] = { 1 };
int fis_gRO6[] = { 1 };
int fis_gRO7[] = { 1 };
int fis_gRO8[] = { 1 };
int fis_gRO9[] = { 1 };
int fis_gRO10[] = { 1 };
int fis_gRO11[] = { 1 };
int fis_gRO12[] = { 1 };
int fis_gRO13[] = { 1 };
int fis_gRO14[] = { 1 };
int fis_gRO15[] = { 1 };
int fis_gRO16[] = { 1 };
int fis_gRO17[] = { 1 };
int fis_gRO18[] = { 1 };
int fis_gRO19[] = { 1 };
int fis_gRO20[] = { 1 };
int fis_gRO21[] = { 1 };
int fis_gRO22[] = { 1 };
int fis_gRO23[] = { 1 };
int fis_gRO24[] = { 1 };
int fis_gRO25[] = { 1 };
int fis_gRO26[] = { 1 };
int fis_gRO27[] = { 1 };
int fis_gRO28[] = { 1 };
int fis_gRO29[] = { 1 };
int fis_gRO30[] = { 1 };
int fis_gRO31[] = { 1 };
int fis_gRO32[] = { 1 };
int fis_gRO33[] = { 1 };
int fis_gRO34[] = { 1 };
int fis_gRO35[] = { 1 };
int fis_gRO36[] = { 1 };
int fis_gRO37[] = { 1 };
int fis_gRO38[] = { 1 };
int fis_gRO39[] = { 1 };
int fis_gRO40[] = { 1 };
int fis_gRO41[] = { 1 };
int fis_gRO42[] = { 1 };
int fis_gRO43[] = { 1 };
int fis_gRO44[] = { 1 };
int fis_gRO45[] = { 1 };
int fis_gRO46[] = { 1 };
int fis_gRO47[] = { 1 };
int fis_gRO48[] = { 1 };
int fis_gRO49[] = { 1 };
int fis_gRO50[] = { 1 };
int fis_gRO51[] = { 1 };
int fis_gRO52[] = { 1 };
int fis_gRO53[] = { 1 };
int fis_gRO54[] = { 1 };
int fis_gRO55[] = { 1 };
int fis_gRO56[] = { 1 };
int fis_gRO57[] = { 1 };
int fis_gRO58[] = { 1 };
int fis_gRO59[] = { 1 };
int fis_gRO60[] = { 1 };
int fis_gRO61[] = { 1 };
int fis_gRO62[] = { 1 };
int fis_gRO63[] = { 1 };
int fis_gRO64[] = { 1 };
int fis_gRO65[] = { 1 };
int fis_gRO66[] = { 1 };
int fis_gRO67[] = { 1 };
int fis_gRO68[] = { 1 };
int fis_gRO69[] = { 1 };
int fis_gRO70[] = { 1 };
int fis_gRO71[] = { 1 };
int fis_gRO72[] = { 1 };
int fis_gRO73[] = { 1 };
int fis_gRO74[] = { 1 };
int fis_gRO75[] = { 1 };
int fis_gRO76[] = { 1 };
int fis_gRO77[] = { 1 };
int fis_gRO78[] = { 1 };
int fis_gRO79[] = { 2 };
int fis_gRO80[] = { 2 };
int fis_gRO81[] = { 2 };
int fis_gRO82[] = { 2 };
int fis_gRO83[] = { 2 };
int fis_gRO84[] = { 2 };
int fis_gRO85[] = { 2 };
int fis_gRO86[] = { 2 };
int fis_gRO87[] = { 2 };
int fis_gRO88[] = { 2 };
int fis_gRO89[] = { 2 };
int fis_gRO90[] = { 4 };
int fis_gRO91[] = { 2 };
int fis_gRO92[] = { 4 };
int fis_gRO93[] = { 4 };
int fis_gRO94[] = { 4 };
int fis_gRO95[] = { 4 };
int fis_gRO96[] = { 3 };
int fis_gRO97[] = { 3 };
int fis_gRO98[] = { 3 };
int fis_gRO99[] = { 4 };
int* fis_gRO[] = { fis_gRO0, fis_gRO1, fis_gRO2, fis_gRO3, fis_gRO4, fis_gRO5, fis_gRO6, fis_gRO7, fis_gRO8, fis_gRO9, fis_gRO10, fis_gRO11, fis_gRO12, fis_gRO13, fis_gRO14, fis_gRO15, fis_gRO16, fis_gRO17, fis_gRO18, fis_gRO19, fis_gRO20, fis_gRO21, fis_gRO22, fis_gRO23, fis_gRO24, fis_gRO25, fis_gRO26, fis_gRO27, fis_gRO28, fis_gRO29, fis_gRO30, fis_gRO31, fis_gRO32, fis_gRO33, fis_gRO34, fis_gRO35, fis_gRO36, fis_gRO37, fis_gRO38, fis_gRO39, fis_gRO40, fis_gRO41, fis_gRO42, fis_gRO43, fis_gRO44, fis_gRO45, fis_gRO46, fis_gRO47, fis_gRO48, fis_gRO49, fis_gRO50, fis_gRO51, fis_gRO52, fis_gRO53, fis_gRO54, fis_gRO55, fis_gRO56, fis_gRO57, fis_gRO58, fis_gRO59, fis_gRO60, fis_gRO61, fis_gRO62, fis_gRO63, fis_gRO64, fis_gRO65, fis_gRO66, fis_gRO67, fis_gRO68, fis_gRO69, fis_gRO70, fis_gRO71, fis_gRO72, fis_gRO73, fis_gRO74, fis_gRO75, fis_gRO76, fis_gRO77, fis_gRO78, fis_gRO79, fis_gRO80, fis_gRO81, fis_gRO82, fis_gRO83, fis_gRO84, fis_gRO85, fis_gRO86, fis_gRO87, fis_gRO88, fis_gRO89, fis_gRO90, fis_gRO91, fis_gRO92, fis_gRO93, fis_gRO94, fis_gRO95, fis_gRO96, fis_gRO97, fis_gRO98, fis_gRO99 };

// Input range Min
FIS_TYPE fis_gIMin[] = { 0, 0, 0, 0, 0, 0 };

// Input range Max
FIS_TYPE fis_gIMax[] = { 24, 30, 30, 100, 24, 24 };

// Output range Min
FIS_TYPE fis_gOMin[] = { 0 };

// Output range Max
FIS_TYPE fis_gOMax[] = { 24 };

//***********************************************************************
// Data dependent support functions for Fuzzy Inference System           
//***********************************************************************
FIS_TYPE fis_MF_out(FIS_TYPE** fuzzyRuleSet, FIS_TYPE x, int o)
{
    FIS_TYPE mfOut;
    int r;

    for (r = 0; r < fis_gcR; ++r)
    {
        int index = fis_gRO[r][o];
        if (index > 0)
        {
            index = index - 1;
            mfOut = (fis_gMF[fis_gMFO[o][index]])(x, fis_gMFOCoeff[o][index]);
        }
        else if (index < 0)
        {
            index = -index - 1;
            mfOut = 1 - (fis_gMF[fis_gMFO[o][index]])(x, fis_gMFOCoeff[o][index]);
        }
        else
        {
            mfOut = 0;
        }

        fuzzyRuleSet[0][r] = fis_min(mfOut, fuzzyRuleSet[1][r]);
    }
    return fis_array_operation(fuzzyRuleSet[0], fis_gcR, fis_max);
}

FIS_TYPE fis_defuzz_centroid(FIS_TYPE** fuzzyRuleSet, int o)
{
    FIS_TYPE step = (fis_gOMax[o] - fis_gOMin[o]) / (FIS_RESOLUSION - 1);
    FIS_TYPE area = 0;
    FIS_TYPE momentum = 0;
    FIS_TYPE dist, slice;
    int i;

    // calculate the area under the curve formed by the MF outputs
    for (i = 0; i < FIS_RESOLUSION; ++i){
        dist = fis_gOMin[o] + (step * i);
        slice = step * fis_MF_out(fuzzyRuleSet, dist, o);
        area += slice;
        momentum += slice*dist;
    }

    return ((area == 0) ? ((fis_gOMax[o] + fis_gOMin[o]) / 2) : (momentum / area));
}


//***********************************************************************
// Fuzzy Inference System                                                
//***********************************************************************
void yellow(){
    analogWrite(31,255);
    analogWrite(32,255);
    analogWrite(33,0);
  
  }
void blue(){
    analogWrite(33,255);
  }
void green(){
    analogWrite(31,255);
  }
void red(){
    analogWrite(32,255);
  }
void fis_evaluate()
  {
    DateTime now = rtc.now();
    FIS_TYPE fuzzyInput0[] = { 0, 0, 0 };
    FIS_TYPE fuzzyInput1[] = { 0, 0, 0 };
    FIS_TYPE fuzzyInput2[] = { 0, 0, 0 };
    FIS_TYPE fuzzyInput3[] = { 0, 0, 0 };
    FIS_TYPE fuzzyInput4[] = { 0, 0, 0 };
    FIS_TYPE fuzzyInput5[] = { 0, 0 };
    FIS_TYPE* fuzzyInput[fis_gcI] = { fuzzyInput0, fuzzyInput1, fuzzyInput2, fuzzyInput3, fuzzyInput4, fuzzyInput5, };
    FIS_TYPE fuzzyOutput0[] = { 0, 0, 0, 0 };
    FIS_TYPE* fuzzyOutput[fis_gcO] = { fuzzyOutput0, };
    FIS_TYPE fuzzyRules[fis_gcR] = { 0 };
    FIS_TYPE fuzzyFires[fis_gcR] = { 0 };
    FIS_TYPE* fuzzyRuleSet[] = { fuzzyRules, fuzzyFires };
    FIS_TYPE sW = 0;

    // Transforming input to fuzzy Input
    int i, j, r, o;
    for (i = 0; i < fis_gcI; ++i)
    {
        for (j = 0; j < fis_gIMFCount[i]; ++j)
        {
            fuzzyInput[i][j] =
                (fis_gMF[fis_gMFI[i][j]])(g_fisInput[i], fis_gMFICoeff[i][j]);
        }
    }

    int index = 0;
    for (r = 0; r < fis_gcR; ++r)
    {
        if (fis_gRType[r] == 1)
        {
            fuzzyFires[r] = FIS_MAX;
            for (i = 0; i < fis_gcI; ++i)
            {
                index = fis_gRI[r][i];
                if (index > 0)
                    fuzzyFires[r] = fis_min(fuzzyFires[r], fuzzyInput[i][index - 1]);
                else if (index < 0)
                    fuzzyFires[r] = fis_min(fuzzyFires[r], 1 - fuzzyInput[i][-index - 1]);
                else
                    fuzzyFires[r] = fis_min(fuzzyFires[r], 1);
            }
        }
        else
        {
            fuzzyFires[r] = FIS_MIN;
            for (i = 0; i < fis_gcI; ++i)
            {
                index = fis_gRI[r][i];
                if (index > 0)
                    fuzzyFires[r] = fis_max(fuzzyFires[r], fuzzyInput[i][index - 1]);
                else if (index < 0)
                    fuzzyFires[r] = fis_max(fuzzyFires[r], 1 - fuzzyInput[i][-index - 1]);
                else
                    fuzzyFires[r] = fis_max(fuzzyFires[r], 0);
            }
        }

        fuzzyFires[r] = fis_gRWeight[r] * fuzzyFires[r];
        sW += fuzzyFires[r];
    }

    if (sW == 0)
    {
        for (o = 0; o < fis_gcO; ++o)
        {
            g_fisOutput[o] = ((fis_gOMax[o] + fis_gOMin[o]) / 2);
        }
    }
    else
    {
        for (o = 0; o < fis_gcO; ++o)
        {
            g_fisOutput[o] = fis_defuzz_centroid(fuzzyRuleSet, o);
        }
    }
    lcd.setCursor(0,1);
    String stringOne=String(g_fisOutput[0]);
    String stringTwo=String(now.hour());
    String stringThree=String(now.day());
    String stringFour=String(now.month());
    String stringFive=String(now.year());
    String stringSix=String(now.minute());
    
    if(g_fisOutput[0]<=5 && g_fisOutput[0]>=0){
        //lcd.println(g_fisOutput[0]);
        lcd.println("Decision: Battery");
        String output=stringOne+","+"Battery"+","+stringTwo+","+stringThree+","+stringFour+","+stringFive+","+stringSix;
        Serial.println(output);
        green();
        
    }
    if(g_fisOutput[0]<13.9 && g_fisOutput[0]>5){
        //lcd.println(g_fisOutput[0]);
        lcd.println("Decision: Sun");
        String output=stringOne+","+"Sun"+","+stringTwo+","+stringThree+","+stringFour+","+stringFive+","+stringSix;
        Serial.println(output);
        yellow();
        
    }
    if(g_fisOutput[0]<=16 && g_fisOutput[0]>=14){
        //lcd.println(g_fisOutput[0]);
        lcd.println("Decision: Edl");
        String output=stringOne+","+"EdL"+","+stringTwo+","+stringThree+","+stringFour+","+stringFive+","+stringSix;
        Serial.println(output);
        red();
    }
    if(g_fisOutput[0]<=23.9 && g_fisOutput[0]>16){
        //lcd.println(g_fisOutput[0]);
        lcd.println("Decision: Generator");
        String output=stringOne+","+"Generator"+","+stringTwo+","+stringThree+","+stringFour+","+stringFive+","+stringSix;
        Serial.println(output);
        blue();
    }
    //tone(8,NOTE_C5,duration);
    delay(1000);
}
