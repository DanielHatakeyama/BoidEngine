
public interface RenderFunction {
    void render(PGraphics renderContext, Transform transform);
}

public class CircleRenderFunction implements RenderFunction {
  
  void render(PGraphics renderContext, Transform transform) {
    
    PVector pos = transform.getPosition();
    PVector dir = transform.getDirection();
    PVector scale = transform.getScale();
    
    color primaryColor = color(180, 30, 70);

    renderContext.push();
    renderContext.fill(primaryColor);
    renderContext.circle(pos.x, pos.y, 15f);
    renderContext.pop();
    
  }
  
}
