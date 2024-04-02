public interface BoidBehavior {

  PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors);
}

public class FlockBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    
    if (neighbors.size() == 0) return new PVector();

    // Calculate movement direction based on all flocking rules:

    PVector separationForce = new PVector(0, 0);
    PVector cohesionForce = new PVector(0, 0);
    PVector alignmentForce = new PVector(0, 0);

    // Calculate Separation Force:

    // Calculate Cohesion Force:
    PVector avg_Position = new PVector(0, 0);
    for (Boid b : neighbors) {
      avg_Position.add(b.position);
    }

    avg_Position.div(neighbors.size());
    cohesionForce =  avg_Position.sub(boid.position);


    // Calculate Alignment Force:
    
   
    PVector avg_Velocity = new PVector(0, 0);
    for (Boid b : neighbors) {
      avg_Velocity.add(b.velocity);
    }

    avg_Velocity.div(neighbors.size());
    alignmentForce =  avg_Velocity.sub(boid.velocity);


    // Calculate and add net force:
    PVector netForce = separationForce.add(cohesionForce).add(alignmentForce);
    return netForce;
  }
}



// TODO: Needs to be completed
public class SeparationBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    // Calculate movement direction based on separation rule
    if (neighbors.size() == 0) return new PVector();

    // Calculate movement direction based on alignment rule
    
    PVector netSeparationForce = new PVector(0, 0);
    for (Boid b : neighbors) {
      float distance = sqrt(sq(boid.position.x - b.position.x)-sq(boid.position.y - b.position.y));
      PVector forceDirection = (boid.position.copy().sub(b.position.copy())).normalize();

      netSeparationForce.add(forceDirection.div(sq(distance)));
    }

    netSeparationForce.div(neighbors.size());
    return netSeparationForce.sub(boid.position);
  }
}

// TODO: Needs to be completed
public class AlignmentBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    if (neighbors.size() == 0) return new PVector();

    // Calculate movement direction based on alignment rule
    PVector avg_Velocity = new PVector(0, 0);
    for (Boid b : neighbors) {
      avg_Velocity.add(b.velocity);
    }

    avg_Velocity.div(neighbors.size());
    return avg_Velocity.sub(boid.velocity);
  }
}

// TODO: Needs to be completed
public class CohesionBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    // Calculate movement direction based on cohesion rule
    if (neighbors.size() == 0) return new PVector();

    // Calculate movement direction based on alignment rule
    PVector avg_Position = new PVector(0, 0);
    for (Boid b : neighbors) {
      avg_Position.add(b.position);
    }

    avg_Position.div(neighbors.size());
    return avg_Position.sub(boid.position);
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
