void drawMain(){
     background(47,85,151);
  
    // DRAW HEADER SECTION - STATIC, DOES NOT REDRAW
    image(logoImg,10,10);
    fill(255); textSize(30); textAlign(CENTER); text("WizardTrack Lap Timer",500,60);
    
    // DISPLAY START BUTTON AND WAIT
    fill(47,85,151);strokeWeight(3);stroke(255,0,0);rectMode(CENTER);rect(width/2,height/2,200,100,5);rectMode(CORNER);
    textSize(30);fill(255);textAlign(CENTER);text("Start Race",width/2,(height/2)+10);
  
    // DISPLAY CALIBRATE BUTTON
    fill(47,85,151);strokeWeight(3);stroke(255,0,0);rectMode(CENTER);rect(width/2,(height/2)+200,200,100,5);rectMode(CORNER);
    textSize(30);fill(255);textAlign(CENTER);text("Calibration",width/2,(height/2)+200+10);
}