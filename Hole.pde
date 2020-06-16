public class Hole {

  private float radius;

  private Body body;
  private Vec2 pos;

  public Hole (Vec2 position, float r) {
    radius = r;
    pos = position;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(pos.x/2, pos.y/2));
    body = box2d.world.createBody(bd);

    CircleShape circle = new CircleShape();

    circle.m_radius = box2d.scalarPixelsToWorld(r/2);

    FixtureDef fd = new FixtureDef();
    fd.shape = circle;

    fd.density = 0;
    fd.friction = 0;
    fd.restitution = 0;

    body.createFixture(fd);
    body.setUserData(this);

  }

  public void display() {
    pos = box2d.getBodyPixelCoord(body);
    noStroke();
    fill(255, 128, 0);
    circle(2*pos.x, 2*pos.y, 2*radius);
  }

  public void killBody() {
   box2d.destroyBody(body); 
  }
}
