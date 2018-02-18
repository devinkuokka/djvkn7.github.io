class DataPoint {
  String name;
  float[] y;
  float barHeight;
  color[] redGradient = {color(#fcae91), color(#fb6a4a), color(#de2d26)}; //lightest -> strongest
  color[] blueGradient = {color(#bdd7e7), color(#6baed6), color(#3182bd)}; //lightest-> strongest
  color c;
  color prev;
  
  DataPoint(String name, float[] ys) {
    this.name = name;
    this.y = ys;
    barHeight = Math.max(height*0.8, 70);
    c = blueGradient[2];
    prev = c;
  }
  
  void drawLines() {
    stroke(c);
    for(int i = 0; i < y.length-1; i++){
      float y1 = getScaledY(i);
      float y2 = getScaledY(i+1);
      line(bars[i].x, y1, bars[i+1].x, y2);
    }
    noStroke();
  }
  
  String hoverInfo() {
    for(int i = 0; i < y.length-1; i++){
      if (mouseX >= bars[i].x && mouseX <= bars[i+1].x) {
        float y1 = getScaledY(i);
        float y2 = getScaledY(i+1);
        float m = (y2-y1)/(bars[i+1].x - bars[i].x);
        float b = y1 - m*bars[i].x;
        if (m*mouseX + b <= mouseY + 2 && m*mouseX + b >= mouseY - 2) {
          return toString();
        }
      }
    }
    return null;
  }
  
  boolean inBoundingBox() {
    float[] bb = boundingBox;
    for (int s = 0; s <= 2; s+=2) {
      for(int i = 0; i < bars.length-1; i++) {
        if (bars[i].x < bb[s] && bb[s] < bars[i+1].x) {
          float y1 = getScaledY(i);
          float y2 = getScaledY(i+1);
          float m = (y2-y1)/(bars[i+1].x - bars[i].x);
          float b = y1 - m*bars[i].x;
          float maxx = Math.max(bb[0], bb[2]);
          float minx = Math.min(bb[0], bb[2]);
          if (Math.min(bb[1], bb[3]) < m*bb[s]+b && m*bb[s]+b < Math.max(bb[1], bb[3])) {
            return true;
          } else if ((bb[1]-b)/m > Math.max(minx, bars[i].x) && (bb[1]-b)/m < Math.min(maxx, bars[i+1].x)) {
          return true;
          } else if ((bb[3]-b)/m > Math.max(minx, bars[i].x) && (bb[3]-b)/m < Math.min(maxx, bars[i+1].x)) {
            return true;
          }
        }
      }
    }
    return false;
  }
  
  void fade(boolean yes) {
    strokeWeight(1);
    if (yes) {
      prev = c;
      c = color(#cccccc);
    } else {
      c = prev;
    }
  }
  
  void highlight() {
    strokeWeight(5);
    c = prev;
  }
  
  float getScaledY(int index) {
    return map(y[index], bars[index].topValue, bars[index].bottomValue, bars[index].scaledMin, bars[index].scaledMax);
  }
  
  void updateColor(float[] buckets, int barIndex, boolean reverse) {
    float scaledY = getScaledY(barIndex);
    for(int i = 0; i < buckets.length; i++) {
      if (scaledY <= buckets[i]) {
        if (i < 3) {
          if (!reverse) {
            c = redGradient[2-i];
          } else {
            c = blueGradient[2-i];
          }
        } else {
          if (!reverse) {
            c = blueGradient[i-3];
          } else {
            c = redGradient[i-3];
          }
        }
        break;
      }
    }
    prev = c;
    drawLines();
  }
  
  void display() {
    drawLines();
  }
  
  String toString() {
    String s = name + ": (";
    for (float i : y){
      s += Math.round(i*10)/10.0 + ", ";
    }
    return s.substring(0,s.length()-2) + ")";
  }
}