// We can use an observer pattern for a renderer that updates the screen on a timer or something
// All rendering objects 'listen' to the game clock

// Singleton for settings? Such as boid radius, etc. this is a good sub for a lut
// default settings like default boid color, etc and then just choie of boid color on top of that like user defined but can reset to normal

ArrayList<Boid> boids = new ArrayList<>();    


//public void createBoids(int n) {
//  for (int i=0; i<n; i++) {
//    createBoid();
//  }
//}


public void createBoid(PVector pos) {
  PVector randVelocity = PVector.random2D().mult(2f);
  
  Boid b = new Boid(pos, randVelocity, new FlockBehavior());
  
  boids.add(b);
}
public void mousePressed() {
  PVector mousePos = new PVector(mouseX, mouseY);
  createBoid(mousePos);
}

public void setup() {
    size(1000,800);
    
    for (int i = 0; i<50; i++) {
      PVector randomPosition = new PVector(random(width), random(height));
      createBoid(randomPosition);
    }
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
