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


// Return Racer Position Function - Based on who has the fastest lap
String currentPosition(int racer){
  String position = "";
  float[] fastLapSorted = sort(fastLapTime);
  if (fastLapTime[racer]==0){position="--";}
  else if(fastLapTime[racer]==fastLapSorted[0]){position="1st";}
  else if(fastLapTime[racer]==fastLapSorted[1]){position="2nd";}
  else if(fastLapTime[racer]==fastLapSorted[2]){position="3rd";}
  else if(fastLapTime[racer]==fastLapSorted[3]){position="4th";}
  return position;
}