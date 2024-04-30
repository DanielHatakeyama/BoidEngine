/* =============== MAIN ============ */


// We can use an observer pattern for a renderer that updates the screen on a timer or something
// All rendering objects 'listen' to the game clock

// Singleton for settings? Such as boid radius, etc. this is a good sub for a lut
// default settings like default boid color, etc and then just choie of boid color on top of that like user defined but can reset to normal

EventManager eventManager; // this should eventually be created in the world and be dependency injected all the way down as needed, specifically to system entity managers

EntityManager entityManager;
SystemManager systemManager;

float lastFrameTime;

public void setup() {

  size(1600, 1000);

  // Setup Main Systems (TODO make this encapsulated in a world object or something) (This would hold the last frame time and stuff.
  eventManager = new EventManager();
  systemManager = new SystemManager(eventManager);
  entityManager = new EntityManager(eventManager);

  // The system manager can be refactored with a factory / builder if desired, minimal priority
  // TODO refactor system manager with a priority queue
  // TODO add the background as a game object
  // TODO refactor render system to draw by layers

  // Initializing the BoidSystem with specific behavioral metrics
  systemManager.addSystem(new BoidSystem(
      110f,              // basePerceptionRadius
      4000f,             // separationScale
      1.0f,              // cohesionScale
      1.1f,              // alignmentScale
      0.30f,             // minSeparationPercent
      90.0f,              // minVelocity
      25f, 25f          // Perception Random Adjustment Range (more randomness)
  ));

  systemManager.addSystem(new BindCanvasWithForce(450f, 50f));
  systemManager.addSystem(new BindCanvasWithTeleport());
  systemManager.addSystem(new PhysicsSystem());
  systemManager.addSystem(new RenderSystem());

  println("Setup()" + " [" + width + ", " + height + "] - Complete");
  
  lastFrameTime = millis() / 1000f;
}


public void draw() {

  // Calculate and update delta time
  float currentTime = millis() / 1000f;
  float deltaTime = currentTime - lastFrameTime;
  lastFrameTime = currentTime;
  
  // Update all systems
  systemManager.updateAll(deltaTime);
}
public void mousePressed() {
  if (mouseButton == LEFT) buildBoidClanRed();
  if (mouseButton == RIGHT) buildBoidClanBlue();
  if (mouseButton == CENTER) buildBoidClanGreen();
}

public void mouseDragged() {
  if (mouseButton == LEFT) buildBoidClanRed();
  if (mouseButton == RIGHT) buildBoidClanBlue();
  if (mouseButton == CENTER) buildBoidClanGreen();
}

public void buildBoid() {
  entityManager.buildEntity("boid", "bindcanvaswithforce")
    .with(new Transform(mouseX, mouseY))
    .with(new Renderer(new BoidTriangle()))
    .with(new RigidBody())
    //.with(new ColorComponent(color(random(255),random(255),random(255)), color(random(255),random(255),random(255),0)))
    .with(new ColorComponent(color(0,255,0), color(0)))
    .create();
}

public void buildBoidClanRed() {

  color primary = color(255,0,0);
  color stroke = color(0);
  
  entityManager.buildEntity("boid", "bindcanvaswithforce")
    .with(new Transform(mouseX, mouseY))
    .with(new Renderer(new BoidTriangle()))
    .with(new RigidBody())
    .with(new ClanComponent("Red Clan", primary))
    .with(new ColorComponent(primary, stroke))
    .create();

}


public void buildBoidClanBlue() {

  color primary = color(0,0,255);
  color stroke = color(0);
  
  entityManager.buildEntity("boid", "bindcanvaswithforce")
    .with(new Transform(mouseX, mouseY))
    .with(new Renderer(new BoidTriangle()))
    .with(new RigidBody())
    .with(new ClanComponent("Blue Clan", primary))
    .with(new ColorComponent(primary, stroke))
    .create();

}

public void buildBoidClanGreen() {

  color primary = color(30,150,30);
  color stroke = color(0);
  
  entityManager.buildEntity("boid", "bindcanvaswithforce")
    .with(new Transform(mouseX, mouseY))
    .with(new Renderer(new BoidTriangle()))
    .with(new RigidBody())
    .with(new ClanComponent("Green Clan", primary))
    .with(new ColorComponent(primary, stroke))
    .create();

}