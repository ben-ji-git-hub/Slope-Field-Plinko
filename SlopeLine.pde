public class SlopeLine { //<>//

  private Body body;
  private Vec2 pos;
  private PVector unitCircleCoord;

  public SlopeLine (int xMidpoint, int yMidpoint, Float slope) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(xMidpoint/2, yMidpoint/2));
    body = box2d.world.createBody(bd);

    pos = box2d.getBodyPixelCoord(body);
    unitCircleCoord = new PVector(
      lineLength/2 * cos(atan(slope)), 
      lineLength/2 * sin(atan(slope)));
    //unitCircleCoord = new PVector(0,0);

    Vec2 coord1 = new Vec2(
      box2d.scalarPixelsToWorld(unitCircleCoord.x/2), 
      box2d.scalarPixelsToWorld(unitCircleCoord.y/2));
    Vec2 coord2 = new Vec2(
      box2d.scalarPixelsToWorld(-unitCircleCoord.x/2), 
      box2d.scalarPixelsToWorld(-unitCircleCoord.y/2));

    EdgeShape slopeLine = new EdgeShape();
    slopeLine.set(coord1, coord2);

    FixtureDef fd = new FixtureDef();
    fd.shape = slopeLine;
    fd.density = 1;
    fd.friction = .1;
    fd.restitution = 0.1;
    body.createFixture(fd);
  }

  void display() {
    stroke(255);
    fill(255);
    line(
      pos.x*2 - unitCircleCoord.x, 
      pos.y*2 + unitCircleCoord.y, 
      pos.x*2 + unitCircleCoord.x, 
      pos.y*2 - unitCircleCoord.y);
  }

  void killBody() {
    box2d.destroyBody(body);
  }
}
