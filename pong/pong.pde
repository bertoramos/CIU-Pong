
import gifAnimation.*;

GifMaker gif;

// ball
float ball_x, ball_y, ball_diam;
float speed;
float min_speed = 5.0;
float max_speed = 7.0;

float dx, dy; // direction

// left pad
float padA_x, padA_y, padA_w, padA_h;

// right pad
float padB_x, padB_y, padB_w, padB_h;

float pad_vel; // Pad y-speed

// puntuacion
int playerA, playerB;
// Text font
PFont font;

boolean isGameRunning;

float netWidth;

void setup() {
  size(800, 600);
  loadMusic();
  
  isGameRunning = true;
  
  restart_ball();
  restart_pad();
  
  resetScore();
  
  font = createFont("pixelart.ttf", 32);
  
  netWidth = height/100;
  
  gif = new GifMaker(this, "export2.gif");
  gif.setRepeat(0);        // make it an "endless" animation
  gif.setTransparent(0,0,0);  // black is transparent
}

void keyPressed() {
  movePad(keyCode);
  
  if (keyCode == ' ' && !isGameRunning) {
    // RESTART GAME
    restart_ball();
    restart_pad();
    resetScore();
    isGameRunning = true;
    stopMelody();
  }
}

void mousePressed() {
  gif.finish(); 
}

void displayCommands() {
  textSize(20);
  text("UP [W]", (width/2)-90, 20);
  text("DOWN [S]", (width/2)-120, 40);
  
  text("UP[Up key]", (width/2)+20, 20);
  text("DOWN[Down key]", (width/2)+20, 40);
}

void draw() {
  background(0);
  stroke(255,255,255,100);
  strokeWeight(2);
  
  // draw tennis court net
  for(int i = 1; i < height/netWidth; i++) {
    if(i % 2 == 0) line(width/2, (i-1)*netWidth, width/2, i*netWidth);
  }
  
  if(isGameRunning) {
    move_ball();
    draw_pads();
    
    // Left
    if(collide_pad(ball_x, ball_y, ball_diam/2.0, padA_x, padA_y, padA_w, padA_h)) {
      thread("playPadCollision");
      dx *= -1;
      speed = random(min_speed, max_speed);
      
      ball_x += dx*ball_diam/2.0; // sumamos radio para evitar que la pelota se enganche al pad
    }
    if(gol_left(ball_x, ball_y, ball_diam)) {
      thread("playGol");
      restart_ball();
      playerB++;
      
    }
    
    // Right
    if(collide_pad(ball_x, ball_y, ball_diam/2.0, padB_x, padB_y, padB_w, padB_h)) {
      thread("playPadCollision");
      dx *= -1;
      speed = random(min_speed, max_speed);
      
      ball_x += dx*ball_diam/2.0; // sumamos radio para evitar que la pelota se enganche al pad
    }
    // gol
    if(gol_right(ball_x, ball_y, ball_diam)) {
      thread("playGol");
      restart_ball();
      playerA++;
    }
    
    if(playerA == 10 || playerB == 10) {
      playWin();
      isGameRunning = false;
      startMelody();
    }
  }
  displayScore();
  displayCommands();
  
  gif.addFrame();
}
