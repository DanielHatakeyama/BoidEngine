/*
  Design Patter:
    * ECS
    * Interfaces/Inheritance
*/

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
  public void rotateTo(PVector target) {
    direction.set(target.normalize());
  }

  public float distanceTo(Transform other) {
    return this.position.dist(other.position);
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
    render(renderContext, transform, null);
  }

  public void render(PGraphics renderContext, Transform transform, ColorComponent colorComponent) {
    //println("In render component.render");
    if (renderFunction != null) {
      if (colorComponent == null) {
         renderFunction.render(renderContext, transform);
      } else {
        renderFunction.render(renderContext, transform, colorComponent);
      }
     
    }
  }
}

public class ColorComponent implements Component {
  public color primary = color(0, 0, 0, 0);
  public color secondary = color(0, 0, 0, 0);
  public color terinary = color(0, 0, 0, 0);

  public color randomColor = color(random(255), random(255), random(255));

  public ColorComponent(color p, color s, color t) {
    this.primary = p;
    this.secondary = p;
    this.terinary = t;
  }
  public ColorComponent(color p, color s) {
    this.primary = p;
    this.secondary = s;
  }
  public ColorComponent(color p) {
    this.primary = p;
  }

  public color randomColorNext() {
    randomColor = color(random(255), random(255), random(255));
    return randomColor;
  }
  public ColorComponent() {
  };
}

//also is my ecs system even working as an ecs system is supposed to work? I have my systems basically having the whole list of entities- why did i bother with all of these event listeners and abstraction and decoupling if the systems were going to just read from the same list of entities just broken up components from the start? What am I missing here- is it my understanding or my code? I think I did something fundamentally off. I know entities are supposed to have a reference to a bunch of components stored together in memory... do i have to abstract away each of these arrays and then use pointers and some sort of map filtering when iterating


public class RigidBody implements Component {

  private PVector velocity = new PVector(0, 0);
  private PVector acceleration = new PVector(0, 0);
  private float mass = 1;

  public boolean isStatic = false;


//Empty - BEN XIANG
  public RigidBody() {
    // Empty default constructor
    // TODO make a few more constuctors for init velocity and mass, no init acceleration
    // TODO make a few more changes to also allow for creation of static bodies.
  }

  public void applyForce(PVector force) {

    // Return early if needed
    if (isStatic) return;
    if (force.x == 0 && force.y == 0) return; // no work for 3d

    PVector forceAcc = PVector.div(force, mass);
    acceleration.add(forceAcc);
  }

  public void update(float deltaTime) {

    if (isStatic) return;
    velocity.add(PVector.mult(acceleration, deltaTime));
    acceleration.mult(0); // Clear acc after each update, i guess unless it is gravity but we aint doing that, there is a better way to do this i think
  }

  public PVector getVelocity() {
    return this.velocity.copy();
  }

  public void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }
}

public class ClanComponent implements Component {
    public String name;
    public color clanColor;

    public ClanComponent(String name, color clanColor) {
        this.name = name;
        this.clanColor = clanColor;
    }
}