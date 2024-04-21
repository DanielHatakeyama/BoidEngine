import java.util.Set; //<>//
import java.util.HashSet;

// TODO refactor systems such that there is only ever one hash map of each component list.
// this should actually be not impossible to do!!!
// Just store the components somewhere and have the event system behave a bit differently to track the references to the relevant component list
// This is a good idea.

public abstract class System {
  protected EventManager eventManager;

  public System() {
    // Note the following todo provides marginal benefit
    // TODO REFACTOR THIS WITH THE FACTORY PATTERN TO MAKE SURE THAT A SYSTEM CANNOT BE CREATED WITHOUT AN EVENT MANAGER
    // This is currently done just with system manager and hoping the user isnt dumb enough to create a system outside of system manager... refactor this
    this.eventManager = null;
  }

  public void setEventManager(EventManager eventManager) {
    this.eventManager = eventManager;

    // Lambdas for event
    this.eventManager.subscribe(ComponentAddedEvent.class, event -> handleComponentAdded(event));
    this.eventManager.subscribe(ComponentRemovedEvent.class, event -> handleComponentRemoved(event));
  }

  private void handleComponentAdded(Event event) {
    if (event instanceof ComponentAddedEvent && matchesSystemCriteria((ComponentEvent) event)) {
      onComponentAdded(((ComponentEvent) event).getEntity(), ((ComponentEvent) event).getComponent());
    }
  }

  private void handleComponentRemoved(Event event) {
    if (event instanceof ComponentRemovedEvent && matchesSystemCriteria((ComponentEvent) event)) {
      onComponentRemoved(((ComponentEvent) event).getEntity(), ((ComponentEvent) event).getComponent());
    }
  }

  // Abstract methods to be implemented by concrete systems
  protected abstract boolean matchesSystemCriteria(ComponentEvent event);
  protected abstract void onComponentAdded(Entity entity, Component component);
  protected abstract void onComponentRemoved(Entity entity, Component component);

  public abstract void update(float deltaTime);
}



// TODO THE RENDERER NEEDS SOME MAJOR REFACTORS TO BE BETTER:
/* need to make it so all rederable entities are prerendered with a pgraphics object
 * separate this by layers, make it so static is done first
 * proper background layers
 * clear or background on a given render context
 * keep the high level render context, but find way to branch and make more dynmically
 */
// Finally im coding and it doesnt have to be perfect
// TODO EXTEND THE LOGIC TO MAKE IT WORK WITH MULTIPLE RENDER CONTEXTS, SEPARATE LAYERS
public class RenderSystem extends System {

  private PGraphics renderContext;

  // ID - Component pairs -> Decouples entity from the system - component calculation
  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, Renderer> renderers = new HashMap<>();

  public RenderSystem() {
    this.renderContext = createGraphics(width, height);
  }

  @Override
    protected boolean matchesSystemCriteria(ComponentEvent event) {
    return event.isComponentType(Renderer.class);
  }

  @Override
    protected void onComponentAdded(Entity entity, Component component) {
    Integer ID = entity.getID();
    transforms.put(ID, entity.getComponent(Transform.class));
    renderers.put(ID, (Renderer)component);
    //println("Adding id:" + ID + " to renderers.");
  }

  @Override
    protected void onComponentRemoved(Entity entity, Component component) {
    // Implementation for removing a component from the rendering system
  }

  // TODO TAKE OUT THE LOGIC FOR INDIVIDUAL RENDER CONTEXT
  @Override
    public void update(float deltaTime) {

    if (renderers.size() == 0) return;

    //println("RenderSystem updating...");

    renderContext.beginDraw();
    renderContext.background(#9CBFED);

    for (Integer id : renderers.keySet()) {

      Renderer renderer = this.renderers.get(id);
      Transform transform = this.transforms.get(id);

      if ((renderer == null) || (transform == null)) continue; // TODO ben, make this print a warning / return an exception

      renderer.render(renderContext, transform);
    }

    renderContext.endDraw();
    image(renderContext, 0, 0);
  }
}

// Finally im coding and it doesnt have to be perfect
public class PhysicsSystem extends System {

  // ID - Component pairs -> Decouples entity from the system - component calculation
  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, RigidBody> rigidBodies = new HashMap<>();

  @Override
    protected boolean matchesSystemCriteria(ComponentEvent event) {
    return event.isComponentType(RigidBody.class);
  }

  @Override
    protected void onComponentAdded(Entity entity, Component component) {
    Integer ID = entity.getID();
    transforms.put(ID, entity.getComponent(Transform.class));
    rigidBodies.put(ID, (RigidBody)component);
    // println("Adding id:" + ID + " to rigidbody.");
  }

  @Override
    protected void onComponentRemoved(Entity entity, Component component) {
    // Implementation for removing a component from the rendering system // todo for ben
  }

  @Override
  public void update(float deltaTime) {
    
    if (transforms.size() == 0) return; // maybe amake a better way to do this check for each system in tyhe system manager TODO mild importance
    //println("Updating physicsSystem");

    for (Integer id : rigidBodies.keySet()) {

      //println("PhysicsSystem updating...");

      RigidBody rigidBody = this.rigidBodies.get(id);
      Transform transform = this.transforms.get(id);

      if ((rigidBody == null) || (transform == null)) continue; // TODO for ben, do the same thing for this one.

      rigidBody.update(deltaTime);

      PVector velocity = rigidBody.getVelocity();
      PVector moveAmount = PVector.mult(velocity, deltaTime);

      transform.moveBy(moveAmount);
    }
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
