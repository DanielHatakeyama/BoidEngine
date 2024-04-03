public class EntityBuilder {
    private final EntityManager entityManager;
    private final int entityId;
    private final Entity entity;

    // When builder is constructed in the context of the entity manager class, we create new entity with the genrated id
    public EntityBuilder(EntityManager entityManager, int entityId) {
        this.entityManager = entityManager;
        this.entityId = entityId;
        this.entity = new Entity(entityId);
    }

    // Add methods to configure the entity as needed
    public EntityBuilder with(Component component) {
        entity.addComponent(component);
        return this;
    }

    // Method to build and return the created entity
    public Entity create() {
        entityManager.addEntity(entity);
        return entity;
    }
}
