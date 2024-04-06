public interface Component {

  /* Description:
   Components are added to entities to compose behavior from small parts.
   */

  /* Method to initialize the component:
   Performs initialization tasks when the component is attached to an entity
   */
  default void initialize(){
  }

  /* Method to update the component:
   Updates the component's state based on elapsed time to keep steady independent of frame rate.
   */
  default void update(float deltaTime){
  }

  /* Method to clean up the component:
   Performs cleanup tasks when the component is removed from an entity.
   This include removing observers, preventing memory leaks, etc.
   */
  default void cleanup(){
  }
}

public interface Transform extends Component {

  // Position
  PVector getPosition();

  // Set the position of the entity
  void setPosition(PVector position);
}

public class Transform2D implements Transform {

  private PVector position;
  
  public Transform2D(int mouseX, int mouseY){
      this.position.x = mouseX;
      this.position.y = mouseY;
  }
  

  @Override
    PVector getPosition() {
    return this.position;
  }

  @Override
    void setPosition(PVector position) {
    this.position = position;
  }
}

/* Component interface for rendering behavior:
 
 */
public interface Renderer extends Component {
  void render();
}
