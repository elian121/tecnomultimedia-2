import ddf.minim.*;
import fisica.*;
import processing.event.MouseEvent;
int PUERTO_OSC = 12345;
Receptor receptor;
Minim minim;
AudioPlayer inicio;
AudioPlayer juego;
AudioPlayer ganaste;
AudioPlayer perdiste;
AudioPlayer drop;
AudioPlayer correcto;
AudioPlayer incorrecto;
int vidas = 3;
int vidasPerdidas = 0;
PImage felicidades;
PImage gameover;
PImage iniciar;
PImage botoninicio;
PImage background;
PImage obstaculo;
PImage ingredientes;
PImage vida;
PImage corazon;
PImage strike;
PImage tomate;
PImage hongo;
PImage peperoni;
PImage quesoPodrido;
PImage tomatePodrido;
PImage pescado;
PImage hongoPodrido;
PImage peperoniPodrido;
float sueloY;
PImage cursor;
PImage cursor1;
PImage cursor2;
PImage reinicio;
PImage check;
PImage peperoniEnPizza;
PImage hongoEnPizza;
PImage tomateEnPizza;
FWorld mundo;
FCircle bola;
FMouseJoint cadena;
ArrayList<FCircle> bolas;
float radioBolas = 60;
int tiempoUltimaBola = 0;
int intervaloBolas = 1000;
float rangoXMin, rangoXMax;
float ovaloRadioX = 60;
float ovaloRadioY = 40;
boolean victoria = false;
boolean pantallaInicial = true;
boolean gameOver = false;
int tiempoEnBoton = 0;
boolean iniciarJuego = false;
boolean contadorActivo = false;
boolean mouseSobreBotonInicio = false;
int tiempoRequerido = 180;
boolean reiniciarJuego = false;
int botonInicioX;
int botonInicioY;
int botonInicioAncho = 200;
int botonInicioAlto = 50;
int botonReiniciarX;
int botonReiniciarY;
int botonReiniciarAncho = 200;
int botonReiniciarAlto = 50;
int opacidadTomate = 0;
int opacidadHongo = 0;
int opacidadPeperoni = 0;
int opacidadPizza1 = 255;
int opacidadPizza2 = 0;
int opacidadPizza3 = 0;
FBox[] vidasCuadrados = new FBox[3];
float blobX =0; 
void setup() {
  setupOSC(PUERTO_OSC);
  receptor = new Receptor();
  minim = new Minim(this);
  inicio = minim.loadFile("inicio.mp3");
  juego = minim.loadFile("juego.mp3");
  ganaste = minim.loadFile("ganaste.mp3");
  perdiste = minim.loadFile("perdiste.mp3");
  drop = minim.loadFile("drop.mp3");
  correcto = minim.loadFile("correcto.mp3");
  incorrecto = minim.loadFile("incorrecto.mp3");
  felicidades = loadImage("felicidades.jpg");
  gameover = loadImage("gameover.jpg");
  iniciar = loadImage("iniciar.jpg");
  botoninicio = loadImage("botoninicio.png");
  background = loadImage("background.jpg");
  obstaculo = loadImage("obstaculo.png");
  ingredientes = loadImage("ingredientes.jpg");
  vida = loadImage("vidas.jpg");
  corazon = loadImage("corazon.png");
  strike = loadImage("strike.png");
  tomate = loadImage("tomate.png");
  hongo = loadImage("hongo.png");
  peperoni = loadImage("peperoni.png");
  quesoPodrido = loadImage("queso_podrido.png");
  tomatePodrido = loadImage("tomate_podrido.png");
  pescado = loadImage("pescado.png");
  hongoPodrido = loadImage("hongo_podrido.png");
  peperoniPodrido = loadImage("peperoni_podrido.png");
  cursor = loadImage("cursor.png");
  cursor1 = loadImage("cursor1.png");
  cursor2 = loadImage("cursor2.png");
  reinicio = loadImage("reinicio.png");
  check = loadImage("check.png");
  peperoniEnPizza = loadImage("peperoni_en_pizza.png");
  hongoEnPizza = loadImage("hongo_en_pizza.png");
  tomateEnPizza = loadImage("tomate_en_pizza.png");
  size(1200, 600);
  Fisica.init(this);
  sueloY = height - 10;
  mundo = new FWorld();
  mundo.setEdges();
  bolas = new ArrayList<FCircle>();
  bola = new FCircle(radioBolas);
  bola.setPosition(width / 2, height / 4);
  bola.setName("mouse");
  mundo.add(bola);
   pantallaInicial = true;
  gameOver = false;
  iniciarJuego = false;
  reiniciarJuego = false;
  cadena = new FMouseJoint(bola, width / 2, height / 4);
  cadena.setFrequency(400000);
  mundo.add(cadena);
  rangoXMin = 50;
  rangoXMax = width - 50;
  botonInicioX = width / 2 - botonInicioAncho / 2 ;
  botonInicioY = height -100 - botonInicioAlto / 2;

  botonReiniciarX = width / 2 - botonReiniciarAncho / 2;
  botonReiniciarY = height -100 + botonReiniciarAlto / 2;

  FBox fbox1 = new FBox(150, 600);
  fbox1.setPosition(75, 300);
  fbox1.setStatic(true);
  mundo.add(fbox1);

  FBox fbox2 = new FBox(150, 600);
  fbox2.setPosition(1125, 300);
  fbox2.setStatic(true);
  mundo.add(fbox2);
  
  float vidaSize = 50;
  float vidaSpacing = 10; 

  for (int i = 0; i < vidasCuadrados.length; i++) {
  vidasCuadrados[i] = new FBox(vidaSize, vidaSize); 
  float vidaX = 75; 
  float vidaY = height/2 - (i + 1) * (vidaSize + vidaSpacing); 
  vidasCuadrados[i].setPosition(vidaX, vidaY);
  vidasCuadrados[i].setStatic(true);
  mundo.add(vidasCuadrados[i]);
}
  crearFilasTriangulos(150, new float[] {471, 773});
  crearFilasTriangulos(300, new float[] {360, 623, 885});
  crearFilasTriangulos(450, new float[] {471, 773});
  crearFilasTriangulos(150, new float[] {471, 773});
  crearFilasTriangulos(300, new float[] {360, 623, 885});
  crearFilasTriangulos(450, new float[] {471, 773});

  crearTriangulosEspecialesIzquierda();
  crearTriangulosEspecialesDerecha();

}

