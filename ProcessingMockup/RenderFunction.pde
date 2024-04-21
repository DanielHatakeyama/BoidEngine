
// TODO REFACTOR SO IT EXISTS AS A SAVED PGRAPHICS OBJECT THAT CAN BE UPDATED / SET AT TIMES, BUT STAYS SAME I CAN THINK THIS THROUGH LATER:


public interface RenderFunction {
  void render(PGraphics renderContext, Transform transform);
}

public class CircleRenderFunction implements RenderFunction {


  void render(PGraphics renderContext, Transform transform) {
    //println("In CircleRenderFunction");

    PVector pos = transform.getPosition();
    PVector dir = transform.getDirection();
    PVector scale = transform.getScale();

    //println("In CircleRenderFunction PASSED ASSIGNMENT");


    color primaryColor = color(180, 30, 70);

    renderContext.push();
    //println("In CircleRenderFunction renderContext.push();");

    renderContext.fill(primaryColor);
    renderContext.circle(pos.x, pos.y, 15f);
    renderContext.pop();
  }
}
