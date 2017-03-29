void drawTracker(){
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
    text(currentPosition(0), 15+40, 157); 
    text(currentPosition(1), 330+40, 157); 
    text(currentPosition(2), 645+40, 157); 
    text(currentPosition(3), 960+40, 157);
    
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
    textSize(18); textAlign(LEFT);
    if(currentLap(0)>1&&float(currentLapTime(0))<2){fill(255,0,0);}else{fill(0);} 
    text("Lap " + currentLap(0) + ": " + currentLapTime(0), 35+125, 210);
    if(currentLap(1)>1&&float(currentLapTime(1))<2){fill(255,0,0);}else{fill(0);} 
    text("Lap " + currentLap(1) + ": " + currentLapTime(1), 350+125, 210);
    if(currentLap(2)>1&&float(currentLapTime(2))<2){fill(255,0,0);}else{fill(0);} 
    text("Lap " + currentLap(2) + ": " + currentLapTime(2), 665+125, 210);
    if(currentLap(3)>1&&float(currentLapTime(3))<2){fill(255,0,0);}else{fill(0);} 
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
    
    // Display RSSI Bars
    noStroke(); fill(0,0,50);
    rect(15,470,width-30,250);
    
    for(int i=0;i<4;i++){
      float rssiDraw = map(rssi[i],rssiMin[i],rssiMax[i],0,200);
      float rssiLpfDraw = map(rssiLpf[i],rssiMin[i],rssiMax[i],0,200);
      float thresholdDraw = map(threshold[i],rssiMin[i],rssiMax[i],0,200);
      int xDraw = i*320;
      noStroke(); fill(255); rect(50+xDraw,height-rssiDraw,100,height);
      noStroke(); fill(255,255-constrain(map(rssiLpf[i],rssiMin[i],threshold[i],0,255),0,255),0); rect(160+xDraw,height-rssiLpfDraw,100,height);
      stroke(255,0,0); strokeWeight(2); line(35+xDraw,height-thresholdDraw,280+xDraw,height-thresholdDraw);
    }

    //RSSI Details
    textSize(16); textAlign(LEFT); fill(255);
    text("RSSI: " + nf(rssi[0],0,0), 25, 500);
    text("RSSI: " + nf(rssi[1],0,0), 340, 500);
    text("RSSI: " + nf(rssi[2],0,0), 655, 500);
    text("RSSI: " + nf(rssi[3],0,0), 960, 500);
    text("LPF: " + nf(rssiLpf[0],0,1), 125, 500);
    text("LPF: " + nf(rssiLpf[1],0,1), 440, 500);
    text("LPF: " + nf(rssiLpf[2],0,1), 755, 500);
    text("LPF: " + nf(rssiLpf[3],0,1), 1060, 500);
    text("TRS: " + nf(threshold[0],0,1), 225, 500);
    text("TRS: " + nf(threshold[1],0,1), 540, 500);
    text("TRS: " + nf(threshold[2],0,1), 855, 500);
    text("TRS: " + nf(threshold[3],0,1), 1160, 500);
    
    // END OF DRAW REFRESH LOOP
    tick = millis();
}