public class BoidSystem extends System {

  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, RigidBody> rigidBodies = new HashMap<>();
  private Map<Integer, ClanComponent> clans = new HashMap<>();

  // Data Members / Setting Variables
  private float perceptionRadius = 110f;
  private float basePerceptionRadius = 110f;
  private float minSeparationPercent = 0.25f;
  private float minVelocity = 0f; // ensures min velocity, set manually rn, but this can change easily

  private float minPerceptionAdjustment = 0;
  private float maxPerceptionAdjustment = 0;

  private float minSeparationDistance = 0.01f;

  // Force Scalars
  private float separationScale = 5000f;
  private float cohesionScale = 1f;
  private float alignmentScale = 1f;

  // ---------- Constructors ---------- //
  public BoidSystem() {
  }

  public BoidSystem(float perceptionRadius, float separationScale, float cohesionScale, float alignmentScale, float minSeparationPercent, float minVelocity, float minPerceptionAdjustment, float maxPerceptionAdjustment) {
    this.basePerceptionRadius = perceptionRadius;
    this.perceptionRadius = perceptionRadius;
    float adjustment = random(-minPerceptionAdjustment, maxPerceptionAdjustment);
    this.perceptionRadius += adjustment;
    
    this.separationScale = separationScale;
    this.cohesionScale = cohesionScale;
    this.alignmentScale = alignmentScale;
    this.minSeparationPercent = minSeparationPercent;
    this.minVelocity = minVelocity;
  }

  public BoidSystem(float perceptionRadius, float separationScale, float cohesionScale, float alignmentScale, float minSeparationPercent, float minVelocity) {
    this(perceptionRadius, separationScale, cohesionScale, alignmentScale, minSeparationPercent, minVelocity, 0, 0);
  }

  @Override
  protected boolean matchesSystemCriteria(ComponentEvent event) {
    boolean ifMatches = event.entity.hasTag("boid"); //event.isComponentType(RigidBody.class) && 
    return ifMatches;
  }

  @Override
  protected void onComponentAdded(Entity entity, Component component) {
    Integer ID = entity.getID();

    // TODO Update the map.component system to work with the tabular setup and only store each map once and automatically

    if (component instanceof Transform) {
        transforms.put(ID, (Transform) component); // todo change this once transform becomes attached by default to the entity
    } else if (component instanceof RigidBody) {
        rigidBodies.put(ID, (RigidBody) component);
    } else if (component instanceof ClanComponent) {
        clans.put(ID, (ClanComponent) component);
    }
    
  }

  @Override
    protected void onComponentRemoved(Entity entity, Component component) {
    // Implementation for removing a component from the rendering system // todo for ben
  }

  @Override
    public void update(float deltaTime) {
    if (transforms.size() == 0) return;

    // Loop through each boid
    for (Integer id : transforms.keySet()) {

      // Boid Properties
      Transform transform = this.transforms.get(id);
      PVector position = transform.getPosition();
      RigidBody rigidBody = this.rigidBodies.get(id);
      PVector velocity = rigidBody.getVelocity();
      ClanComponent clan = this.clans.get(id);

      PVector separationForce = new PVector(0, 0);
      PVector cohesionForce = new PVector(0, 0);
      PVector alignmentForce = new PVector(0, 0);

      float numNeighbors = 0;  // Count of neighbors
      PVector averagePosition = new PVector(0, 0);
      PVector averageVelocity = new PVector(0, 0);

      // Loop through all neighbors to calculate relative forces
      for (Integer neighborID : transforms.keySet()) {

        // Neighbor Properties
        Transform neighborTransform = this.transforms.get(neighborID);
        PVector neighborPosition = neighborTransform.getPosition();
        RigidBody neighborRigidBody = this.rigidBodies.get(neighborID);
        PVector neighborVelocity = neighborRigidBody.getVelocity();
        ClanComponent neighborClan = this.clans.get(neighborID);

        if (id == neighborID) continue; // Skip the current boid itself

        PVector difference = PVector.sub(position, neighborPosition);
        float distance = PVector.dist(position, neighborPosition);

        if (distance > perceptionRadius) continue; // Skip non neighbors

        // CLAN BEHAVIOR:
        if ((clan != null) && (neighborClan != null)) {
          // If different clan, do specific behavior
          if (clan.name != neighborClan.name) {
            // C+P separation force, further distance
            if (distance < (/*minSeparationPercent * */ basePerceptionRadius)) {
              difference.normalize().div(distance).mult(0.8);  // Stronger repulsion at closer distances
              separationForce.add(difference);
            }
            continue; // After different clan behavior, go next->
          }
        }

        // Check if the current boid is within perception radius
        numNeighbors++;

        // Separation
        if (distance < (minSeparationPercent * basePerceptionRadius)) {

          if(distance < minSeparationDistance) distance = minSeparationDistance;
          
          difference.normalize().div(distance);  // Stronger repulsion at closer distances
          separationForce.add(difference);
        }

        // Cohesion
        averagePosition.add(neighborPosition);

        // Alignment
        averageVelocity.add(neighborVelocity);
      }

      if (numNeighbors > 0) {
        averagePosition.div(numNeighbors);
        cohesionForce = PVector.sub(averagePosition, position);

        averageVelocity.div(numNeighbors);
        alignmentForce = PVector.sub(averageVelocity, velocity);
      }

      // Scale all forces
      separationForce.mult(separationScale);
      cohesionForce.mult(cohesionScale);
      alignmentForce.mult(alignmentScale);

      // Apply all forces
      rigidBody.applyForce(separationForce);
      rigidBody.applyForce(cohesionForce);
      rigidBody.applyForce(alignmentForce);

      // Update velocity after applying force
      velocity = rigidBody.getVelocity();

      // Min velocity logic
      if ((velocity.mag() < minVelocity) && (velocity.mag() > 0)) {
        rigidBody.setVelocity(velocity.setMag(minVelocity));
      }
    }
  }
}
