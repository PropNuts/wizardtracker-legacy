void drawCalibrationSave(){
    background(0);
    textAlign(LEFT); text("Calibrations Saved",100,100);
    for(int i=0;i<4;i++){
      threshold[i] = calibrateRssi[i];
    } 
    calibrate = false; saveCalibration = false;
    start = false; countdown = false;
    
}