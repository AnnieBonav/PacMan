class PowerUps{
  int XPU, YPU, DPU;
  PowerUps(int tempXPU, int tempYPU){
    XPU = tempXPU;
    YPU = tempYPU;
    DPU=height/40;
  }
  void displayPU(int r, int g, int b, int t){
    fill (r, g, b);
    ellipse(XPU, YPU, DPU/2, DPU/2);
    fill(r, g, b, t);
    ellipse(XPU, YPU, DPU, DPU);
  }
}
