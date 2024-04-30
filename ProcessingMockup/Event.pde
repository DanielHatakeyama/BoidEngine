/*
  Deisgn Patter:
    * Observer
*/

import java.util.Map;
import java.util.Arrays;


public interface Event {
  // Define methods common to all events, havent decided on this yet
}

//// Types of events:
//public class CollisionEvent implements Event {
//    // Add properties specific to collision events
//}

//public class InteractionEvent implements Event {
//    // Add properties specific to interaction events
//}\


public class ComponentEvent implements Event {
  private Entity entity;                                // The entity from which the event originates
  private Component component;                          // The component involved in the event
  private Set<String> associatedTags;                   // A set of tags associated with the entity
  private Class<? extends Component> componentClass;

  public ComponentEvent(Entity entity, Component component) {
    this.entity = entity;
    this.component = component;
    this.componentClass = component.getClass();
    this.associatedTags = entity.getTags();
  }

  public Entity getEntity() {
    return entity;
  }

  public Component getComponent() {
    return component;
  }

  public Class<? extends Component> getComponentClass() {
    return this.componentClass;
  }

  public Set<String> getTags() {
    return associatedTags;
  }

  public boolean isComponentType(Class<? extends Component> type) {
    return type.isInstance(component);
  }

  public boolean hasTags(String... requiredTags) {
    Set<String> entityTags = entity.getTags();
    return Arrays.stream(requiredTags).allMatch(entityTags::contains);
  }
}

public class ComponentAddedEvent extends ComponentEvent {
  public ComponentAddedEvent(Entity entity, Component component) {
    super(entity, component);
  }
}

public class ComponentRemovedEvent extends ComponentEvent {
  public ComponentRemovedEvent(Entity entity, Component component) {
    super(entity, component);
  }
}
