import java.util.ArrayList;
import java.util.List;

public class EntityBuilder {
  private final EntityManager entityManager;
  private final Entity entity;
  private final List<Component> componentsToNotify;  // List to store components temporarily


  // When builder is constructed in the context of the entity manager class, we create new entity with the genrated id
  public EntityBuilder(EntityManager entityManager, int entityId, List<String> tags) {
    this.entityManager = entityManager;
    this.entity = new Entity(entityId);
    this.componentsToNotify = new ArrayList<>();
    
    // TODO SCUFFED
    // Add tags - TODO this can be made way better
    if (tags != null) {
      for (String tag : tags) {
        entity.addTag(tag);
      }
    }

    //// Transform and Tag components are being added by default
    //Transform defaultTransform = new Transform();  // Example: create a default transform
    //Tag defaultTag = new Tag("default");  // Example: create a default tag
    //this.componentsToNotify.add(defaultTransform);
    //this.componentsToNotify.add(defaultTag);

    // TODO add transform and tag components by default since all entities should have a default tag and a transform.
    print("EntityBuilder: ID " + entity.getID());
  }

  // Add methods to configure the entity as needed
  public EntityBuilder with(Component component) {
    print();
    // TODO make this so all of the events are done after create is called in a buffer IMPORTANT
    this.entity.addComponent(component);
    this.componentsToNotify.add(component);
    return this;
  }

  // Method to build and return the created entity
  // printing / logging is handled, it is jank
  public Entity create() {
    
    entityManager.addEntity(entity);

    // Logging logic for prettyness
    print(" | with components (");
    boolean isFirst = true;
    
    for (Component component : componentsToNotify) {
      // Actually important, call events of component added.
      eventManager.notifySubscribers(new ComponentAddedEvent(entity, component));
      
      // Printing logic
      print((isFirst ? "" : ", ") + component.getClass().getSimpleName());
      isFirst = false;
    }
    
    // End printing component logic
    println(") - Created");
    
    return entity;
  }
}
