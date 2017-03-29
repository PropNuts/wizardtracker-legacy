// MOUSE PRESS BUTTON ACTIONS
void mousePressed(){
  // CHECK FOR START RACE BUTTON
  if (start == false && mouseX >= 540 && mouseX <= 740 && mouseY >= 310 && mouseY <= 410) {
    tick = millis();
    countdown = true;
  }
  // CHECK FOR CALIBRATION BUTTON
  if (start == false && mouseX >= 540 && mouseX <= 740 && mouseY >= 510 && mouseY <= 610) {
    calibrate = true;
   }
  // CHECK FOR CALIBRATION SAVE BUTTON
  //if (start == false && calibrate == true && mouseX >= 540 && mouseX <= 740 && mouseY >= 310 && mouseY <= 410) {
  //  saveCalibration = true;
  //}
}