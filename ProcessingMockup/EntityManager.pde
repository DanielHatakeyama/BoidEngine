import java.util.HashMap;
import java.util.Map;

// TODO Explain later, main idea is give entity an id so they can be stored in LUT
// We have serveral things to help run the game more like create destroy and modify components of a game object
import java.util.HashMap;
import java.util.Map;

public class EntityManager {
  private int nextEntityId = 0;
  private Map<Integer, Entity> entities = new HashMap<>();

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
    if (entity != null) {
      // cleanup entity
      entity.cleanup();
    }
  }

  // ---------- Entity Management ---------- //


  // Attach a component to an entity
  public <T extends Component> void attachComponent(int entityId, T component) {
    entities.get(entityId).addComponent(component);
  }

  // Remove a component from an entity
  public <T extends Component> void removeComponent(int entityId, Class<T> componentClass) {
    entities.get(entityId).removeComponent(componentClass);
  }

  // Get a component attached to an entity // TODO might need to make some error catching
  public <T extends Component> T getComponent(int entityId, Class<T> componentClass) {
    return entities.get(entityId).getComponent(componentClass); //<>//
  }

  public Entity getEntityByID(int entityID) {
    // Check map for given ID
    Entity entity = entities.get(entityID);
    // Handle the case where the specified ID does not exist
    if (entity == null) throw new IllegalArgumentException("No entity found with ID: " + entityID);
    return entity;
  }
  
  public Map<Integer, Entity> TestingGetEntities() {
    return this.entities;
  }
}
