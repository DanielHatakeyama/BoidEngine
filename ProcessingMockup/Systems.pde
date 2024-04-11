
public interface System {
    void update(float deltaTime);
    // You can include methods for handling entity changes if needed
}

public class RenderSystem {


  public void renderEntity(PGraphics renderContext, Entity entity) {
    Renderer renderer = entity.getComponent(Renderer.class);
    Transform transform = entity.getComponent(Transform.class);

    if (renderer != null && transform != null) {
      renderer.render(renderContext, transform);
    }
  }
}
