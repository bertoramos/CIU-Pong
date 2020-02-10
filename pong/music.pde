
import processing.sound.*;

SoundFile padCollision;
SoundFile gol;
SoundFile win;
SoundFile melody;

void loadMusic() {
  padCollision = new SoundFile(this, "padCollision.wav"); // https://downloads.khinsider.com/game-soundtracks/album/nintendo-switch-sound-effects/News.mp3
  gol = new SoundFile(this, "gol.wav"); // https://downloads.khinsider.com/game-soundtracks/album/nintendo-switch-sound-effects/Popup%2520%252B%2520Run%2520Title.mp3
  win = new SoundFile(this, "win.wav"); // https://freesound.org/people/Wagna/sounds/325805/
  melody = new SoundFile(this, "melody.wav"); // https://freesound.org/people/DominikBraun/sounds/483502/
}

void playPadCollision() {
  padCollision.play();
}

void playGol() {
  gol.play();
}

void startMelody() {
  melody.loop();
}

void stopMelody() {
  melody.stop();
}

void playWin() {
  win.play();
}
