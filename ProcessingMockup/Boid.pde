
class Boid extends GameObject {


  // Implements renderable game object perhaps that would mean all i have to do is define a shape or something for the boid and the render and update functions are implemented with this in mind, i can also change the "sprite"
  // for cases like debuging vision radius

  // Implement with behavior, or whatever else needed to make work oop style

  // Look parameters (Radius)
  // Speed Parameters
  // (Constant, what speed, what accel?)
  // Die parameters
  // Color Parameters
  // Behaviors

  // SIMULATE EVOLUTION WITH FISH FLOCKING BEHAVIORS AND WHAT IS THE BEST STRATEGY!!!

  // for now do constant velocity idc about anything


  
  private PVector mass; // This will eventually act as a multiplier on acceleration so we can make behavior heavy or lighter responsive
  private color primaryColor;
  private float size = 15f;
  private PVector faceDirection; // Is velocity vector most of the time i think i cant think of a counter ex
  private float maxSpeed = 10;
  private float maxForce = 0.1;
  
  // Turning speed
  
  private float perceptionRadius = 250f;

  private BoidBehavior behavior;


  // Simple default for now boid
  Boid(PVector initPosition, PVector initVelocity, BoidBehavior behavior) {
    // 
    this.position = initPosition;
    this.velocity = initVelocity;
    
    this.behavior = behavior;
    setRenderFunction(new SimpleBoidDebug());
    
  }
  
  //ArrayList<Boid> getNeighbors(boids) {
  //  // to be defined
  //  // if distance less than perceptionRadius
  //  // return 
  //}
  
  
  public void update(ArrayList<Boid> boids) {
    
    ArrayList<Boid> neighbors = this.getNeighbors(boids);
    PVector movementForce = behavior.calculateMovement(this, neighbors);
    applyForce(movementForce);

  }
  
  // TODO: Make a overload in future that doesnt use all global boids
  public ArrayList<Boid> getNeighbors(ArrayList<Boid> boids) {
    
    // (Naive approach)
    // Loop through all boids that exist, if distance from this is < perceptionRadius, add to neighbors
    
    return new ArrayList<Boid>();
  }

  private void applyForce(PVector force) {
    // Applys force vector in controlled way - limits force, max velocity, and wraps boid position
    force.limit(maxForce);
    velocity.add(force);
    velocity.limit(maxSpeed);
    position.add(velocity);
    wrapPosition();
  }
  
  private void wrapPosition() {
    // CODE TO BE CHANGED THIS IS BAD AND TEMPORARY:
    if (position.x > width + size) position.x = (-size);
    if (position.x < -size) position.x += (width + size);

    if (position.y > height + size) position.y = (-size);
    if (position.y < -size) position.y += (height + size);
  }

  // Graphical Functions
  // Show vision radius
  // Show face direction vector-


  public float getMaxSpeed() {
    return this.maxSpeed;
  }

  public float getMaxForce() {
    return this.maxForce;
  }
  public float getPerceptionRadius() {
    return this.perceptionRadius;
  }
}


// Extra behaviors, if not up to speed, move until at speed in a direction, searching for group
