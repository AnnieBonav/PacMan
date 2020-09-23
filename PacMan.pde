import ddf.minim.*;
import processing.sound.*;

SoundFile eatCoin;
SoundFile screenGameLevel1;
SoundFile screenGameLevel2;
SoundFile screenGameLevel3;
SoundFile screenGamePU;

Minim soundengine;
Minim minim;

AudioPlayer splashScreen;
AudioPlayer screenGameIntro;
AudioPlayer screenWin;
AudioPlayer screenLoose;

SoundFile songDiePM;
SoundFile songDieGhost;

Player p1;
Ghost g1, g2, g3, g4;

int [] move = new int [4];
Coin[][]COINS;
PowerUps[][]PASTILLAS;
int cols = 39; int rows = 19;
int SW, W, SH, H, a, w, SP, score, sw, sh;//Score: cuánto lleva el jugador de puntos, contando a los fantasmas comidos
int d, D;
boolean startGame, winGame, looseGame, screenS, PUActive; //boundaries
StringList laberinto;

int lives=3;
int numCoins=0;//Cotador de monedas comidas, va de uno en uno, es del que depende el cambio de nivel
int numPu=0;
int pantalla=0;
int level=1;

int red, green, blue; //colores que toma mi pac man (seleccionados con keypressed)

int savedTime;//Hora ahorita en milisegundos
int PUTime = 15000; //Tiempo que dura el power up en mili segundos
int trans = 100;

