public class BoidSystem extends System {

  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, RigidBody> rigidBodies = new HashMap<>();

  // Data Members / Setting Variables
  private float perceptionRadius = 200f;
  private float minSeparationPercent = 0.25f;

  // Force Scalars
  private float separationScale = 300f;
  private float cohesionScale = 2f;
  private float alignmentScale = 20f;

  public BoidSystem() {
  }

  public BoidSystem(float perceptionRadius, float separationScale, float cohesionScale, float alignmentScale, float minSeparationPercent) {
    this.perceptionRadius = perceptionRadius;
    this.separationScale = separationScale;
    this.cohesionScale = cohesionScale;
    this.alignmentScale = alignmentScale;
    this.minSeparationPercent = minSeparationPercent;
  }

  @Override
    protected boolean matchesSystemCriteria(ComponentEvent event) {
    return event.isComponentType(RigidBody.class) && event.entity.hasTag("boid");
  }

  @Override
    protected void onComponentAdded(Entity entity, Component component) {
    Integer ID = entity.getID();
    transforms.put(ID, entity.getComponent(Transform.class));
    rigidBodies.put(ID, (RigidBody)component);
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
      RigidBody rigidBody = this.rigidBodies.get(id);
      Transform transform = this.transforms.get(id);

      PVector separationForce = new PVector(0, 0);
      PVector cohesionForce = new PVector(0, 0);
      PVector alignmentForce = new PVector(0, 0);

      float numNeighbors = 0;  // Count of neighbors
      PVector averagePosition = new PVector(0, 0);
      PVector averageVelocity = new PVector(0, 0);

      // Loop through all transforms to calculate relative forces
      for (Map.Entry<Integer, Transform> entry : transforms.entrySet()) {
        if (!entry.getKey().equals(id)) { // Skip the current boid itself
          Transform neighbor = entry.getValue();
          PVector difference = PVector.sub(transform.getPosition(), neighbor.getPosition());
          float distance = difference.mag();

          // Check if the current boid is within perception radius
          if (distance <= perceptionRadius) {
            numNeighbors++;

            // Separation
            if (distance < minSeparationPercent * perceptionRadius) {
              difference.normalize().div(distance);  // Stronger repulsion at closer distances
              separationForce.add(difference);
            }

            // Cohesion
            averagePosition.add(neighbor.getPosition());

            // Alignment
            averageVelocity.add(this.rigidBodies.get(entry.getKey()).getVelocity());
          }
        }
      }

      if (numNeighbors > 0) {
        averagePosition.div(numNeighbors);
        cohesionForce = PVector.sub(averagePosition, transform.getPosition());

        averageVelocity.div(numNeighbors);
        alignmentForce = PVector.sub(averageVelocity, rigidBody.getVelocity());
      }

      // Scale all forces
      separationForce.mult(separationScale);
      cohesionForce.mult(cohesionScale);
      alignmentForce.mult(alignmentScale);

      // Apply all forces
      rigidBody.applyForce(separationForce);
      rigidBody.applyForce(cohesionForce);
      rigidBody.applyForce(alignmentForce);

      // Ensure minimum velocity
      float minVelocity = 10.0f;
      if (rigidBody.getVelocity().mag() < minVelocity) {
        rigidBody.setVelocity(rigidBody.getVelocity().setMag(minVelocity));
      }
    }
  }
}
