// IMPORT LIBRARIES AND DECLARE OBJECTS
import processing.serial.*;
import processing.sound.*;
Serial myPort;       // declare serial port object
PrintWriter logRssi;  // Declare txt output object
PrintWriter logResults;  // Declare txt output object
PImage logoImg; // Image Logo
SoundFile soundBeep1;
SoundFile soundBeep2;

// DEFINE VARIABLES
float[] rssi = new float[4];
float[] rssiLpf = new float[4];
float[] graph = new float[4];
float[] graphLpf = new float[4];
float inTime = 0;
float[] channel = new float[4];
int[] lap = new int[4];
float[] lapStart = new float[4];
float[] lapEnd = new float[4];
float[][] lapTime = new float[4][50];
int beep = 0;
int[] printX = {35,350,665,970};
int[] fastLap = new int[4];
float[] fastLapTime = new float[4];
float[] calibrateRssi = new float[4];
boolean[] keyRacer = new boolean[4];
boolean[] keyAdjust = new boolean[2];
boolean[] thresholdExit = {true,true,true,true};
float[] thresholdExitTime = new float[4];

// MISC FLAGS AND COUNTERS
float tick = 0;
boolean setCommPort = false;
boolean start = false;
boolean countdown = false;
boolean calibrate = false;
boolean saveCalibration = false;
boolean finish = false;
boolean drawOnceComm = false;