void crearTriangulosEspecialesIzquierda() {
  float lado = 40;
  float xBase = 225; 

  FBox ladoHorizontal1 = new FBox(lado + 50, 5); 
  ladoHorizontal1.setPosition(xBase - (lado / 2 * sqrt(3)), 420 - (lado / 2));
  ladoHorizontal1.setRotation(radians(30));
  ladoHorizontal1.setStatic(true);
  mundo.add(ladoHorizontal1);

  FBox ladoHorizontal2 = new FBox(lado + 50, 5); 
  ladoHorizontal2.setPosition(xBase - (lado / 2 * sqrt(3)), 420 + (lado / 2));
  ladoHorizontal2.setRotation(-radians(30)); 
  ladoHorizontal2.setStatic(true);
  mundo.add(ladoHorizontal2);

  FBox ladoHorizontal3 = new FBox(lado + 50, 5);
  ladoHorizontal3.setPosition(xBase - (lado / 2 * sqrt(3)), 180 - (lado / 2));
  ladoHorizontal3.setRotation(radians(30));
  ladoHorizontal3.setStatic(true);
  mundo.add(ladoHorizontal3);

  FBox ladoHorizontal4 = new FBox(lado + 50, 5);
  ladoHorizontal4.setPosition(xBase - (lado / 2 * sqrt(3)), 180 + (lado / 2)); 
  ladoHorizontal4.setRotation(-radians(30));
  ladoHorizontal4.setStatic(true);
  mundo.add(ladoHorizontal4);
}

