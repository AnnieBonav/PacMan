class Player{
  int XP, YP, DP, SP, SW, SH;
  Player(int tempXP, int tempYP, int tempSP, int tempD){
  XP = tempXP;
  YP = tempYP;
  SP = tempSP;
  D = tempD;
  if (width>height){
    DP = height/40;
  }
  else{
    DP = width/50;//diameter
  }
  SW = width/40;
  SH= height/20;
  }
  
  void setXP (int xp) {XP = xp;}
  int getXP () {return XP;}
  
  void setYP (int yp) {YP = yp;}
  int getYP () {return YP;}
  
  void setDP (int dp) {DP = dp;}
  int getDP () {return DP;}
  
  
  void setSP (int sp) {SP = sp;}
  int getSP () {return SP;}
  
  void displayP (int r, int g, int b){
    fill (r, g, b);
    //ellipse (XP, YP, DP, DP);
    switch (D){
    case 0: arc(XP, YP, DP, DP, radians(0), radians(360)); break;
    case 1: arc(XP, YP, DP, DP, radians(-45), radians(225)); break;
    case 2: arc(XP, YP, DP, DP, radians(-225), radians(45)); break;
    case 3: arc(XP, YP, DP, DP, radians(45), radians(315)); break;
    case 4: arc(XP, YP, DP, DP, radians(-135), radians (135)); break;
    }
  }
  void limitsP(){
    if (XP-DP/2>width){XP=SW/2;}
    else if (XP<0){XP=SW*39+SW/2;}
    if (YP-DP/2>height){YP=SH/2;}
    else if (YP<0){YP=SH*19+SH/2;}
  }
  void resetP(){
    XP=SW*19+sw;
    YP=SH*12+sh;
  }
  
  /*void keyPressed () {
   switch (keyCode){
   case UP: YP=YP-SP; break;
   case DOWN: YP=YP+SP; break;
   case RIGHT: XP=XP+SP; break;    
   case LEFT: XP=XP-SP; break;
   default: break;
   }
  }
  */
}
