
public abstract class GameObject<T> implements Renderable {


  protected PVector position, velocity, acceleration;

  protected RenderFunction renderFunction;
  
  protected int z = 0;

  @Override
  public void render() {
    push();
    if (renderFunction != null) renderFunction.render((T) this);
    pop();
  }

  @Override
  public void setRenderFunction(RenderFunction<?> renderFunction) {
    // Enforce type safety by checking if the render function is compatible with the type of game object
    if (renderFunction != null /* && renderFunction.getRenderedObjectType().isAssignableFrom(this.getClass()))*/ ) {
      this.renderFunction = (RenderFunction<T>) renderFunction;
    } else {
      throw new IllegalArgumentException("Render function is not compatible with the type of game object");
    }
  }
}
