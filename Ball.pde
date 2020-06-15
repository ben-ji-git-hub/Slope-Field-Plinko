public class Ball {

  private float radius;

  private Body body;
  private Vec2 pos;

  public Ball (Vec2 pos, float r) {
      radius = r;
      makeBody(pos, new Vec2 (0,0), r); 
  }
  
   public Ball (Vec2 pos, Vec2 vel, float r) {
      radius = r;
      makeBody(pos, vel, r); 
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
  private void makeBody(Vec2 pos, Vec2 vel, float r) {
      BodyDef bd = new BodyDef();
      bd.type = BodyType.DYNAMIC;
      bd.position.set(box2d.coordPixelsToWorld(pos.x/2, r));
      body = box2d.world.createBody(bd);
      body.setLinearVelocity(vel);
      
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
}
