// LAP TRACKER v1
// CREATED BY TONY FONG, PROPNUTS, 06/03/2017
// DISPLAY SET UP FOR 1280x1084

// SETUP
void setup(){
  // LOAD EXTERNAL DATA
  logoImg = loadImage("logo.png");
  soundBeep1 = new SoundFile(this, "beep2.wav");
  soundBeep2 = new SoundFile(this, "beep1.wav");
  
  // SETUP WINDOW
  size(1280,720);
  //fullScreen();
  background(47,85,151);
  
  // DRAW HEADER SECTION - STATIC, DOES NOT REDRAW
  image(logoImg,10,10);
  fill(255); textSize(30); textAlign(CENTER);text("WizardTrack Lap Timer",500,60);
  
  // SETUP DATA OUTPUT FILE
  //logRssi = createWriter("logRssi.txt"); // set output print file
  
  // LOAD SETTINGS FROM CSV
  String[] settingsCSVraw = loadStrings("settings.txt");
  for(int i=0;i<settingsCSVraw.length;i++){ //<>//
    String[] settingsCSVline = trim(splitTokens(settingsCSVraw[i],","));
    println(settingsCSVline[0]);
      if(settingsCSVline[0].equals("minLapTime") == true){minLapTime = float(settingsCSVline[1]);}
      if(settingsCSVline[0].equals("pilotName") == true){
        racer[0]=settingsCSVline[0];
        racer[1]=settingsCSVline[1];
        racer[2]=settingsCSVline[2];
        racer[3]=settingsCSVline[3];
      }
      if(settingsCSVline[0].equals("rssiThreshold") == true){
        threshold[0]=float(settingsCSVline[1]);
        threshold[1]=float(settingsCSVline[2]);
        threshold[2]=float(settingsCSVline[3]);
        threshold[3]=float(settingsCSVline[4]);
      }
      if(settingsCSVline[0].equals("rssiMin") == true){
        rssiMin[0]=float(settingsCSVline[1]);
        rssiMin[1]=float(settingsCSVline[2]);
        rssiMin[2]=float(settingsCSVline[3]);
        rssiMin[3]=float(settingsCSVline[4]);
      }
      if(settingsCSVline[0].equals("rssiMax") == true){
        rssiMax[0]=float(settingsCSVline[1]);
        rssiMax[1]=float(settingsCSVline[2]);
        rssiMax[2]=float(settingsCSVline[3]);
        rssiMax[3]=float(settingsCSVline[4]);
      }
      if(settingsCSVline[0].equals("lpfFactor") == true){
        lpfFactor = float(settingsCSVline[1]);
      }
      if(settingsCSVline[0].equals("calibrationMargin") == true){
        calibrationMargin = float(settingsCSVline[1]);
      }
  }

}

void draw(){
  // SET COMM PORT IF NOT
  if (setCommPort==false){
    setCommPort();
  } else {
    
  // NO STATES - DISPLAY MAIN SCREEN
  if (calibrate == false && saveCalibration == false && start == false){drawMain();}
  
  // CHECK IF CALIBRATE BUTTON HAS BEEN PRESSED
  if (calibrate == true){drawCalibration();}
  
  // CHECK IF CALIBRATION SAVE BUTTON HAS BEEN PRESSED
  if (saveCalibration == true){drawCalibrationSave();}
  
  // CHECK IF START BUTTON HAS BEEN PRESSED
  if (countdown == true){
    startTimer();
  }
  
  // CHECK IF RACE HAS STARTED
  // ONLY REDRAW IF MORE THAN 100MS SINCE LAST DRAW - TO REDUCE PROCESSING
  if (start == true && millis() > tick + drawPeriod){
    drawTracker();
    // CHECK IF FINISH BUTTON PRESSED
    if(finish==true){
      saveResults();
      finish = false;
      start = false;
    }  
  }
  
 }
}

// FOR EACH SERIAL EVENT
void serialEvent (Serial myPort) {
  
  // Process Data
  String inString = myPort.readStringUntil('\n');
  inTime = millis();
  inString = trim(inString);
  String inArray[] = splitTokens(inString);
  
  // CALIBRATION STATE
  if (calibrate == true && inString != null){
    for (int i=0;i<4;i++){ 
      rssi[i] = float(inArray[i]);
      rssiLpf[i] = LPF(rssiLpf[i],rssi[i],lpfFactor);
      if(calibrationMargin*rssiLpf[i] > calibrateRssi[i]){
        calibrateRssi[i] = rssiLpf[i]*calibrationMargin;
      }
    }
  }
  // END OF CALIBRATION STATE
  
  // TIMER START STATE
  if (start == true && inString != null){   
    for (int i=0;i<4;i++){ 
      // Store RSSI and use LPF Filter
      rssi[i] = float(inArray[i]);
      rssiLpf[i] = LPF(rssiLpf[i],rssi[i],lpfFactor);
      // Check if still in threshold and if rssi drops below then reset - this is to avoid lapping if remaining at the start line
      if((thresholdExit[i]==false) && (inTime-lapStart[i] > 1000) && (rssiLpf[i]<threshold[i])){
        if(thresholdExitTime[i]==0){
          thresholdExitTime[i] = millis();
        }
        else if(millis()-thresholdExitTime[i]>minLapTime*1000){
          // Check that we have been out of threshold for the minLapTime
          thresholdExit[i]=true;
          thresholdExitTime[i]=0;
        }
      }
      // Check if threshold is re-entered within the min lap time, if so then re-set threshold exit time
      if((thresholdExit[i]==false) && (rssiLpf[i]>threshold[i]) && (millis()-thresholdExitTime[i]<minLapTime*1000)){
        thresholdExitTime[i] = millis();
      }
      
      // Check Lap Time Threshold
      else if((rssiLpf[i] > threshold[i]) && (inTime-lapStart[i] > minLapTime*1000) && (thresholdExit[i]==true)){
        thresholdExit[i] = false;
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
        // Increment lap and save time for next loop
        lap[i]++;
        lapStart[i] = lapEnd[i];
        }
      }
    }
    // END OF TIMER START STATE
  
}

// FUNCTIONS ----------------------------------------------------------------------------

// Clear Function
void clearBelowHeader(){    
    // Clear below header section (90px to bottom)
    noStroke(); fill(47,85,151); rect(0,90,width,height);
}

// Function Beep
void beep(int i){
  if(i==1){soundBeep1.play();}
  if(i==2){soundBeep2.play();}
}