public class Ball {

  private float radius;

  private Body body;
  private Vec2 pos;

  public Ball (float x, float r) {
      radius = r;
  
      BodyDef bd = new BodyDef();
      bd.type = BodyType.DYNAMIC;
      bd.position.set(box2d.coordPixelsToWorld(x/2, r));
      body = box2d.world.createBody(bd);

      CircleShape circle = new CircleShape();
      
      circle.m_radius = box2d.scalarPixelsToWorld(r/2);
  
      FixtureDef fd = new FixtureDef();
      fd.shape = circle;
  
      fd.density = 1;
      fd.friction = 0.9;
      fd.restitution = .8;
  
      body.createFixture(fd);
      body.setUserData(this);
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

  void killBody() {
     box2d.destroyBody(body); 
  }
}
