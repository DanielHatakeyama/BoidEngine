/*
    Design Pattern:
      * Strat 
*/

// TODO REFACTOR SO IT EXISTS AS A SAVED RENDER
public interface RenderFunction {
  void render(PGraphics renderContext, Transform transform);
  default void render(PGraphics renderContext, Transform transform, ColorComponent colorComponent) {
  }
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
  void render(PGraphics renderContext, Transform transform, ColorComponent colorComponent) {
    PVector pos = transform.getPosition();
    PVector dir = transform.getDirection();
    PVector scale = transform.getScale();

    //println("In CircleRenderFunction PASSED ASSIGNMENT");

    renderContext.push();
    //println("In CircleRenderFunction renderContext.push();");

    renderContext.fill(colorComponent.primary);

    if (alpha(colorComponent.secondary) == 0) {
      renderContext.noStroke();
    } else {
      renderContext.stroke(colorComponent.secondary);
    }

    renderContext.circle(pos.x, pos.y, 15f);
    renderContext.pop();
  }
}

public class BoidTriangle implements RenderFunction {
  
  PVector lookDirection = new PVector(random(-.4f, .4f), random(-.2f, .5f));
  float lookScale = random(.3f,1);
  float lookSpeed = 0.1f;

  // Default colora values (if no color component passed in / colorcomponent == null)
  color primaryColor = color(255);
  color secondaryColor = color(0);
  
  void render(PGraphics renderContext, Transform transform, ColorComponent colorComponent) {
    PVector pos = transform.getPosition();
    PVector dir = transform.getDirection();
    PVector scale = transform.getScale();
    
    if (colorComponent != null) {
      this.primaryColor = colorComponent.primary;
      this.secondaryColor = colorComponent.secondary;
    }

    dir.normalize();

    renderContext.push(); // Save the current state of the renderContext

    // Move the coordinate system to the position where the triangle should be drawn
    renderContext.translate(pos.x, pos.y);

    //float angle = PVector.angleBetween(new PVector(0, 1), dir); // Angle with respect to the positive y-axis
    float angle = atan2(dir.y, dir.x) - HALF_PI;
    //if (dir.x < 0) angle = -angle; // Correct the rotation direction based on the x component

    renderContext.rotate(angle);

    // Define the base width and height of the triangle based on scale
    float baseW = 8 * scale.x;
    float baseH = baseW * 2 * scale.y;

    renderContext.fill(primaryColor);
    renderContext.noStroke();

    // Draw the triangle
    renderContext.triangle(
      -baseW / 2, -baseH / 2, // Bottom left vertex
      baseW / 2, -baseH / 2, // Bottom right vertex
      0, baseH / 2                // Top vertex (apex)
      );

    float eyeOuterDiameter = .8f * baseW;
    float eyeInnerDiameter = eyeOuterDiameter * 0.65f;
    float maxLookAmount = eyeOuterDiameter - eyeInnerDiameter;
    float lookAmount = lookScale * maxLookAmount;
    PVector lookVector = PVector.mult(lookDirection, lookAmount);

    float eyeBridgeWidth = eyeOuterDiameter * 0.7f;
    float eyeVerticalOffset = baseH * -0.2f;

    // Base Eye
    renderContext.translate(0, eyeVerticalOffset);
    renderContext.translate(eyeBridgeWidth/2f, 0);
    renderContext.fill(255);
    renderContext.circle(0, 0, eyeOuterDiameter);

    renderContext.translate(-eyeBridgeWidth, 0);
    renderContext.fill(255);
    renderContext.circle(0, 0, eyeOuterDiameter);

    // Pupils
    renderContext.translate(lookVector.x/2, lookVector.y/2);
    renderContext.translate(eyeBridgeWidth, 0);
    renderContext.fill(0);
    renderContext.circle(0, 0, eyeInnerDiameter);

    renderContext.translate(-eyeBridgeWidth, 0);
    renderContext.fill(0);
    renderContext.circle(0, 0, eyeInnerDiameter);

    renderContext.pop(); // Restore the original state of the renderContext
  }

  void render(PGraphics renderContext, Transform transform) {
    ColorComponent colorComponent = null;
    render(renderContext, transform, colorComponent);
  }
}



public class BoidTriangleDebug implements RenderFunction {
  
  PVector lookDirection = new PVector(random(-.4f, .4f), random(-.2f, .5f));
  float lookScale = random(.3f,1);
  float lookSpeed = 0.1f;

  // Default colora values (if no color component passed in / colorcomponent == null)
  color primaryColor = color(255);
  color secondaryColor = color(0);
  
  void render(PGraphics renderContext, Transform transform, ColorComponent colorComponent) {
    PVector pos = transform.getPosition();
    PVector dir = transform.getDirection();
    PVector scale = transform.getScale();
    
    if (colorComponent != null) {
      this.primaryColor = colorComponent.primary;
      this.secondaryColor = colorComponent.secondary;
    }

    // INPUT FOR DEBUG:
    // float perceptionRadius = 110f;
    // float debugVisionOpacity = 10f;
    
    // color c = color(this.primaryColor); // Original color copy
    // // Mask out the old alpha and set the new alpha
    // color visionBubbleColor = (c & 0x00FFFFFF) | (debugVisionOpacity << 24);

    color visionBubbleColor = color(1,1,1,10);

    renderContext.push();
    renderContext.fill(visionBubbleColor);
    renderContext.stroke(secondaryColor);
    
    renderContext.circle(pos.x, pos.y, 2*perceptionRadius);

    new BoidTriangle().render(renderContext, transform, colorComponent);

    renderContext.pop();

  }

  void render(PGraphics renderContext, Transform transform) {
    ColorComponent colorComponent = null;
    render(renderContext, transform, colorComponent);
  }
}
