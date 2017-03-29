// KEYPRESS BUTTON ACTIONS
void keyPressed(){
  if(start==true && key=='f'){
    finish=true;
  }
  if(calibrate==true && key=='f'){
    saveCalibration=true;
  }
  
  if(start==true && key=='1'){keyRacer[0]=true;}
  if(start==true && key=='2'){keyRacer[1]=true;}
  if(start==true && key=='3'){keyRacer[2]=true;}
  if(start==true && key=='4'){keyRacer[3]=true;}
  if(start==true && key=='-'){keyAdjust[0]=true;}
  if(start==true && key=='='){keyAdjust[1]=true;}
  thresholdAdjust();
  
  if(setCommPort==false){
    commPort = key-48; //<>// //<>//
    if(commPort>-1 && commPort<Serial.list().length){
      myPort = new Serial(this, Serial.list()[commPort], 115200);
      myPort.bufferUntil('\n');
      setCommPort = true;
    }
  }
  
}

void keyReleased(){
  if(start==true && key=='1'){keyRacer[0]=false;}
  if(start==true && key=='2'){keyRacer[1]=false;}
  if(start==true && key=='3'){keyRacer[2]=false;}
  if(start==true && key=='4'){keyRacer[3]=false;}
  if(start==true && key=='-'){keyAdjust[0]=false;}
  if(start==true && key=='='){keyAdjust[1]=false;}
}

// Function check threshold adjustment
void thresholdAdjust(){
  for(int i=0;i<4;i++){
    if ((keyRacer[i]==true) && (keyAdjust[0]==true)){threshold[i]--;}
    if ((keyRacer[i]==true) && (keyAdjust[1]==true)){threshold[i]++;}
  }
}