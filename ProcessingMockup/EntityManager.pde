import java.util.HashMap; //<>//
import java.util.Map;

// TODO Explain later, main idea is give entity an id so they can be stored in LUT
// We have serveral things to help run the game more like create destroy and modify components of a game object
import java.util.HashMap;
import java.util.Map;

public class EntityManager {
  private int nextEntityId = 0;
  private Map<Integer, Entity> entities = new HashMap<>();

  private EventManager eventManager;

  public EntityManager(EventManager eventManager) {
    this.eventManager = eventManager;
  }


  // ---------- Entity Creation ---------- //

  // Create a new entity with an automatically generated ID
  public EntityBuilder buildEntity() {
    return new EntityBuilder(this, nextEntityId++);
  }

  // Method to add the created entity to the entity manager
  public void addEntity(Entity entity) {
    entities.put(entity.getID(), entity);
  }

  // Delete an entity by removing it from the map
  public void deleteEntity(int entityId) {
    Entity entity = entities.remove(entityId);
    if (entity == null) return;

    for (Component component : entity.getComponents()) {
      // TODO remove component and unsubscibe them
    }

    entity.cleanup();
  }

  // ---------- Entity Management ---------- //


  // Attach a component to an entity
  // Note absense of checks for duplicates. this should be okay bc of datastructures using, but dont attach component more than once bro.
  public <T extends Component> void attachComponent(int entityId, T component) {
    println("Attach component");

    Entity entity = entities.get(entityId);
    if (entity == null) return;

    // can be thought of set component, can explore this later to make it clearer and avoid resetting if that is a concern
    entity.addComponent(component);
    
    println("Notifying Subscribers of Component Added");
    eventManager.notifySubscribers(new ComponentAddedEvent(entity, component));
    
  }
  
  

  // Remove a component from an entity
  public <T extends Component> void removeComponent(int entityId, Class<T> componentClass) {
    
    Entity entity = entities.get(entityId);
    if (entity == null) return;
    
    Component component = entity.getComponent(componentClass);
    eventManager.notifySubscribers(new ComponentRemovedEvent(entity, component));
    entity.removeComponent(componentClass);

  }

  // Get a component attached to an entity // TODO might need to make some error catching
  public <T extends Component> T getComponent(int entityId, Class<T> componentClass) {

    Entity entity = entities.get(entityId);

    return (entity != null)? entity.getComponent(componentClass) : null;
  }

  public Entity getEntityByID(int entityID) {
    // Check map for given ID
    Entity entity = entities.get(entityID);
    // Handle the case where the specified ID does not exist // MAYBE JUST RETURN NULL???? TODO FOR FUTURE DECISION
    if (entity == null) throw new IllegalArgumentException("No entity found with ID: " + entityID);
    return entity;
  }

  // this is for testing should not be used, breaks encapsulation
  public Map<Integer, Entity> TestingGetEntities() {
    return this.entities;
  }
}
