void setCommPort(){
  if(drawOnceComm==false){
    textAlign(LEFT);
    textSize(24);
    text("Select comm port using keyboard:",20,170);
    textSize(20);
    for(int i=0;i<Serial.list().length;i++){
      text("["+i +"] " + Serial.list()[i],20,200+30*i);
    }  
    drawOnceComm=true;
  }

}