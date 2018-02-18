class Tooltip {
  Set<String> text;
  float h, w;
  
  Tooltip (Set<String> info) {
    text = info;
    float maxLength = 0;
    for (String t : info) {
      if (textWidth(t) > maxLength) {
        maxLength = textWidth(t);
      }
    }
    h = (textAscent()+5)*info.size();
    w = maxLength;
  }
  
  void downLeft() {
    rect(mouseX-w-15, mouseY-15, w+15, h+15, 7);
    fill(3,43,47);
    int i = 0;
    for(String t : text){
      text(t, mouseX-w-5, mouseY+(i*(textAscent()+5)));
      i++;
    }
  }
  
  void upLeft() {
    rect(mouseX-w-15, mouseY-h-15, w+15, h+15, 7);
    fill(black);
    int i = 0;
    for(String t : text){
      text(t, mouseX-w-5, mouseY-h+(i*(textAscent()+5)));
      i++;
    }
  }
  
  void downRight() {
    rect(mouseX+15, mouseY-15, w+15, h+15, 7);
    fill(black);
    int i = 0;
    for(String t : text){
      text(t, mouseX+20, mouseY+(i*(textAscent()+5)));
      i++;
    }
  }
  
  void upRight() {
    rect(mouseX+15, mouseY-h-15, w+15, h+15, 7);
    fill(black);
    int i = 0;
    for(String t : text){
      text(t, mouseX+20, mouseY-h+(i*(textAscent()+5)));
      i++;
    }
  }
  
  //direction where there is most room
  
  void display() {
    noStroke();
    fill(#cccccc); // light gray
    rectMode(CORNER);
    textAlign(LEFT,CENTER);
    if(mouseX-w-15 <= 0 && mouseY-h-15 <= 0) {
      downRight();
    } else if (mouseX-w-15 <= 0) {
      upRight();
    } else if(mouseX+w+15 > width && mouseY-h-15<=0) {
      downLeft();
    } else {
      upLeft();
    }
  }
}