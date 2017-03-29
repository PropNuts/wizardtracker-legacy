// Function to LPF the RSSI values
// filtered value = Previous Filtered RSSI - ( LPF_Factor * (Previous Filtered RSSI - New RSSI)
float LPF(float rssiOld, float rssiNew, float beta){
  rssiNew = rssiOld-(beta*(rssiOld-rssiNew));
  return rssiNew;
}