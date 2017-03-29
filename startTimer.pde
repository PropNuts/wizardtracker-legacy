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
  else if(millis()-tick>random(8,13)*1000){ // START RANDOMLY WITHIN 5 SEC WINDOW
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