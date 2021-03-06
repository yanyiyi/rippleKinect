import ddf.minim.*;
import processing.video.*;
import SimpleOpenNI.*;

SimpleOpenNI context;

color trackColor; 
float threshold = 20;
float distThreshold = 75;

ArrayList<Blob> blobs = new ArrayList<Blob>();
public static int CIRCLE_WIDTH = 150;
public static int CIRCLE_HEIGHT = 150;
int size;
int hwidth, hheight;
int riprad;

int ripplemap[];
int ripple[];
int texture[];

int oldind, newind, mapind;

int i, a, b; 


int numFrames1 = 92;
int currentFrame1 = 0;
int numFrames2 = 92;
int currentFrame2 = 0;

PImage[] back1 = new PImage[numFrames1];
PImage[] back2 = new PImage[numFrames2];
PImage img, img2, img3;


void setup() {
    new ddf.minim.Minim(this).loadFile("river.aif").loop();
    size(640, 480);
    
    img2 = loadImage("123.jpg");
    frameRate(30);
    img3=loadImage("BG3_0.png");
    for (int i = 0; i < numFrames1; i++) {
        back1[i] = loadImage("wave_" + i + ".png");
        back2[i] = loadImage("BG3_" + i + ".png");
    }
    ////////////////////////

    context = new SimpleOpenNI(this);
    if (context.isInit() == false)
    {
        println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
        exit();
        return;
    } 

    context.setMirror(false);

    // enable depthMap generation 
    context.enableDepth();

    // align depth data to image data
    context.alternativeViewPointDepthToImage();
    context.enableRGB();
    img=createImage(context.depthWidth(), context.depthHeight(), RGB);
    smooth();
    frameRate(40);
    trackColor = color(255, 0, 0);
    for (int i = 0; i < 150; i++) {
        hwidth = width>>1;
        hheight = height>>1;
        riprad=3; //test with 3 (initially 5)

        size = width * (height+2) * 2;

        ripplemap = new int[size];
        ripple = new int[width*height];
        texture = new int[width*height];

        oldind = width;
        newind = width * (height+3);

        //image background
        /* image(img, 0, 0); 
         * loadPixels();
         *
         * smooth();
         */


        //for an image loaded at the beginning
        /*  loadPixels();
         *smooth();
         *
         *img = loadImage("123.jpeg");
         *img.loadPixels();
         *img.mask(img);
         */
    }
}


void keyPressed() {
    if (key == 'a') {
        distThreshold++;
    } else if (key == 'z') {
        distThreshold--;
    }
    println(distThreshold);
}

void draw() {

    context.update();
    background(0);
    int s = second();
    int t=s%10;



    //image(img3,0,0);
    back1(t);

    back2(t);

    img.loadPixels();

    blobs.clear();

    int[] depth=context.depthMap();
    for (int x=0; x<context.depthWidth(); x++ ) {
        for (int y=0; y<context.depthHeight(); y++) {
            int offset=x+y*context.depthWidth();
            int da=depth[offset];
            if (da>0 && da<3000)
            { 
                img.pixels[offset]=color(255, 0, 0);
            } else
            { 
                img.pixels[offset]=color(0);
            }
        }
    }

    img.updatePixels();
    threshold = 20;
    for (int x = 0; x < img.width; x++ ) {
        for (int y = 0; y < img.height; y++ ) {
            int loc = x + y * img.width;
            // What is current color
            color currentColor = img.pixels[loc];
            float r1 = red(currentColor);
            float g1 = green(currentColor);
            float b1 = blue(currentColor);
            float r2 = red(trackColor);
            float g2 = green(trackColor);
            float b2 = blue(trackColor);

            float d = distSq(r1, g1, b1, r2, g2, b2); 

            if (d < threshold*threshold) {

                boolean found = false;
                for (Blob b : blobs) {
                    if (b.isNear(x, y)) {
                        b.add(x, y);
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    Blob b = new Blob(x, y);
                    blobs.add(b);
                }
            }
        }
    }

    for (Blob b : blobs) {
        if (b.size() > 500) {
            b.show();
        }
    }
    loadPixels();
    /////////////////////////////////

    texture = pixels;

    newframe();

    for (int i = 0; i < pixels.length; i++) {
        pixels[i] = ripple[i];
    }

    updatePixels();
}


float distSq(float x1, float y1, float x2, float y2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
    return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
    return d;
}

void mousePressed() {
    // Save color where the mouse is clicked in trackColor variable
    int loc = mouseX + mouseY*img.width;
    trackColor = img.pixels[loc];
}