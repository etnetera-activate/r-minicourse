if(!require("TurtleGraphics")) install.packages("TurtleGraphics")
library("TurtleGraphics")

#draw logo of Etnetera using turtlegraphics

#parameters of the logo 
color = "#009de0"
lwd <- 65 #witdh 
r1 <- 2.1 #bottom half circle
r2 <- 1.5 #upper 270degree arc
l1 <- 110 #first segment (left-down)
l2 <- 190 #middle segment (right-up)
l3 <- 180 #final segment (right -down)

turtle_wait<-function(interval = 100){
  turtle_show()
  Sys.sleep(interval/1000)
  turtle_hide()
}

#drawing the logo
turtle_init(width = 800, height = 800)
turtle_lwd(lwd);
turtle_col(color);

turtle_do({
  turtle_setpos(y=250, x=600)
  turtle_turn(135, direction = "left")
  turtle_move(l1)
  
  turtle_wait();
  
  for(i in 1:180) {
    turtle_forward(dist=r1);
    turtle_right(angle=1);
  }
  
  turtle_move(l2)
  
  turtle_wait();
  
  for(i in 1:270) {
    turtle_forward(dist=r2);
    turtle_left(angle=1);
    
  }
  turtle_wait();
  
  turtle_move(l3)
  
  turtle_wait();
  
  turtle_left(180);

})
