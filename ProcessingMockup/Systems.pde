import java.util.Set; //<>//
import java.util.HashSet;

public abstract class System {
  protected EventManager eventManager;

  public System(EventManager eventManager) {
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

// Finally im coding and it doesnt have to be perfect
public class RenderSystem extends System {

  public PGraphics renderContext;

  // ID - Component pairs -> Decouples entity from the system - component calculation
  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, Renderer> renderers = new HashMap<>();

  public RenderSystem(EventManager eventManager, PGraphics renderContext) {
    super(eventManager);
    this.renderContext = renderContext;
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
    println("Adding id:" + ID + " to renderers.");
  }

  @Override
    protected void onComponentRemoved(Entity entity, Component component) {
    // Implementation for removing a component from the rendering system
    Integer ID = entity.getID();
    renderers.remove(ID);
    transforms.remove(ID);
    println("Removing id:" + ID + " from renderers.");
  }

  @Override
    public void update(float deltaTime) {
    for (Integer id : renderers.keySet()) {
      println("Updating rendererSystem (in loop) : " + id);
      Renderer renderer = this.renderers.get(id);
      Transform transform = this.transforms.get(id);

      if ((renderer == null) || (transform == null)) continue; // TODO ben, make this print a warning / return an exception

      renderer.render(renderContext, transform);
    }
  }
}


// Finally im coding and it doesnt have to be perfect
public class PhysicsSystem extends System {

  // ID - Component pairs -> Decouples entity from the system - component calculation
  private Map<Integer, Transform> transforms = new HashMap<>();
  private Map<Integer, RigidBody> rigidBodies = new HashMap<>();

  public PhysicsSystem(EventManager eventManager) {
    super(eventManager);
  }

  @Override
    protected boolean matchesSystemCriteria(ComponentEvent event) {
    return event.isComponentType(RigidBody.class);
  }

  @Override
    protected void onComponentAdded(Entity entity, Component component) {
    Integer ID = entity.getID();
    transforms.put(ID, entity.getComponent(Transform.class));
    rigidBodies.put(ID, (RigidBody)component);
    println("Adding id:" + ID + " to rigidbody.");
  }

  @Override
    protected void onComponentRemoved(Entity entity, Component component) {
    // Implementation for removing a component from the rendering system // todo for ben
    Integer ID = entity.getID();
    rigidBodies.remove(ID);
    transforms.remove(ID);
    println("Removing id:" + ID + " from rigidbody.");
  }

  @Override
    public void update(float deltaTime) {
    println("Updating physicsSystem");
    for (Integer id : rigidBodies.keySet()) {

      RigidBody rigidBody = this.rigidBodies.get(id);
      Transform transform = this.transforms.get(id);
      

      if ((rigidBody == null) || (transform == null)) continue; // TODO for ben, do the same thing for this one.
      
      rigidBody.applyForce(new PVector(1,0) );
      
      rigidBody.update(1);
      
      PVector velocity = rigidBody.getVelocity();
      PVector moveAmount = PVector.mult(rigidBody.getVelocity(), deltaTime);
      
      transform.moveBy(moveAmount);
      
    }
  }
}
