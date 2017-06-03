class Mode {
  int sa = 0;
  String title = "";
  String player;

  Mode(int mode) {
    if (mode == 1) mode1();
    if (mode == 2) mode2();
    if (mode >= 3) mode3();
  }

  void mode1() {
    sa = 100;
    title = "配置モード";
    guzai();

    fill(0);
    textSize(50);
    text(point.allcost(your_cost), 530, 505);
  }

  void guzai() {
    for (int i = 0; i < 5; i++) {
      for (int j =0; j < 2; j++) {
        if (mouseX > 38+i*110 && mouseX < 38+i*110+80 && mouseY > height-250+34+j*110 && mouseY < height-250+34+j*110+80) {
          if (mousePressed) {
            temp = cost[i+5*j];
          }
        }
        strokeWeight(2);
        fill(-1, 0);
        rect(38+i*110, height-250+34+j*110, 80, 80);
      }
    }
    strokeWeight(1);
    mousePressed = false;
  }

  void mode2() {
    sa = 0;
    title = "待機中…";
  }

  void mode3() {
    sa = 0;
    title = "闇鍋モード";
    temp = 0;
    text(HP, 155, 700);
    text(MP, 445, 700);
    if (turn%2 == 1) player = "あなたのターンです";
    else player = "相手のターンです";
    textSize(30);
    text(player, width/2, 150);
    //諸々のポイント計算
    int [][] hantei = new int [nabe[0].length][nabe.length];
    for (int i = 0; i < hantei[0].length; i++) {
      for (int j = 0; j < hantei.length; j++) {
        hantei[i][j] = nabe[i][j].hantei;
      }
    }
    fill(0);
    textSize(20);
    text("鍋全体のひえー度＝"+point.SAN(hantei), width/2, 100);
  }

  void ending(int mode_) {
    String txt = "";
    if (mode_ == 4) txt = "勝敗はつきませでした";
    else if (mode_ == 5) txt = "満足しました\nあなたの勝ちです";
    else if (mode_ == 6) txt = "満足できませんでした\nあなたの負けです";
    else if (mode_ == 7) txt = "相手の肉を喰らいました\nあなたの勝ちです";
    else if (mode_ == 8) txt = "あなたの心は闇に染まりました\nあなたの負けです";
    else if (mode_ == 9) txt = "相手に肉を取られました\nあなたの負けです";
    else if (mode_ == 10) txt = "相手の心は闇に染まりました\nあなたの勝ちです";

    fill(-1, 50);
    rect(0, 0, width, height);
    fill(0);
    textSize(40);
    text(txt, width/2, height/2);
  }
}