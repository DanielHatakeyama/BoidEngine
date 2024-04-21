public class BoidSystem extends System {

  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, RigidBody> rigidBodies = new HashMap<>();

  // Data Members / Setting Variables
  private float perceptionRadius = 140f;
  private float minSeparationPercent = 0.3f;

  // Force Scalars
  private float separationScale = 0f;
  private float cohesionScale = 10f;
  private float alignmentScale = 0f;

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

    // println("updating boid data");

    // Loop through each boid
    for (Integer id : transforms.keySet()) {

      // Get data for a given boid
      RigidBody rigidBody = this.rigidBodies.get(id);
      Transform transform = this.transforms.get(id);
      List<Transform> neighbors = getNeighbors(transform);

      PVector separationForce = new PVector(0, 0);
      PVector cohesionForce = new PVector(0, 0);
      PVector alignmentForce = new PVector(0, 0);

      float numNeighbors = (float)neighbors.size(); 

      float minSeparationDistance = minSeparationPercent * this.perceptionRadius;
      float separationNeighbors = 0;
      PVector averagePostion = new PVector(0,0);
      PVector averageVelocity = new PVector(0, 0);

      // Loop through neighbors:
      for (Transform neighbor : neighbors) {

        // Separation:
        PVector difference = PVector.sub(transform.getPosition(), neighbor.getPosition());
        float distance = difference.mag();

        if (distance < minSeparationDistance) {
          difference.normalize();
          //println(distance);
          //difference.div(distance*distance);
          separationForce.add(difference);
          separationNeighbors += 1;
        }

        // Cohesion
        averagePostion.add(neighbor.getPosition());

        // Alignment
      }

      if (numNeighbors > 0) {  // Use numNeighbors for actual number of neighbors
        averagePostion.div(numNeighbors);
        averageVelocity.div(numNeighbors);
        cohesionForce = PVector.sub(averagePostion, transform.getPosition());
        alignmentForce = PVector.sub(averageVelocity, rigidBody.getVelocity());
      } else {
         cohesionForce.set(0, 0);
      }

      if (separationNeighbors > 0) separationForce.div(separationNeighbors);



      // Scale all forces by the corresponding multiplier
      separationForce.mult(separationScale);
      cohesionForce.mult(cohesionScale);
      alignmentForce.mult(alignmentScale);

      // Apply all forces:
      rigidBody.applyForce(separationForce);
      rigidBody.applyForce(cohesionForce);
      rigidBody.applyForce(alignmentForce);
    }
  }

  // Helpers:
  public List<Transform> getNeighbors(Transform currentTransform) {
    List<Transform> neighbors = new ArrayList<>();
    for (Transform transform : this.transforms.values()) {
      if (transform != currentTransform && currentTransform.distanceTo(transform) <= this.perceptionRadius) {
        neighbors.add(transform);
      }
    }
    return neighbors;
  }
}

public class BindCanvasWithForce extends System {

  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, RigidBody> rigidBodies = new HashMap<>();

  private float bindForce = 0.5f;
  private float innerBoundary = 50f;

  public BindCanvasWithForce(float bindForce, float innerBoundaryPx) {
    this.bindForce = bindForce;
    this.innerBoundary = innerBoundaryPx;
  }

  @Override
    protected boolean matchesSystemCriteria(ComponentEvent event) {
    return event.isComponentType(RigidBody.class) && event.entity.hasTag("bindcanvaswithforce");
  }

  @Override
    protected void onComponentAdded(Entity entity, Component component) {

    Integer ID = entity.getID();
    transforms.put(ID, entity.getComponent(Transform.class));
    rigidBodies.put(ID, (RigidBody)component);
  }

  @Override
    protected void onComponentRemoved(Entity entity, Component component) {
    // Implementation for removing a component from the rendering system // todo for ben, ben thuis is all u buddy
  }

  @Override
    public void update(float deltaTime) {

    for (Integer id : transforms.keySet()) {
      PVector position = this.transforms.get(id).position;
      RigidBody rigidBody = this.rigidBodies.get(id);

      // Check right boundary
      if (position.x > width - innerBoundary) {
        rigidBody.applyForce(new PVector(-bindForce, 0)); // Push left
      }
      // Check left boundary
      if (position.x < innerBoundary) {
        rigidBody.applyForce(new PVector(bindForce, 0)); // Push right
      }
      // Check bottom boundary
      if (position.y > height - innerBoundary) {
        rigidBody.applyForce(new PVector(0, -bindForce)); // Push up
      }
      // Check top boundary
      if (position.y < innerBoundary) {
        rigidBody.applyForce(new PVector(0, bindForce)); // Push down
      }
    }
  }
}


public class BindCanvasWithTeleport extends System {

  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, RigidBody> rigidBodies = new HashMap<>();

  @Override
    protected boolean matchesSystemCriteria(ComponentEvent event) {
    return event.isComponentType(RigidBody.class) && event.entity.hasTag("bindcanvaswithteleport");
  }

  @Override
    protected void onComponentAdded(Entity entity, Component component) {

    Integer ID = entity.getID();
    transforms.put(ID, entity.getComponent(Transform.class));
    rigidBodies.put(ID, (RigidBody)component);
  }

  @Override
    protected void onComponentRemoved(Entity entity, Component component) {
    // Implementation for removing a component from the rendering system // todo for ben, ben thuis is all u buddy
  }

  @Override
    public void update(float deltaTime) {

    for (Integer id : transforms.keySet()) {
      Transform transform = this.transforms.get(id);
      PVector position = transform.position;
      PVector scale = transform.scale;
      RigidBody rigidBody = this.rigidBodies.get(id);  // Assuming you're using this for something

      // Check if the object exceeds the right boundary
      if (position.x > width - scale.x) {
        transform.setPosition(new PVector(-scale.x, position.y));
      }
      // Check if the object goes beyond the left boundary
      if (position.x < -scale.x) {
        transform.setPosition(new PVector(width + scale.x, position.y));
      }

      // Check if the object exceeds the bottom boundary
      if (position.y > height - scale.y) {
        transform.setPosition(new PVector(position.x, -scale.y));
      }
      // Check if the object goes above the top boundary
      if (position.y < -scale.y) {
        transform.setPosition(new PVector(position.x, height + scale.y));
      }
    }
  }
}
