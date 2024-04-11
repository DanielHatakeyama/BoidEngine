import java.util.Map;

public class Entity {

  /* Description:
   Entity is an object that can have components. Components are handled and define
   all of the behavior we want. The big picture of this approach is to facor composition
   over inheritance to reduce dependencies. For example a Boid gameObject is a gameObject
   that would have components that give its behavior, rendering, collisions, etc.
   Research ECS pattern for details.
   */

  // ---------- Entity Member Variables ---------- //

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
  public Entity(int id) {
    this.id = id;
  }

  // ---------- Component Handling ---------- //

  /* DESCRIPTION:
   Components are attached to the game entity. For instance if an entity is renderable, we attach a
   'renderable' compoent to the object. This allows us to define the scope and behavior of each entity on instantiation.
   The components attached to a given entity are typically done in the entityManager.
   Components are stored in a map for O(1) look up time.
   */

  // addComponent (with instance of component)
  public <T extends Component> void addComponent(T component) {
    components.put(component.getClass(), component);
    component.initialize();
  }

  // removeComponent (by component class)
  public <T extends Component> void removeComponent(Class<T> componentClass) {
    Component component = components.remove(componentClass);
    component.cleanup();
  }

  // getComponent (by component class)
  public <T extends Component> T getComponent(Class<T> componentClass) {
    return componentClass.cast(components.get(componentClass));
  }

  // hasComponent (of component class) T/F
  public <T extends Component> boolean hasComponent(Class<T> componentClass) {
    return components.containsKey(componentClass);
  }

  public void cleanup() {
    for (Component component : components.values()) {
      removeComponent(component.getClass());
    }
  }
  
  public int getID() {
    return this.id;
  }
  

}
