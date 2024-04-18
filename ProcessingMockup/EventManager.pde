import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public interface EventListener {
  void handleEvent(Event event);
}

public class EventManager {
  private Map<Class<? extends Event>, List<EventListener>> subscribers = new HashMap<>();

  public void subscribe(Class<? extends Event> eventType, EventListener listener) {
    subscribers.computeIfAbsent(eventType, k -> new ArrayList<>()).add(listener);
  }

  public void unsubscribe(Class<? extends Event> eventType, EventListener listener) {
    List<EventListener> listeners = subscribers.get(eventType);

    if (listeners == null) return;

    listeners.remove(listener);
    
    if (listeners.isEmpty()) subscribers.remove(eventType);
  }

  public void notifySubscribers(Event event) {
    List<EventListener> listeners = subscribers.get(event.getClass());

    if (listeners == null) return;

    for (EventListener listener : listeners) {
      listener.handleEvent(event);
    }
  }
}
