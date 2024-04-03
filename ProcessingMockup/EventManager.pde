public class EventManager {
    private Map<Class<? extends Event>, List<Observer>> observers;

    public EventManager() {
        this.observers = new HashMap<>();
    }

    public void subscribe(Class<? extends Event> eventType, Observer observer) {
        observers.computeIfAbsent(eventType, k -> new ArrayList<>()).add(observer);
    }

    public void publish(Event event) {
        List<Observer> eventObservers = observers.get(event.getClass());
        if (eventObservers != null) {
            for (Observer observer : eventObservers) {
                observer.handleEvent(event);
            }
        }
    }
}

public interface Observer {
    void handleEvent(Event event);
}
