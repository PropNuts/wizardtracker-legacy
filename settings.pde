// RACE SETTINGS
float minLapTime = 5;
String[] racer = {"Pilot 1","Pilot 2","Pilot 3","Pilot 4"};
float[] threshold = {220,220,220,220};
float lpfFactor = 0.5;
float calibrationMargin = 0.95;

// OTHER SETTINGS
float[] rssiMax = {300,300,300,300};
float[] rssiMin = {100,100,100,100};
float drawPeriod = 40; // Limit Draw Loop to min of ms - 40ms = 25fps
int commPort = 0;