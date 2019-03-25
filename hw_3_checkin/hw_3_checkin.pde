import java.util.Timer;

float size_m = 0.5;
int scale = 4;
int cols;
int rows;
Position [][] world;
Mover m;
int playerSpot;
ArrayList<Position> openSet;
ArrayList<Position> exploredSet;
ArrayList<Position> solution;

boolean done;
Position start;
Position end;
void setup(){
  size(400,400);
  frameRate(60);
  openSet = new ArrayList<Position>();
  exploredSet = new ArrayList<Position>();
  solution = new ArrayList<Position>();
  cols = width/scale;
  rows = height/scale;
  world = new Position[cols][rows];
  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
      world[i][j] = new Position(i,j);      
    }
  }
  
  
  
  start = world[0][rows-1];
  end = world[cols-1][0];
  end.wall = false;
  start.wall = false;
  
  openSet.add(start);
  done = false;
  playerSpot = 0;
  m = new Mover();

      
}

void draw(){
  background(255);
  Position currentPos = start;
  
  if(!done){ 
    for(int i = 0; i < cols; i++){
      for(int j = 0; j < rows; j++){
        world[i][j].display(color(255,255,255));
      }
    }
    for(int i = 0; i < exploredSet.size();i++){
      exploredSet.get(i).display(color(0,255,0));
    }
    for(int n = 0; n < 10; n++){
      if(openSet.size() > 0){
        int curIndex = 0;
        for(int i = 0; i < openSet.size(); i++){
          if(openSet.get(i).f_score < openSet.get(curIndex).f_score){
            curIndex = i;
          }
        }
        currentPos = openSet.get(curIndex);
        currentPos.display(color(0,0,0));
        
        if(currentPos.loc.x == end.loc.x && currentPos.loc.y == end.loc.y){
          println("done");
          done = true;
          solution = reconstructPath();
          playerSpot = solution.size();
          //noLoop();
        }
        openSet.remove(curIndex);
        exploredSet.add(currentPos);
        
        int x = (int)currentPos.loc.x;
        int y = (int)currentPos.loc.y;
        
        for(int i = (x - 1); i <= x + 1; i++){
          for(int j = (y - 1); j <= y + 1; j++){
            if((i >= 0 && j >= 0) && (i < cols && j < rows)){
              
              if(!exploredSet.contains(world[i][j]) && !world[i][j].wall){
                float tentative_gScore = currentPos.g_score + 1;
                if(openSet.contains(world[i][j])){
                  if(tentative_gScore < world[i][j].g_score){
                    world[i][j].g_score = tentative_gScore;
                  }             
                }
                else{
                  world[i][j].g_score = tentative_gScore;
                  openSet.add(world[i][j]);
   
                  
                }
                
                world[i][j].cameFrom = currentPos;
                world[i][j].h_score = costEstimate(world[i][j],end);
                world[i][j].f_score = world[i][j].g_score + world[i][j].h_score;
                
              }
            }
          }
        }  
      }
    }
  }
  else{
    playerSpot--;
   
    if(playerSpot <= 0){
      playerSpot = solution.size() - 1;
    }
    frameRate(10);
    println("done");
    for(int i = 0; i < cols; i++){
      for(int j = 0; j < rows; j++){
        if(world[i][j].wall){
          world[i][j].display(color(255,0,0));
        }
      }
    }
    Position p1 = solution.get(playerSpot);
    Position p2 = solution.get(playerSpot-1);

    
   // m.display();
    //for(float i = 0; i < 10; i++){
    //  m.pos.x = lerp(p1.loc.x * scale,p2.loc.x * scale,i/10);
    //  m.pos.y = lerp(p1.loc.y * scale,p2.loc.y * scale,i/10);
      
    //  for(int n = 0; n < cols; n++){
    //    for(int j = 0; j < rows; j++){
    //      if(!world[n][j].wall){
    //        world[n][j].display(color(255,255,255));
    //      }
    //    }
    //  }  
    //  m.display();
    //}
      
    
    solution.get(playerSpot).display(color(0,0,0));
  }



  
}

ArrayList reconstructPath(){
  ArrayList<Position> path = new ArrayList<Position>();
  
  Position tmp = end;
  
  path.add(tmp);
  while(tmp != start){
    path.add(tmp.cameFrom); 
    tmp = tmp.cameFrom;
  }
  //for(int i = 0; i < path.size(); i++){  
  //  fill(127,123,0);
  //  rect(path.get(i).loc.x * scale,path.get(i).loc.y * scale,scale,scale);   
  //}
  return path;
}

void keyPressed(){
  setup();
}

float costEstimate(Position p1, Position p2){
  float v1 = (p2.loc.x - p1.loc.x) * (p2.loc.x - p1.loc.x);
  float v2 = (p2.loc.y - p1.loc.y) * (p2.loc.y - p1.loc.y);
  
  return (float)Math.sqrt(v1 + v2);
}
class Position{
  float f_score;
  float g_score;
  float h_score;
  PVector loc;
  boolean wall = false;
  Position cameFrom;
  

    
  Position(int i,int j){
    
    if(i >= 20 && i < 80 && j >= 20 && j < 80){
      wall = true;
    }

 

    cameFrom = start;
    f_score = 0;
    g_score = 0;
    h_score = 0;
    loc = new PVector(i,j);
  }
  
  void display(color c){
    fill(c);
    if(wall){
      fill(255,0,0);
    }
    noStroke();
    rect(loc.x * scale,loc.y * scale,scale,scale);
  }
    
}


class Mover{
  PVector pos;

  Mover(){
    pos = new PVector(start.loc.x,start.loc.y);
  }
  
  void display(){
    fill(0);
    noStroke();
    rect(pos.x,pos.y,20,20);
  }
}
