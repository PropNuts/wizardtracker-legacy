// LAP TRACKER v1
// CREATED BY TONY FONG, PROPNUTS, 06/03/2017
// DISPLAY SET UP FOR 1280x1084

// RACE SETTINGS
float minLapTime = 10;
String[] racer = {"Racer 1","Racer 2","Racer 3","Racer 4"};
float[] threshold = {120,120,190,190};

// IMPORT LIBRARIES AND DECLARE OBJECTS
import processing.serial.*;
import processing.sound.*;
Serial myPort;       // declare serial port object
PrintWriter output;  // Declare txt output object
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
float[][] graphArray = new float[4][1240];
float[][] graphLpfArray = new float[4][1240];
int beep = 0;
int[] printX = {35,350,665,970};
int[] fastLap = new int[4];
float[] fastLapTime = new float[4];
float[] calibrateRssi = new float[4];

// OTHER SETTINGS
float[] rssiMax = {300,300,300,300};
float[] rssiMin = {100,100,100,100};
float drawPeriod = 1; // Limit Draw Loop to min of ms

// MISC FLAGS AND COUNTERS
float tick = 0;
boolean start = false;
boolean countdown = false;
boolean calibrate = false;


// SETUP
void setup(){
  // LOAD EXTERNAL DATA
  logoImg = loadImage("logo.png");
  soundBeep1 = new SoundFile(this, "beep2.wav");
  soundBeep2 = new SoundFile(this, "beep1.wav");
  
  // SETUP SERIAL
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 115200);
  myPort.bufferUntil('\n');
  
  // SETUP WINDOW
  size(1280,720);
  background(47,85,151);
  
  // DRAW HEADER SECTION - STATIC, DOES NOT REDRAW
  image(logoImg,10,10);
  fill(255); textSize(30); text("WizardTrack Lap Timer",500,60);

  // DISPLAY START BUTTON AND WAIT
  fill(47,85,151);strokeWeight(3);stroke(255,0,0);rectMode(CENTER);rect(width/2,height/2,200,100,5);rectMode(CORNER);
  textSize(30);fill(255);textAlign(CENTER);text("Start Race",width/2,(height/2)+10);

  // DISPLAY CALIBRATE BUTTON
  fill(47,85,151);strokeWeight(3);stroke(255,0,0);rectMode(CENTER);rect(width/2,(height/2)+200,200,100,5);rectMode(CORNER);
  textSize(30);fill(255);textAlign(CENTER);text("Calibration",width/2,(height/2)+200+10);

}


