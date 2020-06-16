public class Ball {

  private float radius;

  private Body body;
  private Vec2 pos;

  public Ball (Vec2 pos, float r, boolean duckHunt) {
    radius = r;
    makeBody(pos, r, duckHunt);
  }

  public Ball (Vec2 pos, Vec2 vel, float r, boolean duckHunt) {
    radius = r;
    makeBody(pos, vel, r, duckHunt);
  }

  public void display() {
    pos = box2d.getBodyPixelCoord(body);
    noStroke();
    fill(255);
    pushMatrix();
    translate(pos.x, pos.y);
    circle(pos.x, pos.y, 2*radius);
    popMatrix();
  }

  public void killBody() {
    box2d.destroyBody(body);
  }

  public void disableGravity() {
    body.setGravityScale(0);
  }

  public void setVelocity(Vec2 v) {
  body.setLinearVelocity(v);
  }

  public Vec2 getVelocity() {
    return body.getLinearVelocity();
  }

  private void makeBody(Vec2 pos, float r, boolean duckHunt) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(pos.x/2, pos.y/2));
    body = box2d.world.createBody(bd);

    CircleShape circle = new CircleShape();

    circle.m_radius = box2d.scalarPixelsToWorld(r/2);

    FixtureDef fd = new FixtureDef();
    fd.shape = circle;

   if (duckHunt) {
      fd.density = 1;
      fd.friction = 0;
      fd.restitution = 1;
    } else {
      fd.density = 1;
      fd.friction = .9;
      fd.restitution = .6;
    }
    
    body.createFixture(fd);
    body.setUserData(this);
  }

  private void makeBody(Vec2 pos, Vec2 vel, float r, boolean duckHunt) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(pos.x/2, pos.y/2));
    body = box2d.world.createBody(bd);
    body.setLinearVelocity(vel);

    CircleShape circle = new CircleShape();

    circle.m_radius = box2d.scalarPixelsToWorld(r/2);

    FixtureDef fd = new FixtureDef();
    fd.shape = circle;
    
    if (duckHunt) {
      fd.density = 1;
      fd.friction = 0;
      fd.restitution = 1;
    } else {
      fd.density = 1;
      fd.friction = .9;
      fd.restitution = .6;
    }
    
    body.createFixture(fd);
    body.setUserData(this);
  }
}
