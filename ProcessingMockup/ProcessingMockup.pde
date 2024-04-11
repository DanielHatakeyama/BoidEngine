// We can use an observer pattern for a renderer that updates the screen on a timer or something
// All rendering objects 'listen' to the game clock

// Singleton for settings? Such as boid radius, etc. this is a good sub for a lut
// default settings like default boid color, etc and then just choie of boid color on top of that like user defined but can reset to normal

EntityManager entityManager = new EntityManager();

RenderSystem renderSystem = new RenderSystem();

PGraphics scene;


public void mousePressed() {

  entityManager.buildEntity()
    .with(new Transform(mouseX, mouseY))
    .with(new Renderer(new CircleRenderFunction()))
    .create();
}

public void setup() {
  size(1600, 1000);
  scene = createGraphics(width, height);
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
  Map<Integer, Entity> ents = entityManager.TestingGetEntities();
  
  scene.beginDraw();
  for (Entity entity : ents.values()) {
    renderSystem.renderEntity(scene, entity);
  }
  scene.endDraw();
}
