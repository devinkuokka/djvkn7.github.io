class Bar {
  int index;
  float x, y, w, h;
  float bottomValue, topValue;
  float scaledMin, scaledMax;
  float[] buckets;
  boolean reverse;
  String label;
  Button button;
  color c;
  
  Bar(float x, boolean reverse, float[] ranges, String label, int index) {
    this.index = index;
    this.x = x;
    y = height/2;
    w = 5;
    h = Math.max(height*0.8, height-200);
    bottomValue = reverse ? ranges[1] : ranges[0];
    topValue = reverse ? ranges[0] : ranges[1];
    scaledMin = y - h/2;
    scaledMax = y + h/2;
    buckets = new float[6];
    float step = (scaledMax - scaledMin)/buckets.length;
    for(int i = 0; i < buckets.length; i++) {
      buckets[i] = scaledMin + (i+1)*step;
    }
    this.reverse = reverse;
    this.label = label;
    button = new Button(x,height - height*0.03);
    c = color(#cccccc);
  }
  
  void flip() {
    if (button.isActive()) {
      float temp = bottomValue;
      bottomValue = topValue;
      topValue = temp;
      reverse = !reverse;
      display();
    }
  }
  
  void setColor(color c) {
    this.c = c;
  }
  
  void colorLines() {
    if (mouseX > x-w/2 && mouseX < x+w/2 && mouseY > y-h/2 && mouseY < y+h/2) {
      for(Bar b : bars) {
        b.setColor(#cccccc);
        b.display();
      }
      c = color(black);
      display();
      for(DataPoint d : data) {
        d.updateColor(buckets, index, reverse);
      }
    }
  }
  
  void display() {
    noStroke();
    fill(c);
    rectMode(CENTER);
    rect(x, y, w, h);
    fill(black);
    textAlign(CENTER, CENTER);
    int lh = 2;
    if(textWidth(label) > width*0.1) {
      lh = (int) Math.ceil(textWidth(label)/(width*0.1));
    }
    //ellipse(x, width*0.03, width*0.15, lh*textAscent());
    text(label, x, width*0.03, width*0.15, lh*textAscent());
    text(String.format("%.01f", topValue), x, height*0.075);
    text(String.format("%.01f", bottomValue), x, height-height*0.075);
    button.display();
  }
}