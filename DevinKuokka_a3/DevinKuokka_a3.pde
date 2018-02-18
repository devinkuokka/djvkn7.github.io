import java.util.*;

DataPoint[] data;
String title;
String[] fields;
Bar[] bars;
float[][] ranges;

Tooltip activeTip;
Set<String> info;

color black = color(#252525);
int oldWidth, oldHeight;

boolean dragging;
float[] boundingBox;
boolean showBoundingBox;

void setup() {
  size(700,600);
  surface.setResizable(true);
  oldWidth = width;
  oldHeight = height;
  data = loadData("drinks.csv");
  bars = new Bar[fields.length];
  createBars();
  info = new HashSet<String>();
  dragging = false;
  showBoundingBox = false;
  boundingBox = new float[4];
}

void draw() {
  background(255,255,255);
  if (oldWidth != width || oldHeight != height) {
    createBars();
    oldWidth = width;
    oldHeight = height;
  }
  if(dragging) {
    setBoundingBox();
  }
  if(showBoundingBox) {
    drawBoundingBox();
  }
  for (DataPoint d : data) {
    if (!dragging || !showBoundingBox) {
      d.fade(false);
    }
    String s = d.hoverInfo();
    if (s != null) {
      info.add(d.hoverInfo());
    }
  }
  for (DataPoint d : data) {
    if (!dragging && showBoundingBox && !d.inBoundingBox()) {
      d.fade(true);
    } else if (!dragging && info.size() > 0 && !info.contains(d.toString()) && !showBoundingBox) {
      d.fade(true);
    }
    d.display();
  }
  for(Bar b : bars) {
    b.display();
  }
  if (!dragging && info.size() > 0) {
    for(DataPoint d : data) {
      if(info.contains(d.toString())) {
        d.highlight();
        d.display();
      }
    }
    activeTip = new Tooltip(info);
    activeTip.display();
  }
  info.clear();
}

void mouseDragged() {
  dragging = true;
}

void mouseReleased() {
  dragging = false;
  showBoundingBox = true;
}

void mousePressed() {
  showBoundingBox = false;
  boundingBox[0] = mouseX;
  boundingBox[1] = mouseY;
}

void mouseClicked() {
  showBoundingBox = false;
  for(Bar b : bars) {
    b.flip();
    b.colorLines();
  }
}

void setBoundingBox() {
  boundingBox[2] = mouseX;
  boundingBox[3] = mouseY;
  strokeWeight(1);
  stroke(#cccccc);
  fill(#f7f7f7);
  rectMode(CORNERS);
  rect(boundingBox[0], boundingBox[1], boundingBox[2], boundingBox[3]);
  noStroke();
}

void drawBoundingBox() {
  strokeWeight(1);
  stroke(#cccccc);
  fill(#f7f7f7);
  rectMode(CORNERS);
  rect(boundingBox[0], boundingBox[1], boundingBox[2], boundingBox[3]);
  noStroke();
}

void createBars() {
  float xstep = width*0.8/(fields.length-1);
  for(int i = 0; i < fields.length; i++) {
    boolean reverse = bars[i] == null ? false : bars[i].reverse;
    bars[i] = new Bar(width*0.1 + i*xstep, reverse, ranges[i], fields[i], i); 
  }
}

DataPoint[] loadData(String path) {
  String[] lines = loadStrings(path);
  String[] firstLine = split(lines[0], ",");
  title = firstLine[0].substring(1); // FILM
  fields = new String[firstLine.length-1];
  for(int i = 1; i < firstLine.length; i++){
    fields[i-1] = firstLine[i];
  }
  ranges = new float[fields.length][2];
  boolean isStart = true;
  DataPoint[] d = new DataPoint[lines.length-1];
  for (int r = 1; r < lines.length; r++) {
    String[] row = split(lines[r], ",");
    float[] ys = new float[row.length-1];
    for (int c = 1; c < row.length; c++){
      float value = (float) parseFloat(row[c]);
      if (isStart) {
        ranges[c-1][0] = value;
        ranges[c-1][1] = value;
      } else {
        ranges[c-1][0] = Math.min(ranges[c-1][0], value);
        ranges[c-1][1] = Math.max(ranges[c-1][1], value);
      }
      ys[c-1] = value; 
    }
    d[r-1] = new DataPoint(row[0], ys);
    isStart = false;
  }
  return d;
}