
void resetScore() {
  playerA = 0;
  playerB = 0;
}

void displayScore() {
  textFont(font);
  textSize(50);
  text(Integer.toString(playerA), width/4, height/4);
  text(Integer.toString(playerB), (3*width)/4, height/4);
  
  if(playerA == 10) {
    win(0);
  } else if(playerB == 10) {
    win(1);
  }
}

void win(int player) {
  textFont(font);
  textSize(80);
  if(player == 0) {
    text("WIN", (width/4)-20, height-10);
  } else {
    text("WIN", (width/2)+10, height-10);
  }
  textSize(22);
  text("Play again \n[SPACEBAR]", (width/2)-75, height/2);
}
