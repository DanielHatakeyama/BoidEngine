public interface BoidBehavior {

  PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors);
}

public class FlockBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {

    if (neighbors.size() == 0) return new PVector(0, 0);

    // Calculate movement direction based on all flocking rules:

    PVector separationForce = new PVector(0, 0);
    PVector cohesionForce = new PVector(0, 0);
    PVector alignmentForce = new PVector(0, 0);

    // Force Scalars
    float separationScale = 80f;
    float cohesionScale = 0.5f;
    float alignmentScale = 3f;
    
    // Separation min distance percent
    float minSeparationPercent = 0.3f;

    float numNeighbors = (neighbors.size()==0)? 1f : (float)neighbors.size();

    float minSeparationDistance = minSeparationPercent * boid.getPerceptionRadius();
    float separationNeighbors = 0;
    // Calculate Separation Force:
    for (Boid neighbor : neighbors) {

      PVector difference = PVector.sub(boid.getPosition(), neighbor.getPosition());
      float distance = difference.mag();

      if (distance < minSeparationDistance) {
        difference.normalize();
        println(distance);
        //difference.div(distance*distance);
        separationForce.add(difference);
        separationNeighbors += 1;
      }
    }
    if (separationNeighbors > 0) separationForce.div(separationNeighbors); // This represents the AVERAGE push

    // Calculate Cohesion Force:
    PVector averagePostion = new PVector(0, 0);
    for (Boid neighbor : neighbors) {
      averagePostion.add(neighbor.getPosition());
    }
    averagePostion.div(numNeighbors);
    cohesionForce = PVector.sub(averagePostion, boid.getPosition());


    // Calculate Alignment Force:
    PVector averageVelocity = new PVector(0, 0);
    for (Boid neighbor : neighbors) {
      averageVelocity.add(neighbor.getVelocity());
    }
    averageVelocity.div(numNeighbors);
    alignmentForce = PVector.sub(averageVelocity, boid.getVelocity());

    // Scale all forces by the corresponding multiplier
    separationForce.mult(separationScale);
    cohesionForce.mult(cohesionScale);
    alignmentForce.mult(alignmentScale);

    // Calculate and add net force:
    PVector netForce = new PVector(0, 0);
    netForce.add(separationForce);
    netForce.add(cohesionForce);
    netForce.add(alignmentForce);
    
    //netForce.normalize().div(60);

    return netForce;
  }
}



// TODO: Needs to be completed
public class SeparationBehavior implements BoidBehavior {
  public PVector calculateMovement(Boid boid, ArrayList<Boid> neighbors) {
    if (neighbors.isEmpty()) return new PVector();

    PVector separationVector = new PVector();
    float protectedRange = 100; // Range of the radius
    float avoidFactor = 2f; //avoidance intensity

    for (Boid neighbor : neighbors) {
      float distance = PVector.dist(boid.position, neighbor.position);

      // Check if the neighbor is within the protected range
      if (distance < protectedRange && distance > 0) {
        PVector difference = PVector.sub(boid.position, neighbor.position);
        separationVector.add(difference);
      }
    }

    // Apply the avoid factor to scale the separation force if needed
    separationVector.mult(avoidFactor);

    return separationVector;
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
