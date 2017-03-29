void drawCalibration(){
    background(0);
    textAlign(LEFT);text("5665 MHz:",100,150);
    textAlign(LEFT);text("LPF:" + nf(rssiLpf[0],0,2),400,150);
    textAlign(LEFT);text("Calibrate:" + nf(calibrateRssi[0],0,2),400,200);
    
    textAlign(LEFT);text("5745 MHz:",100,300);
    textAlign(LEFT);text("LPF:" + nf(rssiLpf[1],0,2),400,300);
    textAlign(LEFT);text("Calibrate:" + nf(calibrateRssi[1],0,2),400,350);
    
    textAlign(LEFT);text("5885 MHz:",100,450);
    textAlign(LEFT);text("LPF:" + nf(rssiLpf[2],0,2),400,450);
    textAlign(LEFT);text("Calibrate:" + nf(calibrateRssi[2],0,2),400,500);
    
    textAlign(LEFT);text("5945 MHz:",100,600);
    textAlign(LEFT);text("LPF:" + nf(rssiLpf[3],0,2),400,600);
    textAlign(LEFT);text("Calibrate:" + nf(calibrateRssi[3],0,2),400,650);
    
    textAlign(LEFT);text("Press 'f' key to save calibration values",20,50);
    //fill(47,85,151);strokeWeight(3);stroke(255,0,0);rectMode(CENTER);rect(width/2,height/2,200,100,5);rectMode(CORNER);
    //textSize(30);fill(255);textAlign(CENTER);text("SAVE CALIBRATION",width/2,(height/2)+10); 
}