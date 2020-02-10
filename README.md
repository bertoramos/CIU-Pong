
## Práctica 1: Pong
###### Alberto Ramos Sánchez

<center><img src="export.gif" width="400" height="300"/></center>

En esta práctica hemos desarrollado una versión del clásico juego [Pong de Atari](https://es.wikipedia.org/wiki/Pong). Está basado en el juego del ping-pong, y su objetivo es —controlando una raqueta— hacer rebotar una pelota intentando no dejarla pasar. Cada vez que uno de los participantes deja pasar la bola, el adversario gana un punto.

__Para controlar las raquetas__, el jugador de la izquierda usa las teclas *'W'* y *'S'* para hacer subir y bajar la raqueta, respectivamente. El jugador derecho, utiliza las flechas superior e inferior.

En esta versión del juego, si uno de los dos jugadores llega a 10 puntos, gana el juego. Para volver a comenzar el juego, debe pulsarse la barra espaciadora.

#### Rebote con paredes.

La pelota solamente puede colisionar con las paredes superior e inferior, puesto que las paredes izquierda y derecha son las de porteria —por lo tanto no necesitamos que rebote—.

Para simular el movimiento de la bola, actualizamos su posición —*ball_x* y *ball_y*— según una velocidad —*speed*— y una dirección —*dx* y *dy*, que están entre (-1, 1)—.

```java
// ball.java
void move_ball() {
  ball_x += speed*dx;
  ball_y += speed*dy;

  if(ball_y <= 0+ball_diam/2.0 || ball_y >= height-ball_diam/2.0) {
    dy *= -1;
  }

  fill(255);
  circle(ball_x, ball_y, ball_diam);
}
```

La nueva posición de la pelota la obtenemos sumando un factor de desplazamiento en cada uno de los ejes, que se obtiene multiplicando la dirección por la velocidad.
Posteriormente, comprobamos si la pelota ha llegado a la pared superior o inferior. Si es así, cambiamos la dirección en el eje y.

La velocidad inicial y la dirección se elige aleatoriamente al inicio del juego, o cada vez que uno de los jugadores gana un punto.

```java

// ball.java
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

```

Con la función *restart_ball*, reseteamos la posición de la pelota al centro del panel de juego, seleccionando una dirección y velocidad aleatoria.

La dirección en el eje x la elegimos entre los intervalos [-1, -0.8), (0.8, 1], para que exista mayor probabilidad que la pelota se dirija hacia la izquierda o la derecha, que hacia arriba o abajo. Así evitamos que si da un valor cercano a 0, quede la pelota indefinidamente rebotando entre la pared superior e inferior.

La velocidad de movimiento de la pelota, se elige aleatoriamente entre [5, 7].

Esta función se ejecuta cada vez que inicia el juego, y cada vez que uno de los jugadores gana un punto.

#### Movimiento de las palas.

El movimiento de las palas se consigue desplazando el origen (en el eje y) del rectángulo que lo representa, cuando se recibe una pulsación de la tecla asociada. La distancia desplazada es definida por la variable *pad_vel* (a menos que se vaya a superar el límite superior o inferior).

```java
...
// pad.java
void movePad(int tecla) {
  // right pad
  if (tecla == UP) padB_y = padB_y - pad_vel < 0 ? 0: padB_y - pad_vel;
  if (tecla == DOWN) padB_y = padB_y + pad_vel > height - padB_h ? height - padB_h : padB_y + pad_vel;

  // left pad
  if (tecla == 'W' || tecla == 'w') padA_y = padA_y - pad_vel < 0 ? 0: padA_y - pad_vel;
  if (tecla == 'S' || tecla == 's') padA_y = padA_y + pad_vel > height - padA_h ? height - padA_h : padA_y + pad_vel;
}

...

// pong.java
void keyPressed() {
  movePad(keyCode);
  ...
}
```

#### Detección de colisiones con las palas.

Para conocer si la pelota a colisionado con una pala, calculamos la distancia de la bola al vértice de la pala más cercano. Si la distancia es menor o igual al radio de la circunferencia, quiere decir que la pelota ha colisionado.

La función *collide_pad* en *collision.java* nos devuelve si la pelota está colisionando con la pala de la cual indiquemos su origen y dimensiones.

Para conocer el vértice más cercano, buscamos la distancia más cercana en cada eje.

```java
float dist_x = ballx;
float dist_y = bally;

if(ballx < padx) { // El edge izquierdo es más cercano
  dist_x = padx;
} else if(ballx > padx + padw) { // El edge derecho es más cercano
  dist_x = padx + padw;
}

if(bally < pady) { // El edge superior es más cercano
  dist_y = pady;
} else if(bally > pady + padh) { // El edge inferior es más cercano
  dist_y = pady + padh;
}
```

Posteriormente, calculamos la distancia.

```java
// distancia entre vertice mas cercano del pad y centro de la pelota
float dist = sqrt(sq(dist_x) + sq(dist_y));
```

Esta función se ejecuta cada vez que movemos la pelota, para comprobar si ha chocado con alguna de las palas. Si es así, cambiamos la dirección en el eje x, desplazamos la pelota el tamaño de su radio (para evitar que se enganche la pelota al pad al cambiar la dirección), y hacemos sonar un ruido de rebote (*padCollision.wav*).

```java
void draw() {
  if(isGameRunning) {
    ...
    // Left
    if(collide_pad(ball_x, ball_y, ball_diam/2.0, padA_x, padA_y, padA_w, padA_h)) {
      thread("playPadCollision");
      dx *= -1;
      speed = random(min_speed, max_speed);

      ball_x += dx*ball_diam/2.0;
      // sumamos radio para evitar que la pelota se enganche al pad
      // Evitamos que, al cambiar la dirección y mover la pelota, esta siga colisionando y vuelva a cambiarse (entrando en un bucle).
    }
    ...
    // Right
    if(collide_pad(ball_x, ball_y, ball_diam/2.0, padB_x, padB_y, padB_w, padB_h)) {
      thread("playPadCollision");
      dx *= -1;
      speed = random(min_speed, max_speed);

      ball_x += dx*ball_diam/2.0; // sumamos radio para evitar que la pelota se enganche al pad
    }
    ...
  }
}
```

### Obtención de puntos

Un jugador consigue un punto si el adversario no logra controlar la pelota. Para detectarlo, comprobamos que la pelota pase el límite de una de las dos paredes. Si es así, sumamos un punto al jugador contrario y reproducimos un sonido que indica que se ganó un punto.

```java
// collision.java
boolean gol_left(float ballx, float bally, float ballr) {
  return ballx <= 0 + ballr;
}
// collision.java
boolean gol_right(float ballx, float bally, float ballr) {
  return ballx >= width - ballr;
}

//pong.java
void draw() {
  if(isGameRunning) {

    ...
    if(gol_left(ball_x, ball_y, ball_diam)) {
      thread("playGol");
      restart_ball();
      playerB++;

    }
    ...
    if(gol_right(ball_x, ball_y, ball_diam)) {
      thread("playGol");
      restart_ball();
      playerA++;
    }
  }
}
```

#### Fin del juego y reinicio.

Para controlar si el juego está ejecutándose o no, tenemos la variable *isGameRunning*, que actúa como flag para activar o desactivar el juego. Cuando el juego está activo, permitimos el movimiento de los pads y de la bola. En caso contrario, solamente mostramos la red que divide las dos áreas de juego y la puntuación final.

El juego acaba cuando uno de los dos jugadores alcanza los 10 puntos, mostrándose un cartel con la palabra __*WIN*__ en la zona del jugador ganador. Cuando esto ocurre hacemos sonar dos melodías, una que indica que el juego a finalizado, y una que suena hasta que se lanza otra partida. Para hacer sonar una melodía indefinidamente, la lanzamos utilizando el método *loop*, en vez del método *start* de la clase *SoundFile*.

```java
// score.java
void win(int player) {
  textFont(font);
  textSize(80);
  if(player == 0) { // Mostramos palabra WIN en el panel correspondiente
    text("WIN", (width/4)-20, height-10);
  } else {
    text("WIN", (width/2)+10, height-10);
  }
  textSize(22);
  text("Play again \n[SPACEBAR]", (width/2)-75, height/2);
}
...
// score.java
void displayScore() {
  textFont(font);
  textSize(50);
  text(Integer.toString(playerA), width/4, height/4);
  text(Integer.toString(playerB), (3*width)/4, height/4);

  if(playerA == 10) {// Ejecutamos la función win indicando que jugador ganó
    win(0);
  } else if(playerB == 10) {
    win(1);
  }
}
```

```java
void draw() {
  if(isGameRunning) {

    ...

    if(playerA == 10 || playerB == 10) {
      playWin(); // Sonido de victoria
      isGameRunning = false;
      startMelody(); // Melodia de juego finalizado
    }

    ...
  }
  displayScore();
}
```

Una vez acabado el juego, debemos pulsar la barra espaciadora para iniciar otro juego. En ese momento se cambia el flag nuevamente y se resetea el juego, poniendo los marcadores a cero, lanzando la pelota desde el centro y colocando las raquetas. Ademas, paramos la melodía que estaba sonando en bucle.

```java
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
```

#### Referencias

- Collision detection : <http://www.jeffreythompson.org/collision-detection/>
- padCollision.wav : <https://downloads.khinsider.com/game-soundtracks/album/nintendo-switch-sound-effects/News.mp3>
- gol.wav : <https://downloads.khinsider.com/game-soundtracks/album/nintendo-switch-sound-effects/Popup%2520%252B%2520Run%2520Title.mp3>
- win.wav : <https://freesound.org/people/Wagna/sounds/325805/>
- melody.wav : <https://freesound.org/people/DominikBraun/sounds/483502/>
