
boolean gol_left(float ballx, float bally, float ballr) {
  return ballx <= 0 + ballr;
}

boolean gol_right(float ballx, float bally, float ballr) {
  return ballx >= width - ballr;
}

boolean collide_pad(float ballx, float bally, float ballr, float padx, float pady, float padw, float padh) {
  float dist_x = ballx;
  float dist_y = bally;
  
  if(ballx < padx) {
    dist_x = padx;
  } else if(ballx > padx + padw) {
    dist_x = padx + padw;
  }
  
  if(bally < pady) {
    dist_y = pady;
  } else if(bally > pady + padh) {
    dist_y = pady + padh;
  }
  
  dist_x = ballx - dist_x;
  dist_y = bally - dist_y;
  
  // distancia entre vertice mas cercano del pad y centro de la pelota
  float dist = sqrt(sq(dist_x) + sq(dist_y));
  
  return dist <= ballr;
}
