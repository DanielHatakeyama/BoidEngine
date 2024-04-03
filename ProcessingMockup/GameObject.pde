import java.util.Map;

public class GameObject {
  
  // WARNING THIS CLASS WILL BE REFACTORED INTO THE ENTITY CLASS THAT IS MADE. THIS WILL BE DISCONTINUED.

  /* Description:
   GameObject is an object that can have components. Components are handled and define
   all of the behavior we want. The big picture of this approach is to facor composition
   over inheritance to reduce dependencies. For example a Boid gameObject is a gameObject
   that would have components that give its behavior, rendering, collisions, etc.
   Research ECS pattern for details.
   */

  // ---------- GameObject Member Variables ---------- //

  /* ID System:
   The unique ID of is made and handled in the manager
   */
  private int id;

  /* Components:
   We store the gameObject components as a map, and use componentType as a LUT.
   This solves the problem of handling duplicate components (no duplicates allowed)
   and lets us find a given component in O(1) time!
   */
  private Map<Class<? extends Component>, Component> components = new HashMap<>();


  // ---------- Constructor ---------- //
  public GameObject(int id) {
    this.id = id;
  }

  // ---------- Component Handling ---------- //

  /* DESCRIPTION:
   Components are attached to the game object. For instance if a game object is renderable, we attach a
   'renderable' compoent to the object. This allows us to define the scope and behavior of each game object on instantiation.
   The components attached to a given gameObject should be defined in factory / builder method for the gameObject or in the
   constructor for the subClass. Components are stored as a map for O(1) look up time.
   */

  // addComponent (with instance of component)
  public <T extends Component> void addComponent(T component) {
    components.put(component.getClass(), component);
  }

  // removeComponent (by component class)
  public <T extends Component> void removeComponent(Class<T> componentClass) {
    components.remove(componentClass);
  }

  // getComponent (by component class)
  public <T extends Component> T getComponent(Class<T> componentClass) {
    return componentClass.cast(components.get(componentClass));
  }

  // hasComponent (of component class) T/F
  public <T extends Component> boolean hasComponent(Class<T> componentClass) {
    return components.containsKey(componentClass);
  }













  // TODO MOVE ALL OF THIS OUT
  // For accessing in public, making sure you can't mutate directly from the outside

  public PVector getPosition() {
    return this.position.copy();
  }
  public PVector getVelocity() {
    return this.velocity.copy();
  }
  public PVector getAcceleration() {
    return this.acceleration.copy();
  }
  protected PVector position, velocity, acceleration; // todo move to transform and physics

  protected RenderFunction renderFunction; // todo move to renderable

  protected int z = 0; // todo move to renderable



  // TODO: Make this code more modular and for any component
  public void render() {
    push();
    if (renderFunction != null) renderFunction.render((T) this);
    pop();
  }

  public void setRenderFunction(RenderFunction<?> renderFunction) {
    // Enforce type safety by checking if the render function is compatible with the type of game object
    if (renderFunction != null /* && renderFunction.getRenderedObjectType().isAssignableFrom(this.getClass()))*/ ) {
      this.renderFunction = (RenderFunction<T>) renderFunction;
    } else {
      throw new IllegalArgumentException("Render function is not compatible with the type of game object");
    }
  }
}
