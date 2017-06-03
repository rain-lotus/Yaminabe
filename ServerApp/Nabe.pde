class Nabe {
  int hantei;
  int player = 0;
  int x, y, box_len;

  Nabe() {
    hantei = 0;
  }

  void display(int x_, int y_, int box_len_, int cost_[]) {
    this.x = x_;
    this.y = y_;
    this.box_len = box_len_;

    fill(30);
    rect(this.x, this.y, this.box_len, this.box_len);

    put_in_nabe(hantei, cost_);

    if ( mode < 3 ) {
      if (player != 2 ) fill(30);
      else fill(-1, 0);
    } else if (player == 3) fill(-1, 0);
    else fill(0);     
    rect(this.x, this.y, this.box_len, this.box_len);
  }

  void put_in_nabe(int c_num, int cost_[]) { 
    PImage noseru = gu[10];
    //hanteiの数でマスのなかみを指定
    for (int i = 0; i < cost.length; i++) {
      if (c_num == cost_[i]) {
        noseru = gu[i];
      }
    }
    if (temp != 0 || mode >= 3) image(noseru, this.x, this.y, this.box_len, this.box_len);
    else {
      fill(-1, 0);
      rect(this.x, this.y, this.box_len, this.box_len);
    }
  }
}