
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
  private float maxSpeed = 5f;
  private float maxForce = 0.5;
  // Turning speed

  private float perceptionRadius = 180f;

  private BoidBehavior behavior;


  // Simple default for now boid
  Boid(PVector initPosition, PVector initVelocity, BoidBehavior behavior) {
    //
    this.position = initPosition;
    this.velocity = initVelocity;

    this.behavior = behavior;
    setRenderFunction(new SimpleBoidDebug());
  }

  public void update(ArrayList<Boid> boids) {

    ArrayList<Boid> neighbors = this.getNeighbors(boids);
    PVector movementForce = behavior.calculateMovement(this, neighbors);
    applyForce(movementForce);
  }

  // TODO: Make a overload in future that doesnt use all global boids
  // TODO: Make this generalized in the future
  public ArrayList<Boid> getNeighbors(ArrayList<Boid> boids) {
    // (Naive approach)

    ArrayList<Boid> Neighbors = new ArrayList<Boid>();
    
    // Loop through all boids that exist, if distance from this is < perceptionRadius, add to neighbors
    for (Boid boid : boids) {
      
      // ignore starting boid
      if (this == boid) continue;
      
      //PVector neighborPosition = boid.position;
      //float distance = sqrt(sq(this.position.x - neighborPosition.x)-sq(this.position.y - neighborPosition.y));
      float distance = PVector.dist(this.getPosition(), boid.getPosition());
      
      if (distance < perceptionRadius) {
        Neighbors.add(boid);
      }
    }

    return Neighbors;
  }

  private void applyForce(PVector force) {
    // Applys force vector in controlled way - limits force, max velocity, and wraps boid position
    //force.div(50);
    
    force.limit(maxForce);
    velocity.add(force);
    velocity.limit(maxSpeed);
    //velocity.normalize().mult(maxSpeed); // temporary make boids always go max speed
    position.add(velocity);
    //wrapPosition();
    bounceEdges();
  }

  private void wrapPosition() {
    // CODE TO BE CHANGED THIS IS BAD AND TEMPORARY:
    if (position.x > width + size) position.x = (-size);
    if (position.x < -size) position.x += (width + size);

    if (position.y > height + size) position.y = (-size);
    if (position.y < -size) position.y += (height + size);
  }
  
  private void bounceEdges() {
    
    float bounceForce = 0.5f;
    float innerBoundary = 50f; // In pixels
    
    // CODE TO BE CHANGED THIS IS BAD AND TEMPORARY:
    if (position.x > width + size - innerBoundary) this.velocity.x -= bounceForce; //applyForce(new PVector(-bounceForce,0));
    if (position.x < -size + innerBoundary) this.velocity.x += bounceForce; //applyForce(new PVector(bounceForce,0));

    if (position.y > height + size - innerBoundary) this.velocity.y -= bounceForce; //applyForce(new PVector(0,-bounceForce));
    if (position.y < -size + innerBoundary) this.velocity.y += bounceForce; //applyForce(new PVector(0,bounceForce)); // down
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
  
  public PVector getPosition() {
    return this.position.copy();
  }
  public PVector getVelocity() {
    return this.velocity.copy();
  }
}


// Extra behaviors, if not up to speed, move until at speed in a direction, searching for group