void crearTriangulosEspecialesDerecha() {
  float lado = 40;
  float xBase = width - 225;

  FBox ladoHorizontal1 = new FBox(lado + 50, 5);
  ladoHorizontal1.setPosition(xBase + (lado / 2 * sqrt(3)), 420 - (lado / 2));
  ladoHorizontal1.setRotation(-radians(30));
  ladoHorizontal1.setStatic(true);
  mundo.add(ladoHorizontal1);

  FBox ladoHorizontal2 = new FBox(lado + 50, 5);
  ladoHorizontal2.setPosition(xBase + (lado / 2 * sqrt(3)), 420 + (lado / 2));
  ladoHorizontal2.setRotation(radians(30));
  ladoHorizontal2.setStatic(true);
  mundo.add(ladoHorizontal2);

  FBox ladoHorizontal3 = new FBox(lado + 50, 5);
  ladoHorizontal3.setPosition(xBase + (lado / 2 * sqrt(3)), 180 - (lado / 2));
  ladoHorizontal3.setRotation(-radians(30)); 
  ladoHorizontal3.setStatic(true);
  mundo.add(ladoHorizontal3);

  FBox ladoHorizontal4 = new FBox(lado + 50, 5);
  ladoHorizontal4.setPosition(xBase + (lado / 2 * sqrt(3)), 180 + (lado / 2));
  ladoHorizontal4.setRotation(radians(30));
  ladoHorizontal4.setStatic(true);
  mundo.add(ladoHorizontal4);
}
void crearFilasTriangulos(float yPos, float[] xPosArray) {
  float lado = 40;

  for (float xPos : xPosArray) {
    FBox ladoIzquierdo = new FBox(5, lado + 50);
    ladoIzquierdo.setPosition(xPos - (lado / 2) - 1, yPos);
    ladoIzquierdo.setRotation(radians(25));
    ladoIzquierdo.setStatic(true);
    mundo.add(ladoIzquierdo);

    FBox ladoDerecho = new FBox(5, lado + 50);
    ladoDerecho.setPosition(xPos + (lado / 2) + 1, yPos);
    ladoDerecho.setRotation(-radians(25));
    ladoDerecho.setStatic(true);
    mundo.add(ladoDerecho);

    FBox ladoHorizontal = new FBox(lado + 15, 5);
    ladoHorizontal.setPosition(xPos, yPos + (lado / 2 * sqrt(3)) + 2.5);
    ladoHorizontal.setStatic(true);
    mundo.add(ladoHorizontal);
  }
}



