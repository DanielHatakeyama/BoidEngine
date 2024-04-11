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
    if (renderFunction != null) {
      renderFunction.render(renderContext, transform);
    }
  }
}
