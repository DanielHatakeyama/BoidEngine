public interface BoidBehavior {

  PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors);
}

public class FlockBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    // Calculate movement direction based on all flocking rules:
    
    PVector separationForce = new PVector(0,0);
    PVector cohesionForce = new PVector(0,0);
    PVector alignmentForce = new PVector(0,0);
    
    // Calculate Separation Force:
    // separationForce = new PVector(1,0);
    
    // Calculate Cohesion Force:


    // Calculate Alignment Force:



    // Calculate and add net force:
    PVector netForce = separationForce.add(cohesionForce).add(alignmentForce);
    return netForce;
  }
}


public class SeparationBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    // Calculate movement direction based on separation rule
    return new PVector();
  }
}

public class AlignmentBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    // Calculate movement direction based on alignment rule
    return new PVector();
  }
}

public class CohesionBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    // Calculate movement direction based on cohesion rule
    return new PVector();
  }
}

// Circle behavior class
class CircleBehavior implements BoidBehavior {
  private float angularSpeed;

  CircleBehavior(float angularSpeed) {
    this.angularSpeed = angularSpeed;
  }

  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    // Calculate movement to make the boid turn in a circle
    PVector rotation = boid.velocity.copy().rotate(HALF_PI); // Perpendicular to velocity
    rotation.normalize().mult(angularSpeed); // Set magnitude
    return rotation;
  }
}