void contactStarted(FContact contacto) {
  FBody cuerpo1 = contacto.getBody1();
  FBody cuerpo2 = contacto.getBody2();

  String nombre1 = conseguirNombre(cuerpo1);
  String nombre2 = conseguirNombre(cuerpo2);

  if (nombre1.equals("mouse") && nombre2.startsWith("enemigo")) {
    FCircle bolaEnemiga = (FCircle) (cuerpo2 instanceof FCircle ? cuerpo2 : cuerpo1);

    String colorBola = nombre2.substring(7); // Obtén el color de la bola

    if (bolas.contains(bolaEnemiga)) {
      mundo.remove(bolaEnemiga);
      bolas.remove(bolaEnemiga);

      // Compara el color de la bola y actualiza los contadores
      if (colorBola.equals("Rojo")) {
        bolasAtrapadasRojas++;
      correcto.play();
      correcto.rewind();
      opacidadTomate=255;
      } else if (colorBola.equals("Azul")) {
        bolasAtrapadasAzules++;
      correcto.play();
      correcto.rewind();
      opacidadHongo=255;
      } else if (colorBola.equals("Amarillo")) {
        bolasAtrapadasAmarillas++;
      correcto.play();
      correcto.rewind();
      opacidadPeperoni=255;
      } else {
        restarVida();
      incorrecto.play();
      incorrecto.rewind();
      }

      drop.play();
      drop.rewind();
    }
  }
}
void draw() {
  if (pantallaInicial) {
    pantallaInicio();
     if (mouseX >= botonInicioX && mouseX <= botonInicioX + botonInicioAncho &&
        mouseY >= botonInicioY && mouseY <= botonInicioY + botonInicioAlto) {
      tiempoEnBoton++;
      
      if (tiempoEnBoton >= tiempoRequerido) {
        contadorActivo = true;
      }
      
      if (contadorActivo) {
      }
    } else {
      tiempoEnBoton = 0;
      contadorActivo = false;
    }
    
    if (contadorActivo && tiempoEnBoton >= tiempoRequerido) {
      iniciarJuego = true;
      pantallaInicial = false;
    }
  } else if (gameOver) {
    gameOver();
  } else if (iniciarJuego) {
image(background,0,0);


    if (inicio.isPlaying()) {
      inicio.pause();
      inicio.rewind();
    }
    if (ganaste.isPlaying()) {
      ganaste.pause();
      ganaste.rewind();
    }
    if (perdiste.isPlaying()) {
      perdiste.pause();
      perdiste.rewind();
    }
    
    
          //importaciones de bblobtracker
 
   receptor.actualizar(mensajes); //  
  receptor.dibujarBlobs(width, height);


  // Eventos de entrada y salida
  for (Blob b : receptor.blobs) {
    blobX = b.centerX*width;
    println(blobX);
    if (b.entro) {
      println("--> entro blob: " + b.id);
    }
    if (b.salio) {
      println("<-- salio blob: " + b.id);
    }
  }

  //println("cantidad de blobs: " + receptor.blobs.size());



//hasta aca

    juego.play(); 
    mundo.step();
    mundo.draw();
    image(vida,0,0);
     
  float vidaSize = 50;
  float vidaSpacing = 75;
    float vidaX = 25;
    float vidaY = height / 2 - (vidasCuadrados.length - 1) * (vidaSize + vidaSpacing);

    for (int i = 0; i < vidasCuadrados.length; i++) {
      PImage vidaImage = (i < vidasPerdidas) ? strike : corazon;
      image(vidaImage, vidaX, vidaY);
      vidaY += vidaSize + vidaSpacing;
    }
    
    image(obstaculo, 420, 95);
    image(obstaculo, 720, 95);    
    image(obstaculo, 310, 245);
    image(obstaculo, 570, 245);
    image(obstaculo, 835, 245);
    image(obstaculo, 420, 395);
    image(obstaculo, 720, 395);
     pushMatrix();
    translate(300 + obstaculo.width / 2, 0 + obstaculo.height / 2);
    rotate(radians(90)); 
    image(obstaculo, 83, 102);
    image(obstaculo, 320, 102);
    popMatrix();
     pushMatrix();
    translate(300 + obstaculo.width / 2, 0 + obstaculo.height / 2);
    rotate(radians(-90)); 
    image(obstaculo, -426, 602);
    image(obstaculo, -176, 602);
    popMatrix();
image(ingredientes, 1050, 0);

    push();
tint(255, 0 + bolasAtrapadasRojas * 255);
  image(check,1065, 220, 100, 100);

tint(255, 0 + bolasAtrapadasAzules * 255);
  image(check,1060, 475, 100, 100);


tint(255, 0 + bolasAtrapadasAmarillas * 255); 
  image(check,1085, 350, 100, 100);
pop();
    for (int i = bolas.size() - 1; i >= 0; i--) {
  FCircle bola = bolas.get(i);
  float posY = bola.getY();

  if (posY + radioBolas >= sueloY) {
    mundo.remove(bola);
    bolas.remove(i);
  } else {
    String nombreBola = bola.getName();
    PImage imagenBola = null;

    if (nombreBola.equals("enemigoRojo")) {
      imagenBola = tomate;
    } else if (nombreBola.equals("enemigoAzul")) {
      imagenBola = hongo;
    } else if (nombreBola.equals("enemigoAmarillo")) {
      imagenBola = peperoni;
    } else if (nombreBola.equals("enemigoVerde")) {
      imagenBola = quesoPodrido;
    } else if (nombreBola.equals("enemigoVioleta")) {
      imagenBola = tomatePodrido;
    } else if (nombreBola.equals("enemigoMarron")) {
      imagenBola = pescado;
    } else if (nombreBola.equals("enemigoNaranja")) {
      imagenBola = hongoPodrido;
    } else if (nombreBola.equals("enemigoNegro")) {
      imagenBola = peperoniPodrido;
    }

    if (imagenBola != null) {
      push();
      imageMode(CENTER);
      imagenBola.resize(65,65);
      image(imagenBola, bola.getX(), bola.getY());
      pop();
    }
  }
}


    if (millis() - tiempoUltimaBola >= intervaloBolas) {
  float probabilidad = random(1);
  FCircle circulo;
  
  float nuevoRangoXMin = rangoXMin + 150; 
  float nuevoRangoXMax = rangoXMax - 150;

  float posX = random(nuevoRangoXMin, nuevoRangoXMax);
  noStroke(); 
  if (probabilidad < 0.025) {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoRojo");
     circulo.setStroke(0,0,0,0);
    circulo.setFillColor(color(255, 0, 0,0));
  } else if (probabilidad < 0.05) {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoAzul");
     circulo.setStroke(0,0,0,0);
    circulo.setFillColor(color(0, 0, 255,0));
  } else if (probabilidad < 0.075) {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoAmarillo");
     circulo.setStroke(0,0,0,0); 
    circulo.setFillColor(color(255, 255, 0,0));
  } else if (probabilidad < 0.5) {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoVerde");
    circulo.setStroke(0,0,0,0);
    circulo.setFillColor(color(0, 255, 0,0));
  } else if (probabilidad < 0.625) {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoVioleta");
     circulo.setStroke(0,0,0,0);
    circulo.setFillColor(color(128, 0, 128,0));
  } else if (probabilidad < 0.75) {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoNaranja");
    circulo.setStroke(0,0,0,0);
    circulo.setFillColor(color(255, 165, 0,0));
  } else if (probabilidad < 0.875) {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoNegro");
    circulo.setStroke(0,0,0,0);
    circulo.setFillColor(color(0, 0, 0,0));
  } else {
    circulo = new FCircle(radioBolas);
    circulo.setName("enemigoMarron");
    circulo.setStroke(0,0,0,0);
    circulo.setFillColor(color(139, 69, 19,0));
  }

  circulo.setPosition(posX, 50);
  mundo.add(circulo);
  bolas.add(circulo);

  tiempoUltimaBola = millis();
}
 float mouseXClamped = constrain(blobX, rangoXMin, rangoXMax);
 push();
 noStroke();
 tint(0,0,0,0);
    ellipse(mouseXClamped, sueloY - radioBolas, ovaloRadioX * 2, ovaloRadioY * 2);
    pop();
    cadena.setTarget(mouseXClamped, sueloY - radioBolas);
    
    //cambio hasta aca

    //float mouseXClamped = constrain(mouseX, 250, 950);
push();
imageMode(CENTER);
tint(255, opacidadPizza1);
image(cursor,mouseXClamped, sueloY - radioBolas);
bola.setStroke(0,0,0,0);
bola.setFillColor(color(0, 0, 0,0));
pop();
push();
imageMode(CENTER);
tint(255, opacidadPizza2);
image(cursor1,mouseXClamped, sueloY - radioBolas);
pop();push();
imageMode(CENTER);
tint(255, opacidadPizza3);
image(cursor2,mouseXClamped, sueloY - radioBolas);
pop();
push();
imageMode(CENTER);
tint(255, opacidadTomate);
image(tomateEnPizza,mouseXClamped, sueloY - radioBolas);
pop();
push();
imageMode(CENTER);
tint(255, opacidadPeperoni);
image(peperoniEnPizza,mouseXClamped, sueloY - radioBolas);
pop();
push();
imageMode(CENTER);
tint(255, opacidadHongo);
image(hongoEnPizza,mouseXClamped, sueloY - radioBolas);
pop();
    cadena.setTarget(mouseXClamped, sueloY - radioBolas);
     if (vidas == 2) {
     opacidadPizza1 = 0;
     opacidadPizza2 = 255;
    }
    if (vidas == 1) {
     opacidadPizza1 = 0;
     opacidadPizza2 = 0;
     opacidadPizza3 = 255;
    }
    if (vidas <= 0) {
      gameOver = true; 
    }
    if (bolasAtrapadasRojas >= 1 && bolasAtrapadasAzules >= 1 && bolasAtrapadasAmarillas >= 1) {
    victoria = true;
    pantallaVictoria();
  }
}
for (FCircle bola : bolas) {
    float fuerza = -1000;
    bola.addForce(0, -fuerza);
  }
}

