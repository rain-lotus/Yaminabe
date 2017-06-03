class Point {
  //鍋全体のカオス度
  int SAN(int[][] point) {
    int sum = 0;
    for (int i = 0; i < point[0].length; i++) {
      for (int j = 0; j < point.length; j++) {
        sum += point[i][j];
      }
    }
    return sum;
  }
  
  int allcost(int yourcost){
    int sum = 0;
    for(int i = 0; i < box_num; i++){
      for(int j = 0; j < box_num; j++){
        if(nabe[i][j].player == 2) sum += abs(nabe[i][j].hantei);
      }
    }
    return yourcost - sum;    
  }
  

  int open() {
    int sum = 0;
    for (int i = 0; i < box_num; i++) {
      for (int j = 0; j < box_num; j++) {
        sum += nabe[i][j].player;
      }
    }
    return sum;
  }
}