// We can use an observer pattern for a renderer that updates the screen on a timer or something
// All rendering objects 'listen' to the game clock

// Singleton for settings? Such as boid radius, etc. this is a good sub for a lut
// default settings like default boid color, etc and then just choie of boid color on top of that like user defined but can reset to normal

EntityManager entityManager = new EntityManager();

public void mousePressed() {
  PVector mousePos = new PVector(mouseX, mouseY);
  entityManager.buildEntity()
    .with(new Transform2D(mouseX, mouseY))
    .with(new SimpleBoidDebug())
    .create();
}

public void setup() {
    size(1600,1000);
}


public void draw() {
  // For each boid
  // Do the rules it needs to do
  // Then render
  drawBackground();
  drawBoids();
}



void drawBoids() {
  for(Boid b : boids) {
    b.update(boids);
    b.render();
  }
}

void drawBackground() {
  background(#9CBFED);
}
