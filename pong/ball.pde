
float sign(float value) {
  return value < 0 ? -1 : 1;
}

void restart_ball() {
  ball_diam = 40;
  ball_x = width/2.0;
  ball_y = height/2.0;
  
  speed = random(min_speed, max_speed); // velocity
  dx = sign(random(-1, 1))*random(0.8, 1); // direction x
  dy = sign(random(-1, 1))*random(0, 1); // direction y
  
  fill(255);
  circle(ball_x, ball_y, ball_diam);
}

void move_ball() {
  ball_x += speed*dx;
  ball_y += speed*dy;
  
  if(ball_y <= 0+ball_diam/2.0 || ball_y >= height-ball_diam/2.0) {
    dy *= -1;
  }
  
  fill(255);
  circle(ball_x, ball_y, ball_diam);
}
