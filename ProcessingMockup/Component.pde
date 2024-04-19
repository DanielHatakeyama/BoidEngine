public interface Component {

  /* Description:
   Components are added to entities to compose behavior from small parts.
   */

  /* Method to initialize the component:
   Performs initialization tasks when the component is attached to an entity
   */
  default void initialize() {
  }

  /* Method to clean up the component:
   Performs cleanup tasks when the component is removed from an entity.
   This include removing observers, preventing memory leaks, etc.
   */
  default void cleanup() {
  }
}

// Tags provide a unique identification system of entity types. This is to distinguish two entities that are different but share the same set of components
public class Tag implements Component {
  private String tag;

  public Tag() {
    this.setTag("default");
  }

  public Tag(String tag) {
    this.setTag(tag);
  }

  public String getTag() {
    return tag;
  }

  public void setTag(String tag) {
    this.tag = tag.toLowerCase();
  }
}

public class Transform implements Component {

  protected PVector position;
  protected PVector direction;
  protected PVector scale;

  // Position
  PVector getPosition() {
    return position.copy();
  }
  PVector getDirection() {
    return direction.copy();
  }

  PVector getScale() {
    return scale.copy();
  }

  public Transform() {
    this.position = new PVector(0, 0);
    this.direction = new PVector(0, 1);
    this.scale = new PVector(1, 1);
  }

  public Transform(float initialX, float initialY) {
    this.position = new PVector(initialX, initialY);
    this.direction = new PVector(0, 1);
    this.scale = new PVector(1, 1);
  }

  public Transform(PVector initialPosition, PVector initialDirection) {
    this.position = initialPosition.copy();
    this.direction = initialDirection.copy();
    this.scale = new PVector(1, 1);
  }

  public void setPosition(PVector position) {
    this.position = position;
  }

  public void setDirection(PVector direction) {
    this.direction = direction.normalize(); // Ensure the vector is normalized
  }

  public void setScale(PVector scale) {
    this.scale = scale;
  }

  public void moveBy(PVector moveAmount) {
    setPosition(PVector.add(this.position, moveAmount));
  }

  public void rotateBy(float angle) {
    direction.rotate(angle);
  }
}


/* Component interface for rendering behavior:
 TODO: Make this more portable to other non processing systems, aka an abstract class and an extended processing specific renderer
 */
public class Renderer implements Component {

  private RenderFunction renderFunction;

  public Renderer(RenderFunction renderFunction) {
    this.renderFunction = renderFunction;
  }

  // Make set render function / get render function / remove render function

  public void render(PGraphics renderContext, Transform transform) {
    println("In render component.render");
    if (renderFunction != null) {
      renderFunction.render(renderContext, transform);
    }
  }
}


public class RigidBody implements Component {
  
  public PVector velocity = new PVector(0,0);
  public PVector acceleration = new PVector(0,0);
  public float mass = 1;
  
  public boolean isStatic = false;
  
  public RigidBody() {
    // Empty default constructor
    // TODO make a few more constuctors for init velocity and mass, no init acceleration
    // TODO make a few more changes to also allow for creation of static bodies.
  }
  
  public void applyForce(PVector force) {
    if (isStatic) return;
    PVector forceAcc = PVector.div(force, mass);
    acceleration.add(forceAcc);
  }
  
  public void update(int deltaTime) {
    if (isStatic) return;
    velocity.add(PVector.mult(acceleration, deltaTime));
    acceleration.mult(0); // Clear acc after each update, i guess unless it is gravity but we aint doing that, there is a better way to do this i think
  }
  
}power
  
