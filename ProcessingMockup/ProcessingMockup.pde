// We can use an observer pattern for a renderer that updates the screen on a timer or something
// All rendering objects 'listen' to the game clock

// Singleton for settings? Such as boid radius, etc. this is a good sub for a lut
// default settings like default boid color, etc and then just choie of boid color on top of that like user defined but can reset to normal

EventManager eventManager; // this should eventually be created in the world and be dependency injected all the way down as needed, specifically to system entity managers
PGraphics scene;
EntityManager entityManager;
RenderSystem renderSystem;


public void mousePressed() {
  println("Mouse Pressed");
  entityManager.buildEntity()
    .with(new Transform(mouseX, mouseY))
    .with(new Renderer(new CircleRenderFunction()))
    .with(new Tag("circle"))
    .create();
}

public void setup() {

  println("Setup");

  int w = 1600;
  int h = 1000;

  size(w, h);
  scene = createGraphics(w, h);
  
  eventManager = new EventManager();
  entityManager = new EntityManager(eventManager);
  renderSystem = new RenderSystem(eventManager, scene);
  
}


public void draw() {
  // For each boid
  // Do the rules it needs to do
  // Then render

  drawBackground();

  renderRenderablesTest();
  image(scene, 0, 0);
}


void drawBackground() {
  background(#9CBFED);
}


void renderRenderablesTest() {
  scene.beginDraw();
  //println("Render System Update");
  renderSystem.update(1);
  scene.endDraw();
}
