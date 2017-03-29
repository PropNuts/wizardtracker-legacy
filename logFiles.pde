// Function save race results to file
void saveResults(){
  logResults = createWriter(nf(hour(),2,0)+"_"+nf(minute(),2,0)+"_"+nf(second(),2,0)+"_logResults.txt"); // set output print file
  logResults.println("Lap \t"+racer[0]+"\t"+racer[1]+"\t"+racer[2]+"\t"+racer[3]);
  for(int i=0;i<max(lap);i++){
      logResults.println(i+1 +"\t"+nf(lapTime[0][i]/1000,0,2)+"\t"+nf(lapTime[1][i]/1000,0,2)+"\t"+nf(lapTime[2][i]/1000,0,2)+"\t"+nf(lapTime[3][i]/1000,0,2));
  }
  logResults.flush();
  logResults.close();
}