void reiniciarJuego() {
  vidas = 3;
  vidasPerdidas = 0;
  victoria = false;

  for (FCircle bola : bolas) {
    mundo.remove(bola);
  }
  bolas.clear();

  bola.setPosition(width / 2, height / 4);
  bola.setVelocity(0, 0);

  for (int i = 0; i < vidasCuadrados.length; i++) {
    vidasCuadrados[i].setFillColor(color(255));
  }

  tiempoUltimaBola = millis();

 
  iniciarJuego = true;
  pantallaInicial = false;
  gameOver = false;
     opacidadPizza1 = 255;
     opacidadPizza2 = 0;
     opacidadPizza3 = 0;
}
int bolasAtrapadasRojas = 0;
int bolasAtrapadasAzules = 0;
int bolasAtrapadasAmarillas = 0;




void restarVida() {
  vidas--;
  vidasPerdidas++;
  if (vidas <= 0) {
    gameOver();
  } else {
    // Cambiar uno de los cuadrados de vidas a negro
    vidasCuadrados[vidas].setFillColor(color(0)); // Cambiar el color del cuadrado a negro
  }
}

void gameOver() {
  if (juego.isPlaying()) {
    juego.pause();
    juego.rewind();
  }
  if (ganaste.isPlaying()) {
    ganaste.pause();
    ganaste.rewind();
  }
  if (inicio.isPlaying()) {
    inicio.pause();
    inicio.rewind();
  }
  fill(0);
  textAlign(CENTER, CENTER);
  image(gameover, 0, 0);
  fill(255, 100, 100);
  rect(botonReiniciarX, botonReiniciarY, botonReiniciarAncho, botonReiniciarAlto);
  fill(255);
  textSize(24);
  image(reinicio,width/2-150,480);
  perdiste.play();
}