void setup(){
  fullScreen();
 // size(900, 600);
  background(0);
  SH = height/20; SW = width/40;
  sh=SH/2; sw=SW/2;
  a=10; SP=1; 
  d=0; 
  D=0;
  score=0;
  startGame=true;
  screenS=true;
  winGame=true;
  looseGame=true;
  PUActive=false;
  
  minim = new Minim (this);
  
  splashScreen = minim.loadFile("screenMenu.mp3");
  screenGameIntro = minim.loadFile ("screenGame.mp3");
  screenWin = minim.loadFile ("WeAreTheChampionsComplete.mp3");
  screenLoose = minim.loadFile ("WhoWantsToLive.mp3");
  
  screenGameLevel1 = new SoundFile (this, "PacManOriginal.mp3");
  screenGameLevel2 = new SoundFile (this, "PacManOriginal.mp3");
  screenGameLevel3 = new SoundFile (this, "PacManOriginal.mp3");
  screenGamePU = new SoundFile (this, "PacManOriginal.mp3");
  
  eatCoin = new SoundFile (this, "Eat.mp3");
  
  songDiePM = new SoundFile (this, "DiePM.mp3");
  songDieGhost = new SoundFile (this, "DieGhost.mp3");
  
  if (width>1000){w=4;}
  else{w=2;}

  laberinto = new StringList();
  
  p1 = new Player(SW*19+sw, SH*12+sh, 1, D);
  
  g1 = new Ghost (SW*17+sw, SH*8+sh, 1);
  g2 = new Ghost (SW*18+sw, SH*8+sh, 2);
  g3 = new Ghost (SW*21+sw, SH*8+sh, 3);
  g4 = new Ghost (SW*22+sw, SH*8+sh, 4);
  
  COINS = new Coin[cols][rows];
  for (int i=1;i<cols; i++){
    for (int j=1; j<rows; j++){
      COINS [i] [j] = new Coin(i*SW+SW/2, j*SH+SH/2);}
  }
  PASTILLAS = new PowerUps[cols][rows];
  for (int i=1;i<39; i+=37){
    for (int j=1; j<19; j+=17){
      PASTILLAS [i] [j] = new PowerUps(i*SW+SW/2, j*SH+SH/2);}
  }
//Cuando horizontales, se suma sw y multiplica valor sobre "y"
//Cuando son verticales, se suma sh y mutiplica valor sobre "x"
  
  //dos verticales se hacen con::
//MARCO y centro
//Marco arriba y abajo
for (int i=1; i<40; i++){
    laberinto.append(str(SW*i+sw)+str(SH*1));
    laberinto.append(str(SW*i+sw)+str(SH*19));}
//Centro linea izuqierda
for (int i=5; i<15; i++){
    laberinto.append(str(SW*i+sw)+str(SH*10));}
//Centro línea derecha
for (int i=25; i<35; i++){
    laberinto.append(str(SW*i+sw)+str(SH*10));}
    
//Horizontal arriba centro lado izquierdo
for(int i=15; i<19; i++){
  laberinto.append(str(SW*i+sw)+str(SH*9));}
  //Horizontal arriba centro lado derecho
for(int i=21; i<25; i++){
  laberinto.append(str(SW*i+sw)+str(SH*9));}
//Horizontal abajo centro
for (int i=15; i<25; i++){
    laberinto.append(str(SW*i+sw)+str(SH*11));}

//Centro verticales
for (int i=15; i<26; i=i+10){//Donde aparecen tomando "x"
  for (int j=9; j<11; j++){ //distancia arriba abajo
    laberinto.append(str(SW*i)+str(SH*j+sh));}}
 
  //4 verticales se hacen con::
//Marco izquierda y derecha
for (int i=1; i<40; i=i+38){ //donde aparecen
  for (int j=1; j<9; j++){
    laberinto.append(str(SW*i)+str(SH*j+sh));}
  for (int j=11; j<20; j++){
    laberinto.append(str(SW*i)+str(SH*j+sh));}}
      
  //2 verticales dobles se hacen con::
//PARA HORIZONTALES cambia nombre, va de arriba a abajo
//Primera
for (int i=2; i<19; i=i+16){//Donde aparecen tomando "y"
  for (int j=3; j<19; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=21; j<37; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//SEGUNDA
for (int i=3; i<18; i=i+14){//Donde aparecen tomando y
  for (int j=13; j<19; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=21; j<27; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//TERCERA
for (int i=4; i<17; i=i+12){//Donde aparecen tomando y
  for (int j=13; j<17; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=23; j<27; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//CUARTA
for (int i=5; i<16; i=i+10){//Donde aparecen tomando y
  for (int j=7; j<18; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=22; j<33; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//Quinta
for (int i=6; i<15; i=i+8){//Donde aparecen tomando y
  for (int j=3; j<19; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=21; j<37; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//SEXTA izquierda
for (int i=7; i<14; i=i+6){//Donde aparecen tomando y
  for (int j=3; j<5; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=35; j<37; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//Sexta Derecha
for (int i=7; i<14; i=i+6){//Donde aparecen tomando y
  for (int j=10; j<18; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=22; j<30; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//Séptima
for (int i=8; i<14; i=i+4){//Donde aparecen tomando y
  for (int j=9; j<19; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=21; j<31; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
//Octava
for (int i=9; i<14; i=i+2){//Donde aparecen tomando y
  for (int j=10; j<14; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*j+sw)+str(SH*i));}
  for (int j=26; j<30; j++){
    laberinto.append(str(SW*j+sw)+str(SH*i));}}
    
//Pegado a marco
//Verticales esquinas
for (int i=2; i<39; i=i+36){ //donde aparecen tomando x
  for (int j=2; j<7; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}
  for (int j=13; j<18; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}}
//verticales junto salida
for (int i=5; i<36; i=i+30){ //donde aparecen
  for (int j=7; j<9; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}
  for (int j=11; j<13; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}}
    
//MEDIO
//Verticales en medio hasta arriba y hasta abajo
for (int j=1; j<3; j++){
    laberinto.append(str(SW*20)+str(SH*j+sh));}
for (int j=17; j<20; j++){
    laberinto.append(str(SW*20)+str(SH*j+sh));}
//verticales en medio segundas abajo
for (int j=5; j<7; j++){
    laberinto.append(str(SW*20)+str(SH*j+sh));}
for (int j=13; j<15; j++){
    laberinto.append(str(SW*20)+str(SH*j+sh));}
    
//verticales centro lados primeras
for (int i=19; i<22; i=i+2){ //donde aparecen
  for (int j=3; j<5; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}
  for (int j=15; j<17; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}}
//verticales centro lados primeras más fuera
for (int i=18; i<25; i=i+4){ //donde aparecen
  for (int j=4; j<5; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}
  for (int j=15; j<16; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}}
//verticales centro lados segundas abajo
for (int i=19; i<22; i=i+2){ //donde aparecen
  for (int j=6; j<7; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}
  for (int j=13; j<14; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));}}
        
   //4 horizontales ::
//Rect horizontales (salida)
for (int i=0; i<4; i++){ //Tamaño
  for (int j=8; j<10; j++){ //distancia entre arriba y abajo
    laberinto.append(str(SW*i+sw)+str(SH*j));
    laberinto.append(str(SW*(i+36)+sw)+str(SH*j));}
  for (int j=11; j<13; j++){
    laberinto.append(str(SW*i+sw)+str(SH*j));
    laberinto.append(str(SW*(i+36)+sw)+str(SH*j));}}
//Vertical salida
for (int i=0; i<5; i=i+4){//distancia de dónde aparece en x derecha izquierda (del mismo)
  for (int j=8; j<9; j++){//tamaño vertical
    laberinto.append(str(SW*i)+str(SH*j+sh));
    laberinto.append(str(SW*(i+36))+str(SH*j+sh));}//i+posicion-i inicial
  for (int j=11; j<12; j++){
    laberinto.append(str(SW*i)+str(SH*j+sh));
    laberinto.append(str(SW*(i+36))+str(SH*j+sh));}}//i+posicion-i inicial

//Rect horizontales esquinas
  for (int i=3; i<6; i++){ //tamaño
   for (int j=3; j<6; j=j+2){ //distancia entre arriba y abajo
     laberinto.append(str(SW*i+sw)+str(SH*j));
     laberinto.append(str(SW*(i+31)+sw)+str(SH*j));}//i+posicion-i inicial
   for (int j=15; j<18; j=j+2){
     laberinto.append(str(SW*i+sw)+str(SH*j));
     laberinto.append(str(SW*(i+31)+sw)+str(SH*j));}}
  //Vertical rect esquinas
  for (int i=3; i<7; i=i+3){//distancia de dónde aparece en x derecha izquierda (del mismo)
   for (int j=3; j<5; j++){//tamaño vertical
     laberinto.append(str(SW*i)+str(SH*j+sh));
     laberinto.append(str(SW*(i+31))+str(SH*j+sh));}//i+posicion-i inicial
   for (int j=15; j<17; j++){
     laberinto.append(str(SW*i)+str(SH*j+sh));
     laberinto.append(str(SW*(i+31))+str(SH*j+sh));}}//i+posicion-i inicial
   
   //Rect horizontales esquinas segundo
   for (int i=7; i<12; i++){ //tamaño
    for (int j=3; j<5; j++){ //distancia entre arriba y abajo
      laberinto.append(str(SW*i+sw)+str(SH*j));
      laberinto.append(str(SW*(i+21)+sw)+str(SH*j));}//i+posicion-i inicial
    for (int j=16; j<18; j++){
      laberinto.append(str(SW*i+sw)+str(SH*j));
      laberinto.append(str(SW*(i+21)+sw)+str(SH*j));}}  
  //Vertical rect esquinas segundo
  for (int i=7; i<14; i=i+5){//distancia de dónde aparece en x derecha izquierda (del mismo)
   for (int j=3; j<4; j++){//tamaño vertical
     laberinto.append(str(SW*i)+str(SH*j+sh));
     laberinto.append(str(SW*(i+21))+str(SH*j+sh));}//i+posicion-i inicial
   for (int j=16; j<17; j++){
     laberinto.append(str(SW*i)+str(SH*j+sh));
     laberinto.append(str(SW*(i+21))+str(SH*j+sh));}}//i+posicion-i inicial
      
  //Rect horizontales centro lados
  for (int i=6; i<9; i++){ //tamaño horizontal
    for (int j=7; j<10; j=j+2){ //distancia entre arriba y abajo
      laberinto.append(str(SW*i+sw)+str(SH*j));
      laberinto.append(str(SW*(i+25)+sw)+str(SH*j));}//i+posicion-i inicial
    for (int j=11; j<14; j=j+2){
      laberinto.append(str(SW*i+sw)+str(SH*j));
      laberinto.append(str(SW*(i+25)+sw)+str(SH*j));}}
      
  //Rect vertical centro lados
  for (int i=6; i<10; i=i+3){//distancia de dónde aparece en x derecha izquierda (del mismo)
    for (int j=7; j<9; j++){//tamaño vertical
      laberinto.append(str(SW*i)+str(SH*j+sh));
      laberinto.append(str(SW*(i+25))+str(SH*j+sh));}//i+posicion-i inicial
    for (int j=11; j<13; j++){
      laberinto.append(str(SW*i)+str(SH*j+sh));
      laberinto.append(str(SW*(i+25))+str(SH*j+sh));}}//i+posicion-i inicial
   
  println(laberinto);
  move[0]=1;
  move[1]=5;
  move[2]=10;
}


void resetLevel(){
  startGame=true;
  winGame=true;
  looseGame=true;
  numCoins=0;
  screenGameLevel1.stop();

  if (level>1){
    for (int i=1;i<cols; i++){
      for (int j=1; j<rows; j++){
        if (COINS[i][j].YC<0){
          COINS[i][j].YC=COINS[i][j].YC+height;
        }
      }
    }
    for (int i=1;i<39; i+=37){
      for (int j=1; j<19; j+=17){
        if (PASTILLAS[i][j].YPU<0){
          PASTILLAS[i][j].YPU=PASTILLAS[i][j].YPU+height;
        }
      }
    }
    p1.XP=SW*19+sw;
    p1.YP=SH*12+sh;
    p1.SP=1;
  }
}


void draw (){
  if (level>3){
    pantalla=3;}
  if (PUActive==true){
    if (millis()-savedTime>PUTime){
      PUActive=false;
      screenGamePU.stop();
     }
  }
  switch(pantalla){
    case 0:
      screenWin.pause();
      screenLoose.pause();
      if (screenS==true){
        splashScreen.loop();
        screenS=false;}
      menu();
      break;
    case 1: 
      if (startGame==true){
        screenGameIntro.play();
        startGame=false;
        if (level==1){
          screenGameLevel1.loop(0.7);
        }
        if (level==2){
          screenGameLevel2.loop(1);
         }
        if (level==3){
          screenGameLevel3.loop(1.5);
        }        
      }
      switch (level){
        case 1: 
          game(255, 0, 0);
          break;
        case 2: 
          screenGameLevel1.stop();
          screenGameLevel3.stop();
          game(0, 0, 255); 
          break;
        case 3: 
          screenGameLevel1.stop();
          screenGameLevel2.stop();
          game(0, 255, 0); 
          break;
      }
      break;
    case 2:
      screenGameLevel1.stop();
      screenGameLevel2.stop();
      screenGameLevel3.stop();
      if (looseGame==true){
        screenLoose.loop();
        looseGame=false;
      }
      gameOver(); 
      break;
    case 3:
      screenGameLevel1.stop();
      screenGameLevel2.stop();
      screenGameLevel3.stop();
      if (winGame==true){
        screenWin.loop();
        winGame=false;
      }
      gameWin();
      break;
  }
}

void game(int r, int g, int b){
  splashScreen.pause();
  background (0);
  noStroke();
  fill(250, 180, 10);
  
  for (int i=1;i<cols; i++){
    for (int j=1; j<rows; j++){
      COINS[i][j].displayC(250, 180, 10, 50);}
    }
  for (int i=1;i<39; i+=37){
    for (int j=1; j<19; j+=17){
      PASTILLAS[i][j].displayPU(0, 0, 255, 50);}
    }
  //COLISIONES  MONEDAS
  for (int i=1; i<cols; i++){
    for(int j=1; j<rows; j++){
    if (p1.XP+p1.DP/2>COINS[i][j].XC-COINS[i][j].DC/2
    && p1.XP-p1.DP/2<COINS[i][j].XC+COINS[i][j].DC/2
    && p1.YP+p1.DP/2>COINS[i][j].YC-COINS[i][j].DC/2
    && p1.YP-p1.DP/2<COINS[i][j].YC+COINS[i][j].DC/2)
    {
      //Moneda comida se mueve fuera de la pantalla.
      COINS[i][j].YC=COINS[i][j].YC-height;
      
      //Cada moneda incrementa en 10 el Score.
      score+=10;
      numCoins++;
      
      //Cada 1000 puntos aumenta una vida (100 monedas = 1000 puntos).
      if (numCoins%100==0){lives++;}
      
      if (numCoins>=584){
        level++;
        resetLevel();
      }
      eatCoin.play();
    }
   }
  }
 // COLISIONES PowerUp
  if (numPu<4){
    for (int i=1;i<39; i+=37){
      for (int j=1; j<19; j+=17){
        if (p1.XP+p1.DP/2>PASTILLAS[i][j].XPU-PASTILLAS[i][j].DPU/2
          && p1.XP-p1.DP/2<PASTILLAS[i][j].XPU+PASTILLAS[i][j].DPU/2
          && p1.YP+p1.DP/2>PASTILLAS[i][j].YPU-PASTILLAS[i][j].DPU/2
          && p1.YP-p1.DP/2<PASTILLAS[i][j].YPU+PASTILLAS[i][j].DPU/2)
        {
          if(PUActive==true){
            screenGamePU.stop();
            PASTILLAS[i][j].YPU=PASTILLAS[i][j].YPU-height;
            numPu++;
            savedTime=millis();
            screenGamePU.loop();
          }else{
        PASTILLAS[i][j].YPU=PASTILLAS[i][j].YPU-height;
        numPu++;
        savedTime=millis();
        PUActive=true;
        screenGamePU.loop();
          } 
        }
      }
    }
  }
  //Colisión fantasma 1
  if (p1.XP+p1.DP/2>g1.XG-g1.DG/2
     && p1.XP-p1.DP/2<g1.XG+g1.DG/2
     && p1.YP+p1.DP/2>g1.YG-g1.DG/2
     && p1.YP-p1.DP/2<g1.YG+g1.DG/2)
    {
      if (PUActive==true){
        g1.resetG1();
        score+=100;
        songDieGhost.play();
      }else{
        p1.resetP();
        songDiePM.play();
        lives--;
        d=0;
        D=0;
       }
   }
   //Colisión Fantasma 2
   if (p1.XP+p1.DP/2>g2.XG-g2.DG/2
     && p1.XP-p1.DP/2<g2.XG+g2.DG/2
     && p1.YP+p1.DP/2>g2.YG-g2.DG/2
     && p1.YP-p1.DP/2<g2.YG+g2.DG/2)
    {
      if (PUActive==true){
        g2.resetG2();
        score+=100;
        songDieGhost.play();
      }else{
        p1.resetP();
        songDiePM.play();
        lives--;
        d=0;
        D=0;
       }
   }
   //Colisión Fantasma 3
   if (p1.XP+p1.DP/2>g3.XG-g3.DG/2
     && p1.XP-p1.DP/2<g3.XG+g3.DG/2
     && p1.YP+p1.DP/2>g3.YG-g3.DG/2
     && p1.YP-p1.DP/2<g3.YG+g3.DG/2)
    {
      if (PUActive==true){
        g3.resetG3();
        score+=100;
        songDieGhost.play();
      }else{
        p1.resetP();
        songDiePM.play();
        lives--;
        d=0;
        D=0;
       }
   }
   //Colisión Fantasma 4
   if (p1.XP+p1.DP/2>g4.XG-g4.DG/2
     && p1.XP-p1.DP/2<g4.XG+g4.DG/2
     && p1.YP+p1.DP/2>g4.YG-g4.DG/2
     && p1.YP-p1.DP/2<g4.YG+g4.DG/2)
    {
      if (PUActive==true){
        g4.resetG4();
        score+=100;
        songDieGhost.play();
      }else{
        p1.resetP();
        songDiePM.play();
        lives--;
        d=0;
        D=0;
       }
   }
  if(PUActive==true){
    trans=50;
  }else{
    trans=100;
  }
  if (lives<=0){pantalla=2;}
  fill(255);
  textSize(10);
  textAlign(CENTER);
//CBM
  text (width, SW*1, (SH/3)*2);
  text (height, SW*3, (SH/3)*2);
  text ("p1XP="+str(p1.XP), SW*5, (SH/3)*2);
  text ("p1YP="+p1.YP, SW*7, (SH/3)*2);
  text ("SP="+SP, SW*9, (SH/3)*2);
  text ("p1XP+SW="+round((p1.XP+SW)), SW*11, (SH/3)*2);
  text ("p1YP+SH="+round((p1.YP+SH)), SW*13, (SH/3)*2);
  text ("numCoins="+str(numCoins),SW*15,(SH/3)*2);
  
  textSize(SH/2);
  text ("Score: "+str(score) + " " +
        "Vidas: " + str(lives) + " " + 
        "Nivel: " + str(level), SW*21, (SH/3)*2);
//FIN CBM
textSize(SH/2);
  fill(255);
  //MOVIMIENTO PAC MAN
  if(D==1){
    if (laberinto.hasValue(str(p1.XP)+str(p1.YP-sh))==false){p1.YP=p1.YP-SH; d=D;}
       else {D=d;}}
    
  else if (D==2){
    if (laberinto.hasValue(str(p1.XP)+str(p1.YP+sh))==false){p1.YP=p1.YP+SH; d=D;}
       else {D=d;}}
    
  else if (D==3){
    
    if (laberinto.hasValue(str(p1.XP+sw)+str(p1.YP))==false){p1.XP=p1.XP+SW; d=D;}
       else {D=d;}}
      
  else if (D==4){
    if (laberinto.hasValue(str(p1.XP-sw)+str(p1.YP))==false) {p1.XP=p1.XP-SW; d=D;}
      else {D=d;}}
      
  //MOVIMIENTO Ghost1
  if (abs(g1.XG-p1.XP)>abs(g1.YG-p1.YP)){
    if((g1.XG-p1.XP)<0){
      if (PUActive==false){
        g1.dG=3;
      }else{
        g1.dG=4;
      }
    }else{
      if (PUActive==false){
        g1.dG=4;
      }else{
        g1.dG=3;
      }
    }
  }else{
    if((g1.YG-p1.YP)<0){
      if (PUActive==false){
        g1.dG=2;
      }else{
        g1.dG=1;
      }
    }else{
      if (PUActive==false){
        g1.dG=1;
      }else{
        g1.dG=2;
      }
    }
  }
  switch (int (g1.dG)){
    case 1:
      if (laberinto.hasValue(str(g1.XG)+str(g1.YG-sh))==false){
         g1.DG=g1.dG;
      }
     break;
     case 2: 
       if (laberinto.hasValue(str(g1.XG)+str(g1.YG+sh))==false){
          g1.DG=g1.dG;
       }
       break;
     case 3:
      if (laberinto.hasValue(str(g1.XG+sw)+str(g1.YG))==false){
         g1.DG=g1.dG;
       }
       break;
      case 4:
        if (laberinto.hasValue(str(g1.XG-sw)+str(g1.YG))==false){
           g1.DG=g1.dG;
        }
        break;
      default: 
        g1.DG=1; 
        break;
   }
   
   switch (int (g1.DG)){
    case 1:
      if (laberinto.hasValue(str(g1.XG)+str(g1.YG-sh))==false){
         g1.YG=g1.YG-SH;
      }else{
        g1.DG=random(0,4);
      };
     break;
     case 2: 
       if (laberinto.hasValue(str(g1.XG)+str(g1.YG+sh))==false){
          g1.YG=g1.YG+SH;
       }else{
         g1.DG=random(0,4);
       };
       break;
     case 3:
      if (laberinto.hasValue(str(g1.XG+sw)+str(g1.YG))==false){
         g1.XG=g1.XG+SW;
       }else{
         g1.DG=random(0,4);
       };
       break;
      case 4:
        if (laberinto.hasValue(str(g1.XG-sw)+str(g1.YG))==false){ //<>//
           g1.XG=g1.XG-SW;
        }else{
          g1.DG=random(0,4);
        };
        break;
      default: 
        g1.DG=1; 
        break;
   }
   
   //MOVIMIENTO Ghost2
  if (abs(g2.XG-p1.XP)>abs(g2.YG-p1.YP)){
    if((g2.XG-p1.XP)<0){
      if (PUActive==false){
        g2.dG=3;
      }
      else {
        g2.dG=4;
      }
    }else{
      if (PUActive==false){
        g2.dG=4;
      }
      else {
        g2.dG=3;
      }
    }
  }else{
    if((g2.YG-p1.YP)<0){
      if (PUActive==false){
        g2.dG=2;
      }
      else {
        g2.dG=1;
      }
    }else{
      if (PUActive==false){
        g2.dG=1;
      }
      else {
        g2.dG=2;
      }
    }
  }
  switch (int (g2.dG)){
    case 1:
      if (laberinto.hasValue(str(g2.XG)+str(g2.YG-sh))==false){
         g2.DG=g2.dG;
      }
     break;
     case 2: 
       if (laberinto.hasValue(str(g2.XG)+str(g2.YG+sh))==false){
          g2.DG=g2.dG;
       };
       break;
     case 3:
      if (laberinto.hasValue(str(g2.XG+sw)+str(g2.YG))==false){
         g2.DG=g2.dG;
       }
       break;
      case 4:
        if (laberinto.hasValue(str(g2.XG-sw)+str(g2.YG))==false){
           g2.DG=g2.dG;
        }
        break;
      default: 
        g2.DG=1; 
        break;
   }
   
   switch (int (g2.DG)){
    case 1:
      if (laberinto.hasValue(str(g2.XG)+str(g2.YG-sh))==false){
         g2.YG=g2.YG-SH;
      }else{
         g2.DG=random(0,4);
       };
     break;
     case 2: 
       if (laberinto.hasValue(str(g2.XG)+str(g2.YG+sh))==false){
          g2.YG=g2.YG+SH;
       }else{
         g2.DG=random(0,4);
       };
       break;
     case 3:
      if (laberinto.hasValue(str(g2.XG+sw)+str(g2.YG))==false){
         g2.XG=g2.XG+SW;
       }else{
         g2.DG=random(0,4);
       };
       break;
      case 4:
        if (laberinto.hasValue(str(g2.XG-sw)+str(g2.YG))==false){
           g2.XG=g2.XG-SW;
        }else{
          g2.DG=random(0,4);
        };
        break;
      default: 
        g2.DG=1; 
        break;
   }
  //Marco limits
  fill(0);
    rect(SW*15,SH*9,SW*10,SH*2, a); //Rect centro
  stroke(r, g, b);
  strokeWeight(w);
    line(SW*15, SH*9, SW*19, SH*9); //Horizontal arriba centro mitad izquierda
    line(SW*21, SH*9, SW*25, SH*9); //Horizontal arriba centro mitad derecha
    line(SW*15, SH*11, SW*25, SH*11); //Horizontal abajo centro
    line(SW*15, SH*9, SW*15, SH*11); //vertical izquierda centro
    line(SW*25, SH*9, SW*25, SH*11); //vertical derecha centro
    
    line(SW,SH,SW*39,SH); //Horizontal Hasta arriba
    line(SW,SH*19,SW*39,SH*19); //Horizontal Hasta abajo
    line(SW,SH,SW,SH*8); //Vertical Izquierda arriba
    line(SW,SH*12,SW,SH*19); //Vertical Izquierda abajo
    line(SW*39,SH,SW*39,SH*8); //Vertical derecha arriba
    line(SW*39,SH*12,SW*39,SH*19); //Vertical derecha abajo
  
    line(SW*20,SH*1,SW*20,SH*3); //Vertical En medio hasta arriba
    line(SW*20,SH*17,SW*20,SH*19); //Vertical En medio hasta abajo     
  
    rect(0,SH*8,SW*4,SH, a); //Rect horizontal laterales izquierda arriba 
    rect(0,SH*11,SW*4,SH, a); //Rect horizontal laterales izquierda abajo
    rect(SW*36,SH*8,SW*4,SH, a); //Rect horizontal laterales derecha arriba
    rect(SW*36,SH*11,SW*4,SH, a); //Rect horizontal laterales derecha abajo
 
  //ESQUINAS
    rect(SW*3,SH*3,SW*3,SH*2,a); //rect arriba izquierda
    rect(SW*34,SH*3,SW*3,SH*2,a); //rect arriba derecha
    rect(SW*3,SH*15,SW*3,SH*2,a); //rect abajo izquierda
    rect(SW*34,SH*15,SW*3,SH*2,a); //rect abajo derecha
      
    rect(SW*7,SH*3,SW*5,SH,a); //rect arriba izquierda segundo
    rect(SW*28,SH*3,SW*5,SH,a); //rect arriba derecha segundo
    rect(SW*7,SH*16,SW*5,SH,a); //rect abajo izquierda segundo
    rect(SW*28,SH*16,SW*5,SH,a); //rect abajo derecha segundo
  
  //CENTRO  
  
  //Vertical rect centros
      
    rect(SW*6,SH*7,SW*3,SH*2, a); //Rect centro izquierda arriba
    rect(SW*6,SH*11,SW*3,SH*2, a); //Rect centro izquierda abajo
    rect(SW*31,SH*7,SW*3,SH*2, a); //Rect centro derecha arriba
    rect(SW*31,SH*11,SW*3,SH*2, a); //Rect centro derecha abajo
  
  
  //Inside
    line(SW*9,SH*8,SW*19,SH*8); //Horizontal Arriba rect centro izquierda
    line(SW*21,SH*8,SW*31,SH*8); //Horizontal Arriba rect centro derecha
    line(SW*9,SH*12,SW*19,SH*12); //Horizontal Arriba rect centro izquierda
    line(SW*21,SH*12,SW*31,SH*12); //Horizontal Arriba rect centro derecha
  
  
    line(SW*20,SH*5,SW*20,SH*7); //Vertical En medio arriba
    line(SW*20,SH*13,SW*20,SH*15); //Vertical En medio abajo
  
  //ESQUINAS
    line(SW*3,SH*2,SW*19,SH*2); //Horizontal segundo Arriba izquierda
    line(SW*21,SH*2,SW*37,SH*2); //Horizontal segundo Arriba derecha
    line(SW*2,SH*2,SW*2,SH*7); //Vertical segundo Izquierda arriba
    line(SW*38,SH*2,SW*38,SH*7); //Vertical segundo derecha arriba      
      
    line(SW*3,SH*18,SW*19,SH*18); //Horizontal segundo abajo izquierda
    line(SW*21,SH*18,SW*37,SH*18); //Horizontal segundo abajo derecha
    line(SW*2,SH*13,SW*2,SH*18); //vertical segundo abajo izquierda
    line(SW*38,SH*13,SW*38,SH*18); //vertical segundo abajo derecha
  
  //MIDDLE
    line(SW*3,SH*6,SW*19,SH*6); //Horizontal middle arriba izquierda
    line(SW*21,SH*6,SW*37,SH*6); //Horizontal middle arriba derecha
  
    line(SW*3,SH*7,SW*5,SH*7); //Horizontal middle primer piso-L izquierda arriba 
    line(SW*35,SH*7,SW*37,SH*7); //Horizontal middle primer piso-L derecha arriba
    line(SW*5,SH*7,SW*5,SH*9); //Vertical middle primer piso-L izquierda arriba
    line(SW*35,SH*7,SW*35,SH*9); //Vertical middle primer piso-L derecha arriba
  
    line(SW*7,SH*5,SW*18,SH*5); //Horizontal middle arriba izquierda segundo
    line(SW*22,SH*5,SW*33,SH*5); //Horizontal middle arriba derecha segundo
    line(SW*18,SH*4,SW*18,SH*5); //Vertical En medio hasta arriba segundo izquierda-L
    line(SW*22,SH*4,SW*22,SH*5); //Vertical En medio hasta arriba segundo derecha-L
  
    line(SW*13,SH*4,SW*17,SH*4); //Horizontal middle arriba izquierda tercero
    line(SW*23,SH*4,SW*27,SH*4); //Horizontal middle arriba derecha tercero
  
    line(SW*13,SH*3,SW*19,SH*3); //Horizontal middle arriba izquierda cuarto
    line(SW*21,SH*3,SW*27,SH*3); //Horizontal middle arriba derecha cuarto
    line(SW*19,SH*3,SW*19,SH*5); //Vertical En medio hasta arriba izquierda-L
    line(SW*21,SH*3,SW*21,SH*5); //Vertical En medio hasta arriba derecha-L
  
    line(SW*13,SH*17,SW*19,SH*17); //Horizontal middle abajo izquierda cuarto
    line(SW*21,SH*17,SW*27,SH*17); //Horizontal middle abajo derecha cuarto
    line(SW*19,SH*15,SW*19,SH*17); //Vertical En medio abajo arriba izquierda-L
    line(SW*21,SH*15,SW*21,SH*17); //Vertical En medio abajo arriba derecha-L
  
    line(SW*3,SH*14,SW*19,SH*14); //Horizontal middle abajo izquierda
    line(SW*21,SH*14,SW*37,SH*14); //Horizontal middle abajo derecha
  
    line(SW*3,SH*13,SW*5,SH*13); //Horizontal middle primer piso-L izquierda abajo
    line(SW*35,SH*13,SW*37,SH*13); //Horizontal middle primer piso-L derecha abajo
    line(SW*5,SH*11,SW*5,SH*13); //Vertical middle primer piso-L izquierda abajo
    line(SW*35,SH*11,SW*35,SH*13); //Vertical middle primer piso-L derecha abajo
  
    line(SW*7,SH*15,SW*18,SH*15); //Horizontal middle abajo izquierda segundo
    line(SW*22,SH*15,SW*33,SH*15); //Horizontal middle abajo derecha segundo
    line(SW*18,SH*15,SW*18,SH*16); //Vertical En medio hasta abajo segundo izquierda-L
    line(SW*22,SH*15,SW*22,SH*16); //Vertical En medio hasta abajo segundo derecha-L
  
    line(SW*13,SH*16,SW*17,SH*16); //Horizontal middle abajo izquierda tercero
    line(SW*23,SH*16,SW*27,SH*16); //Horizontal middle abajo derecha tercero
    
  //CENTRO
    line(SW*5, SH*10, SW*15, SH*10); //línea izquierda rect centro
    line(SW*25, SH*10, SW*35, SH*10); //línea derecha rect centro
  
    line(SW*10,SH*7,SW*18,SH*7); //Horizontal arriba centro izquierda segunda
    line(SW*22,SH*7,SW*30,SH*7); //Horizontal arriba centro derecha segunda
    line(SW*10,SH*13,SW*18,SH*13); //Horizontal abajo centro izquierda segunda
    line(SW*22,SH*13,SW*30,SH*13); //Horizontal abajo centro derecha segunda
    
    line(SW*10,SH*9,SW*14,SH*9); //Horizontal arriba centro izquierda
    line(SW*26,SH*9,SW*30,SH*9); //Horizontal arriba centro derecha
    line(SW*10,SH*11,SW*14,SH*11); //Horizontal abajo centro izquierda
    line(SW*26,SH*11,SW*30,SH*11); //Horizontal abajo centro derecha
  
    line(SW*19,SH*6,SW*19,SH*7); //Vertical middle centro-L izquierda arriba
    line(SW*21,SH*6,SW*21,SH*7); //Vertical middle centro-L derecha arriba
    line(SW*19,SH*13,SW*19,SH*14); //Vertical middle centro-L izquierda abajo
    line(SW*21,SH*13,SW*21,SH*14); //Vertical middle centro-L derecha abajo
    
  noStroke();
  p1.displayP(red, green, blue);
  p1.limitsP();
  g1.displayG(255, 0, 0, trans);
  g1.limitsG();
  g2.displayG(0, 255, 0, trans);
  g3.displayG(0, 0, 255, trans);
  g4.displayG(255, 0, 255, trans);
  
}

void keyPressed () {
   switch (keyCode){
   case UP: D=1; break;
   case DOWN: D=2; break;
   case RIGHT: D=3; break;    
   case LEFT: D=4; break;
   case ENTER: pantalla=1; break;
   }
   switch (key){
     case 'q': frameRate(4); break;
     case 'a': frameRate(10); break;
     case 'e': frameRate(15); break;
     case '1': pantalla=1; break;
     case '4': screenS=true; break;
     case '7': numCoins+=100; break;
     case '8': lives--; break;
     case '9': level++;resetLevel(); break;
     case 'r': if (pantalla==0){red=255; green=0; blue=0;}; break;
     case 'g': if (pantalla==0){red=0; green=255; blue=0;}; break;
     case 'b': if (pantalla==0){red=0; green=0; blue=255;}; break;
     case 'w': if (pantalla==0){red=255; green=255; blue=255;}; break;
     case 'p': if (pantalla==0){red=255; green=0; blue=255;}; break;
     //default: {red=255; green=255; blue=0;}; break;
   }
}

void menu(){
  background (255);
  fill(0);
  textSize(SH+sh);
  textAlign(CENTER);
  text ("Instrucciones:", width/2, SH*2);
  text ("<<< Click para comenzar >>>", width/2, SH*14);
  text ("¡¡¡No ganarás!!!", width/2, SH*16);
  textSize(SH);
  textAlign(LEFT);
  text ("1) Muévete usando las cuatro flechas", SW*2, SH*4);
  text ("2) Termina todas las monedas para avanzar al siguiente nivel", SW*2, SH*6);
  text ("¡Selecciona tu color!", SW*2, SH*8);
  text ("Rojo: R  Verde: G  Azul: A  Blanco: W  Rosa: P", SW*2, SH*7);
  text ("Oprime la letra del skin que quieras utilizar:", SW*2, SH*12);
}
void gameWin(){
  background (0);
  fill(255);
  textSize(100);
  textAlign(CENTER);
  text ("You won!!! :))", SW*20, SH*9);
  text ("Creado por: Annie y Bernie))", SW*20, SH*11);
}

void gameOver(){
  background (0);
  fill(255);
  textSize(150);
  textAlign(CENTER);
  text ("Perdiste :((", SW*20, SH*10);
  textSize(50);
  text ("<<< Oprime el botón del mouse para volver al menu principal >>>",SW*20, SH*15); 
}

void mousePressed() {
  if (lives<=0 || pantalla==3){
    lives = 3;
    level = 1;
    resetLevel();
    pantalla=0;
    screenS=true;
    redraw();
  }
  
}