void draw(){
  // CHECK IF CALIBRATE BUTTON HAS BEEN PRESSED
  if (calibrate == true){
    background(0);
    textAlign(LEFT);text("5665 MHz: " + calibrateRssi[0],100,100);
    textAlign(LEFT);text("5745 MHz: " + calibrateRssi[1],100,200);
    textAlign(LEFT);text("5885 MHz: " + calibrateRssi[2],100,300);
    textAlign(LEFT);text("5945 MHz: " + calibrateRssi[3],100,400);
  }
  
  // CHECK IF START BUTTON HAS BEEN PRESSED
  if (countdown == true){
    startTimer();
  }
  
  // CHECK IF RACE HAS STARTED
  // ONLY REDRAW IF MORE THAN 100MS SINCE LAST DRAW - TO REDUCE PROCESSING
  if (start == true && millis() > tick + drawPeriod){
    
    // Draw racer segments
    fill(47,85,151);
    strokeWeight(3);
    stroke(255,0,0); rect(15,110,300,350,5);
    stroke(255,255,0); rect(330,110,300,350,5);
    stroke(0,255,0); rect(645,110,300,350,5);
    stroke(0,0,255); rect(960,110,300,350,5);
    
    // Draw position number
    strokeWeight(1);
    stroke(255); ellipse(15+40,110+40,50,50);
    stroke(255); ellipse(330+40,110+40,50,50);
    stroke(255); ellipse(645+40,110+40,50,50);
    stroke(255); ellipse(960+40,110+40,50,50);
    
    // Write Position - IN ELLIPSE
    textSize(20); textAlign(CENTER); fill(255);
    text("1st", 15+40, 157); 
    text("2nd", 330+40, 157); 
    text("3rd", 645+40, 157); 
    text("4th", 960+40, 157);
    
    // Write Racer Details - ROW 1: NAMES
    textSize(20); textAlign(CENTER); fill(255);
    text(racer[0], 165, 140); 
    text(racer[1], 480, 140); 
    text(racer[2], 795, 140); 
    text(racer[3], 1110, 140); 
    
    // Write Racer Details - ROW 2: FREQUENCIES
    textSize(18); textAlign(CENTER); fill(0);
    text("5665 MHz", 165, 170);
    text("5745 MHz", 480, 170);
    text("5885 Mhz", 795, 170);
    text("5945 MHz", 1110, 170);
    
    // Write Racer Details - ROW 3: CURRENT LAP
    textSize(16); textAlign(LEFT); fill(255);
    text("Current Lap: ", 35, 210); 
    text("Current Lap: ", 350, 210);
    text("Current Lap: ", 665, 210);
    text("Current Lap: ", 970, 210);
    textSize(18); textAlign(LEFT); fill(0);
    text("Lap " + currentLap(0) + ": " + currentLapTime(0), 35+125, 210);
    text("Lap " + currentLap(1) + ": " + currentLapTime(1), 350+125, 210);
    text("Lap " + currentLap(2) + ": " + currentLapTime(2), 665+125, 210);
    text("Lap " + currentLap(3) + ": " + currentLapTime(3), 970+125, 210);
    
    // Write Racer Details - ROW 4: FASTEST LAP
    textSize(16); textAlign(LEFT); fill(255);
    text("Fastest Lap: ", 35, 240);
    text("Fastest Lap: ", 350, 240);
    text("Fastest Lap: ", 665, 240);
    text("Fastest Lap: ", 970, 240);
    textSize(18); textAlign(LEFT); fill(0);
    if(fastLap[0]>0){text("Lap " + fastLap[0] + ": " + nf((fastLapTime[0]/1000),0,2), 35+125, 240);}
    if(fastLap[1]>0){text("Lap " + fastLap[1] + ": " + nf((fastLapTime[1]/1000),0,2), 350+125, 240);}
    if(fastLap[2]>0){text("Lap " + fastLap[2] + ": " + nf((fastLapTime[2]/1000),0,2), 665+125, 240);}
    if(fastLap[3]>0){text("Lap " + fastLap[3] + ": " + nf((fastLapTime[3]/1000),0,2), 970+125, 240);}   
    
    // Write Racer Details - ROW 5: FASTEST SPEED
    textSize(16); textAlign(LEFT); fill(255);
    text("Fast Lap Speed: ", 35, 270);
    text("Fast Lap Speed: ", 350, 270);
    text("Fast Lap Speed: ", 665, 270);
    text("Fast Lap Speed: ", 970, 270);
    
    // Display Last 5 Laps
    for(int i=0;i<4;i++){
      int printY = 320, j = 0;
      if(lap[i]<6){j=lap[i];} 
      else{j=6;}
      for(int k=1;k<j;k++){
        float lapTimePrint = (lapTime[i][(lap[i]-k)])/1000;
        String lapPrint = "Lap " + (lap[i]-k) + ": " + nf(lapTimePrint,0,2);
        text(lapPrint,printX[i],printY);
        printY = printY + 30;
      }
      
    }
    
    // Display Graph
    noStroke(); fill(0,0,50);
    rect(15,470,width-30,250);
    stroke(255,0,0); drawGraphLpf(0);
    stroke(255,255,0); drawGraphLpf(1);
    stroke(0,255,0); drawGraphLpf(2);
    stroke(0,0,255); drawGraphLpf(3);

    //RSSI Details
    textSize(16); textAlign(LEFT); fill(255);
    text("RSSI: " + nf(rssi[0],0,0), 35, 500);
    text("RSSI: " + nf(rssi[1],0,0), 350, 500);
    text("RSSI: " + nf(rssi[2],0,0), 665, 500);
    text("RSSI: " + nf(rssi[3],0,0), 970, 500);
    text("RSSI LPF: " + nf(rssiLpf[0],0,1), 35, 530);
    text("RSSI LPF: " + nf(rssiLpf[1],0,1), 350, 530);
    text("RSSI LPF: " + nf(rssiLpf[2],0,1), 665, 530);
    text("RSSI LPF: " + nf(rssiLpf[3],0,1), 970, 530);
    
    // END OF DRAW REFRESH LOOP
    tick = millis();
  }
  
}

// FOR EACH SERIAL EVENT
void serialEvent (Serial myPort) {
  if (calibrate == true){
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');
    if (inString != null) {
        inString = trim(inString); // Trim whitespace
        String inArray[] = splitTokens(inString); // Store string from RX5808 float array
        for (int i=0;i<4;i++){ 
          // Store RSSI and use LPF Filter
          rssi[i] = float(inArray[i]);
          rssiLpf[i] = LPF(rssiLpf[i],rssi[i],0.1);
          if(rssiLpf[i] > calibrateRssi[i]){
            calibrateRssi[i] = rssiLpf[i];
          }
        }
    }
  }
  
  if (start == true){
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');
    if (inString != null) {
      // Process the string recieved
      inTime = millis(); // Save time
      inString = trim(inString); // Trim whitespace
      String inArray[] = splitTokens(inString); // Store string from RX5808 float array
      
      for (int i=0;i<4;i++){ 
        // Store RSSI and use LPF Filter
        rssi[i] = float(inArray[i]); //<>//
        rssiLpf[i] = LPF(rssiLpf[i],rssi[i],0.1);
         //<>//
        // Store values into graph array
        arrayCopy(graphArray[i],1,graphArray[i],0,graphArray[i].length-1); // Move array to left for scrolling graph
        graphArray[i][graphArray[i].length-1] = map(rssi[i], rssiMin[i], rssiMax[i], 0, 220); // Store new values into end of array, and map to chart height
        arrayCopy(graphLpfArray[i],1,graphLpfArray[i],0,graphLpfArray[i].length-1); // Move array to left for scrolling graph
        graphLpfArray[i][graphLpfArray[i].length-1] = map(rssiLpf[i], rssiMin[i], rssiMax[i], 0, 220); // Store new values into end of array, and map to chart height
        
        // Check Lap Time Threshold
        if((rssiLpf[i] > threshold[i]) && (inTime-lapStart[i] > minLapTime*1000)){
          lapEnd[i] = inTime;
          lapTime[i][lap[i]] = lapEnd[i] - lapStart[i];
          
          // Check if lap is a fast lap
          if(lap[i]==1){
            fastLapTime[i] = lapTime[i][lap[i]];
            fastLap[i] = lap[i];
          }
          if(lapTime[i][lap[i]]<fastLapTime[i]){
            fastLapTime[i] = lapTime[i][lap[i]];
            fastLap[i] = lap[i];
          }
          
          lap[i]++;
          lapStart[i] = lapEnd[i];
        }
      }
    }
  }
}

