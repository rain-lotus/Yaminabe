//Client.psd
//サーバーとクライアントを使ったゲーム
//2016_11_28

/*遊び方
 
 1.配置モード
 お互いに持ちコスト50の内で鍋の中身をおきます。
 配置が終わったらサーバーの方からエンターボタンを押してください。
 クライアントの人がエンターを押したら次に進みます。
 
 2.闇鍋モード
 クライアントの人から交互に中身を食べていきます。
 いおた時のコストの分だけMP(まんぞくポイント)が増えます。
 下の段にあった食材は食べるとコストの分だけHP(ひえーポイント)が減ります。
 
 また、コストの+-の合計を鍋全体のひえー度とし、食べるごとにその値がHPがに加算されます。
 つまり、攻撃できる具材を多くおいたらその分常にダメージを受けるようになります。
 
 MPが80を超える、または相手のHPが0になったら勝ちです。
 
 また、相手のおいた肉を食べることができたら強制的に勝ち、
 心の闇を食べてしまったら強制的に負けです。
 
 */

import processing.net.*;
Client myClient = new Client( this, "127.0.0.1", 54321 );
ArrayList list = new ArrayList();

int box_length = 50; //箱の大きさ
int box_num = 6; //箱の数
int box_x;
int box_y; 
int mode = 1;
int temp = 0;
int [] cost = {1, 3, 5, 10, 15, -3, -5, -10, -15, -30};
int HP = 30;
int MP = 0;
int turn = 0;
int your_cost = 50;

Nabe [][] nabe = new Nabe [box_num][box_num];//鍋の中身
int [][] player = new int [box_num][box_num];
Point point = new Point();
Mode mode_change; 
PFont font;
String recvStr;
PImage back1, back2;
PImage [] gu = new PImage [11];

void setup() {
  size(600, 800);
  for (int i = 0; i < box_num; i++) {
    for (int j = 0; j < box_num; j++) {
      nabe[i][j] = new Nabe();
    }
  }
  font = createFont("メイリオ", 20);
  textFont(font);
  textAlign(CENTER);
  colorMode(HSB, 100);
  back1 = loadImage("背景1.png");
  back2 = loadImage("背景2.png");
  for (int i = 0; i < gu.length; i++) {
    gu[i] = loadImage("gu"+i+".png");
  }
}

void draw() {
  if (mode < 3) image(back1, 0, 0);
  else image(back2, 0, 0);
  mode_change = new Mode(mode);
  box_x = int(width/2-box_length*box_num/2);
  box_y = int(height/2-box_length*box_num/2)-mode_change.sa;

  //データ受取り
  if ( myClient.available() > 0 ) {
    recvStr = myClient.readString();
    String [] data = split(recvStr, '+');
    String [] data1 = split(data[0], '/');
    String [] data1_5 = split(data[1], '/');
    String [][]data2 = new String[box_num][box_num];
    for (int i = 0; i < box_num; i++) {
      data2[i] = split(data1[i], ',');
      player[i] = int(split(data1_5[i], ','));
    }
    //貰ったデータを180度回して反対向きにする。
    for (int i = 0; i < box_num; i++) {
      for (int j = 0; j < box_num; j++) {
        nabe[i][j].hantei = int(data2[box_num-1-i][box_num-1-j]);
        nabe[i][j].player = player[box_num-1-i][box_num-1-j];
      }
    }
    mode = int(data[2]);
    turn = int(data[3]);
  }

  for (int i = 0; i < box_num; i++) {
    for (int j = 0; j < box_num; j++) {
      nabe[i][j].display(box_x+box_length*i, box_y+box_length*j, box_length, cost);
    }
  }

  fill(0);
  textSize(50);
  text(mode_change.title, width/2, 70);

  if (mode > 3) mode_change.ending(mode);
}

void data_trans() {
  String data = "";
  String data2 = "";
  //データをクライアントに送信
  for (int i = 0; i < box_num; i++) {
    for (int j = 0; j < box_num; j++) {
      data += nabe[i][j].hantei+",";
      data2 += nabe[i][j].player+",";
    }
    data+="/";
    data2+="/";
  }
  //配置、おいた人、フラグ、ターン数
  myClient.write(data+"+"+data2+"+"+mode+"+"+turn);
}

void mousePressed() {
  //クリックしたら色を変更してデータをクライアントに送信
  for (int i = 0; i < box_num; i++) {
    for (int j = 0; j < box_num; j++) {
      if (mouseX > box_x+i*box_length && mouseX < box_x+(i+1)*box_length) {
        if (mouseY > box_y+j*box_length && mouseY < box_y+(j+1)*box_length) {
          if (mode < 3 && (abs(nabe[i][j].hantei) < point.allcost(your_cost) || temp == nabe[i][j].hantei)) {
            //メニューで選んだものをマスに代入。プレイヤーも指定。
            if (nabe[i][j].hantei == 0 || nabe[i][j].hantei != temp) nabe[i][j].hantei=temp;
            else nabe[i][j].hantei = 0;
            nabe[i][j].player = 1;
          } else if (mode == 3 && turn%2 == 0 && nabe[i][j].player!=3) {
            //HPとMPを計算して中身を開示。
            if (nabe[i][j].hantei < 0) HP+=nabe[i][j].hantei;
            MP += abs(nabe[i][j].hantei);
            int [][] hantei = new int [nabe[0].length][nabe.length];
            for (int u = 0; u < hantei[0].length; u++) {
              for (int v = 0; v < hantei.length; v++) {
                hantei[u][v] = nabe[u][v].hantei;
              }
            }
            HP += point.SAN(hantei);
            if (nabe[i][j].hantei == cost[9]) mode = 10;
            else if (nabe[i][j].hantei == cost[4] && nabe[i][j].player == 2) mode = 9;
            nabe[i][j].player = 3;
            turn++;
          }
        }
      }
    }
  }
  if (mode == 3)
    if (point.open() >= 3*box_num*box_num-1) mode = 4;
  if (HP < 0) mode = 5;
  if (MP > 50) mode = 6;
  data_trans();
}

void keyPressed() {
  if (keyCode == ENTER && mode == 2) {
    mode = 3;
    data_trans();
  }
}

void stop() {
  myClient.stop();
}