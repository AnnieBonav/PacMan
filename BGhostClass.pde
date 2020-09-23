class Ghost{
  int XG, YG, DiamG;
  float dG, DG;
  Ghost (int tempXG, int tempYG, float tempDG){
    XG = tempXG;
    YG = tempYG;
    DG = tempDG;
  if (width>height){DiamG = width/50;}
  else{DiamG=width/60;}
  }
  void displayG(int r, int g, int b, int trans){
    fill (r, g, b, trans);
    arc(XG, YG, DiamG, DiamG, radians(-225), radians(45), CHORD);
  }
  void limitsG(){
    if (XG-DiamG/2>width){XG=SW/2;}
    else if (XG<0){XG=SW*39+SW/2;}
    if (YG-DiamG/2>height){YG=SH/2;}
    else if (YG<0){YG=SH*19+SH/2;}
  }
  
  void resetG1(){
    XG=SW*17+sw;
    YG=SH*10+sh;
  }
  void resetG2(){
    XG=SW*18+sw;
    YG=SH*10+sh;
  }
  void resetG3(){
    XG=SW*21+sw;
    YG=SH*10+sh;
  }
  void resetG4(){
    XG=SW*22+sw;
    YG=SH*10+sh;
  }
}
