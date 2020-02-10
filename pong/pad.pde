
void restart_pad() {
  padA_w = 20;
  padA_h = 100;
  
  padA_x = padA_w;
  padA_y = height/2.0;
  
  padB_w = 20;
  padB_h = 100;
  
  padB_x = width - 2*padA_w;
  padB_y = height/2.0;
  
  pad_vel = padA_h/2;
}

void draw_pads() {
  fill(255);
  rect(padA_x, padA_y, padA_w, padA_h);
  rect(padB_x, padB_y, padB_w, padB_h);
}

void movePad(int tecla) {
  // right pad
  if (tecla == UP) padB_y = padB_y - pad_vel < 0 ? 0: padB_y - pad_vel;
  if (tecla == DOWN) padB_y = padB_y + pad_vel > height - padB_h ? height - padB_h : padB_y + pad_vel;
  
  // left pad
  if (tecla == 'W' || tecla == 'w') padA_y = padA_y - pad_vel < 0 ? 0: padA_y - pad_vel;
  if (tecla == 'S' || tecla == 's') padA_y = padA_y + pad_vel > height - padA_h ? height - padA_h : padA_y + pad_vel;
}
