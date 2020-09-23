class Coin{
  int XC, YC, DC;
  
  Coin (int tempXC, int tempYC){
    XC = tempXC;
    YC = tempYC;
    if (width>1000){DC = height/50;}
    else{DC = height/70;}
  }
  void displayC(int r, int g, int b, int t){
    fill(r, g, b);
    ellipse(XC, YC, DC/2, DC/2);
    fill(r, g, b, t);
    ellipse(XC, YC, DC, DC);
  }
  void setXC (int xc) {XC=xc;}
  int getXC () {return XC;}
  
  void setYC (int yc) {YC = yc;}
  int getYC () {return YC;}
  
  void setDC (int dc) {DC = dc;}
  int getDC () {return DC;}
  
}
