// Interface for renderable game objects
interface Renderable {
  void render();
  void setRenderFunction(RenderFunction<?> renderFunction);
}

// Function interface for rendering game objects
interface RenderFunction<T> {
    void render(T gameObject);
}


class SimpleBoid implements RenderFunction<Boid> {
  public void render(Boid boid) {
    
    PVector pos = boid.position;
    PVector vel = boid.velocity.copy();
    PVector velDir = vel.copy().normalize();
    
    // TODO, this is just for testing, will eventually move these vars to better encapsulate 
    color primaryColor = color(000000);
    float size = 15f;
    
    stroke(0);
    strokeWeight(1.5);
    fill(primaryColor);
    circle(pos.x, pos.y, size);
    
    fill(255);
    circle(pos.x+(3*velDir.x), pos.y+(3*velDir.y), 7f);

    // temp direction showing
    stroke(color(255, 0, 0));
    line(pos.x, pos.y, pos.x + vel.x * 10f, pos.y + vel.y * 10f);
  }
}

class SimpleBoidDebug implements RenderFunction<Boid> {
  public void render(Boid boid) {
    
    PVector pos = boid.position;
    PVector vel = boid.velocity.copy();
    PVector velDir = vel.copy().normalize();
    
    // TODO, this is just for testing, will eventually move these vars to better encapsulate 
    color primaryColor = color(000000);
    float size = 15f;
    
    stroke(0);
    strokeWeight(1.5);
    fill(primaryColor);
    circle(pos.x, pos.y, size);
    
    fill(255);
    circle(pos.x+(3*velDir.x), pos.y+(3*velDir.y), 7f);
    
    push();
    noStroke();
    fill(153, 255, 153, 20);
    circle(pos.x, pos.y, 2* boid.getPerceptionRadius());
    
    pop();
    
    
    // temp direction showing
    stroke(color(255, 0, 0));
    line(pos.x, pos.y, pos.x + vel.x * 10f, pos.y + vel.y * 10f);
  }
}