void pantallaInicio() {
  if (juego.isPlaying()) {
    juego.pause();
    juego.rewind();
  }
  if (ganaste.isPlaying()) {
    ganaste.pause();
    ganaste.rewind();
  }
  if (perdiste.isPlaying()) {
    perdiste.pause();
    perdiste.rewind();
  }
 image(iniciar,0,0);
  fill(100, 100, 255);
  rect(botonInicioX, botonInicioY, botonInicioAncho, botonInicioAlto);
  image(botoninicio,width/2 - 125 ,height/2 + 90);
  inicio.play();
}

void pantallaVictoria() {
  if (juego.isPlaying()) {
    juego.pause();
    juego.rewind();
  }
  if (inicio.isPlaying()) {
    inicio.pause();
    inicio.rewind();
  }
  if (perdiste.isPlaying()) {
    perdiste.pause();
    perdiste.rewind();
  }

  image(felicidades, 0, 0);
  noLoop();
  ganaste.play(); 
}
void mouseMoved() {
  if (mouseX >= botonInicioX && mouseX <= botonInicioX + botonInicioAncho &&
      mouseY >= botonInicioY && mouseY <= botonInicioY + botonInicioAlto) {
    mouseSobreBotonInicio = true;
  } else {
    mouseSobreBotonInicio = false;
  }
}
void mousePressed(MouseEvent event) {
  if (pantallaInicial && mouseSobreBotonInicio && contadorActivo && tiempoEnBoton >= tiempoRequerido) {
    iniciarJuego = true;
    pantallaInicial = false;
  }
  
  if (gameOver && mouseX >= botonReiniciarX && mouseX <= botonReiniciarX + botonReiniciarAncho &&
      mouseY >= botonReiniciarY && mouseY <= botonReiniciarY + botonReiniciarAlto) {
     println("Reiniciar juego");
    reiniciarJuego();
  }
}
