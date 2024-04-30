/*
  Design patter:
    * Dependency injection
*/
import java.util.ArrayList;
import java.util.List;

public class SystemManager {
  private List<System> systems = new ArrayList<>();

  private final EventManager eventManager;

  public SystemManager (EventManager eventManager) {
    this.eventManager = eventManager;
  }

  public void addSystem(System system) {
    // Set the event manager with the DI event manager
    // This could be refactored and abstracted further with a factory pattern for marginal readibility and safety benifit
    system.setEventManager(this.eventManager);
    systems.add(system);
  }

  public void removeSystem(System system) {
    systems.remove(system);
  }

  public void updateAll(float deltaTime) {
    //println("Updating all systems...");
    
    for (System system : systems) {
      system.update(deltaTime);
    }
    
  }
}
