class Button {
  float x, y, w, h, padding;
  boolean isBar;
  String[] text = {"Transform To Line", "Transform To Bar"};
  color c;
  
  Button (float x, float y) {
    this.x = x;
    this.y = y;
    w = textWidth("flip") + 10;
    h = textAscent()+10;
  }
  
  boolean isActive() {
    if (mouseX > x-w/2 && mouseX < x+w/2 && mouseY > y-h/2 && mouseY < y+h/2) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    stroke(#cccccc);
    fill(255,255,255);
    rectMode(CENTER);
    rect(x, y, w, h, 7);
    fill(black);
    textAlign(CENTER, CENTER);
    text("Flip", x, y);
    noStroke();
  }
}