// FUNCTIONS ----------------------------------------------------------------------------

// Start Button Function
void mousePressed(){
  // CHECK FOR START RACE BUTTON
  if (start == false && mouseX >= 540 && mouseX <= 740 && mouseY >= 310 && mouseY <= 410) {
    tick = millis();
    countdown = true;
  }
  // CHECK FOR CALIBRATION BUTTON
  if (start == false && mouseX >= 540 && mouseX <= 940 && mouseY >= 310 && mouseY <= 610) {
    calibrate = true;
  }
}

// Clear Function
void clearBelowHeader(){    
    // Clear below header section (90px to bottom)
    noStroke(); fill(47,85,151); rect(0,90,width,height);
}

// Start function - Start button pressed
void startTimer(){
  clearBelowHeader();
  fill(255);
  textSize(100);
  textAlign(CENTER,CENTER);
  if(millis()-tick<2000){if(beep<1){beep(1);beep++;};text("ARM",width/2,height/2);}
  else if(millis()-tick<3000){if(beep<2){beep(1);beep++;}text(".ARM.",width/2,height/2);}
  else if(millis()-tick<4000){if(beep<3){beep(1);beep++;}text("..ARM..",width/2,height/2);}
  else if(millis()-tick<5000){if(beep<4){beep(1);beep++;}text("...ARM...",width/2,height/2);}
  else if(millis()-tick<6000){if(beep<5){beep(1);beep++;}text("...READY...",width/2,height/2);}
  else if(millis()-tick<random(8,13)*1000){ // START RANDOMLY WITHIN 5 SEC WINDOW
      if(beep<6){beep(2);beep++;}
      text("RACE",width/2,height/2);
      float startTime = millis();
      for(int i=0;i<4;i++){
        lap[i] = 1;
        lapStart[i] = startTime;
      }
      countdown = false;
      start = true;
      clearBelowHeader();
  }
}

// Current Lap - Return current lap for a racer
int currentLap(int racer){
  int currentLap = lap[racer];
  return currentLap;
}

// Current Lap Time - Return current lap time for a racer
String currentLapTime(int racer){
  float currentLapTime = millis() - lapStart[racer]; // Calculate current time
  currentLapTime = currentLapTime/1000; // Convert from ms to s
  String currentLapTimeString = nf(currentLapTime,0,2); // Trim to 2 decimal places
  return currentLapTimeString;
}

// Fast Lap - Return fastest lap for a racer
float fastLap(int racer){
  float fastLap = 0;
  return fastLap;
}

// Average Speed - Returns average speed for a racer
float averageSpeed(int racer){
  float averageSpeed = 0;
  return averageSpeed;
}

// Laptimes - list the last 5 lap times
float[] lapTimes(int racer){
  float[] lapTimes = new float[5];
  return lapTimes;
}

//Position - return position of racer in race
int position(int racer){
  int position = 0;
  return position;
}

// Function to LPF the RSSI values
// filtered value = Previous Filtered RSSI - ( LPF_Factor * (Previous Filtered RSSI - New RSSI)
float LPF(float rssiOld, float rssiNew, float beta){
  rssiNew = rssiOld-(beta*(rssiOld-rssiNew));
  return rssiNew;
}

// Function to draw bar graph
void drawGraph(int i){
  int marginLeft = 20;
  int marginBottom = 10;
  for (int j=0;j<graphArray[i].length-1;j++){ //<>//
      line(j+marginLeft, height - graphArray[i][j] - marginBottom, j+marginLeft, height - graphArray[i][j+1] - marginBottom);  // Plot Line
  }
}
void drawGraphLpf(int i){
  int marginLeft = 20;
  int marginBottom = 10;
  for (int j=0;j<graphLpfArray[i].length-1;j++){
      line(j+marginLeft, height - graphLpfArray[i][j] - marginBottom, j+marginLeft, height - graphLpfArray[i][j+1] - marginBottom);  // Plot Line
  }
}

// Function Beep
void beep(int i){
  if(i==1){soundBeep1.play();}
  if(i==2){soundBeep2.play();}
}