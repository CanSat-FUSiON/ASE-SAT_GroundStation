import processing.net.*;  // Processingのネットワークライブラリをインポート

Server server;  // サーバーオブジェクトを定義
int port = 10002;  // ポート番号

PVector x_unit = new PVector(1,0,0);
PVector y_unit = new PVector(0,1,0);
PVector z_unit = new PVector(0,0,-1);

float roll=0, pitch=0, yaw=0;

PImage[] textures = new PImage[6];

void setup() {
  // サーバーを指定ポートで開始
  server = new Server(this, port);
  println("Server started on port " + port);
  size(800, 800, P3D);
  textures[0] = loadImage("P-Xsc.png");
  textures[1] = loadImage("N-Xsc.png");
  textures[2] = loadImage("P-Ysc.png");
  textures[3] = loadImage("N-Ysc.png");
  textures[4] = loadImage("P-Zsc.png");
  textures[5] = loadImage("N-Zsc.png");
}

void draw() {
  float p = 1.5;
  background(200);
  
  fill(0);  // 文字の塗りつぶし色
  textSize(50);
  text("ASE-Sat. 3D-Attitude Viewer", 10, 80);
  textSize(30);
  text("Yaw : "  + (int(yaw) )   + "[deg]", 10, 80+30);
  text("Pitch: " + (int(pitch) ) + "[deg]", 10, 80+60);
  text("Roll : " + (int(roll) )  + "[deg]", 10, 80+90);
  
  // サーバーがクライアントからのデータを受信した場合に呼ばれる
  rx();
  //roll = roll + 1;
  
  // カメラ位置を設定
  translate(width / 2, height*3 / 5);
  
         //translate(400, 400);
        rotateX(radians(-90));
        rotateZ(radians(-90));
        rotateY(radians(-30));
        rotateZ(radians(-30));
  
  float k = p*200;
  strokeWeight(3);
  arrow(0, 0, 0, k * x_unit.x, k * x_unit.y, k * x_unit.z, k, 0, 0);
  arrow(0, 0, 0, k * y_unit.x, k * y_unit.y, k * y_unit.z, 0, k, 0);
  arrow(0, 0, 0, k * z_unit.x, k * z_unit.y, k * z_unit.z, 0, 0, k);
  
  // 回転を適用
  rotateX(radians(yaw));
  rotateY(radians(pitch));
  rotateZ(radians(roll));
  
  k = p*150;
  strokeWeight(5);
  arrow(0, 0, 0, k * x_unit.x, k * x_unit.y, k * x_unit.z, k, 0, 0);
  strokeWeight(5);
  arrow(0, 0, 0, k * y_unit.x, k * y_unit.y, k * y_unit.z, 0, k, 0);
  strokeWeight(5);
  arrow(0, 0, 0, k * z_unit.x, k * z_unit.y, k * z_unit.z, 0, 0, k);
  
  fill(255, 255, 255);
  stroke(0);
  strokeWeight(3);
  
  // 3Dボックスを描画
 //box(p*150);
 object(p*100);

}

void rx() {
  Client client = server.available();
  if (client != null) {
    String data = client.readString();  // クライアントからのデータを文字列として読み込む
    if (data != null) {
      // JSONデータをパースしてオイラー角を取得
      JSONObject jsonData = parseJSONObject(data);
      if (jsonData != null) {
        JSONObject eulerAngles = jsonData.getJSONObject("euler_angle_deg");
        if (eulerAngles != null) {
          roll = eulerAngles.getFloat("roll");
          pitch = eulerAngles.getFloat("pitch");
          yaw = eulerAngles.getFloat("yaw");
          println("Received angles - Roll: " + roll + ", Pitch: " + pitch + ", Yaw: " + yaw);
        }
      }
    }
  }
}

void object(float _size){
  // 各面に対応するテクスチャーを適用して立方体を描画
  rotateX(radians(90));
  
  beginShape(QUADS);
  // Front face
  texture(textures[0]);
  vertex(-_size, -_size, _size, 0, 0);
  vertex(_size, -_size, _size, textures[0].width, 0);
  vertex(_size, _size, _size, textures[0].width, textures[0].height);
  vertex(-_size, _size, _size, 0, textures[0].height);
  endShape();
  
  // Back face
  beginShape(QUADS);
  texture(textures[1]);
  vertex(_size, -_size, -_size, 0, 0);
  vertex(-_size, -_size, -_size, textures[1].width, 0);
  vertex(-_size, _size, -_size, textures[1].width, textures[1].height);
  vertex(_size, _size, -_size, 0, textures[1].height);
  endShape();
  
  // Left face
  beginShape(QUADS);
  texture(textures[2]);
  vertex(-_size, -_size, -_size, 0, 0);
  vertex(-_size, -_size, _size, textures[2].width, 0);
  vertex(-_size, _size, _size, textures[2].width, textures[2].height);
  vertex(-_size, _size, -_size, 0, textures[2].height);
  endShape();
  
  // Right face
  beginShape(QUADS);
  texture(textures[3]);
  vertex(_size, -_size, _size, 0, 0);
  vertex(_size, -_size, -_size, textures[3].width, 0);
  vertex(_size, _size, -_size, textures[3].width, textures[3].height);
  vertex(_size, _size, _size, 0, textures[3].height);
  endShape();
  
  // Top face
  beginShape(QUADS);
  texture(textures[4]);
  vertex(-_size, -_size, -_size, 0, 0);
  vertex(_size, -_size, -_size, textures[4].width, 0);
  vertex(_size, -_size, _size, textures[4].width, textures[4].height);
  vertex(-_size, -_size, _size, 0, textures[4].height);
  endShape();
  
  // Bottom face
  beginShape(QUADS);
  texture(textures[5]);
  vertex(-_size, _size, _size, 0, 0);
  vertex(_size, _size, _size, textures[5].width, 0);
  vertex(_size, _size, -_size, textures[5].width, textures[5].height);
  vertex(-_size, _size, -_size, 0, textures[5].height);
  endShape();
}
