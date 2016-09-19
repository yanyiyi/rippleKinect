// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/ce-2l2wRqO8

class Blob {
    float minx, miny, maxx, maxy;

    Blob(float x, float y) {
        minx = x;
        miny = y;
        maxx = x;
        maxy = y;
    }

    void show() {
        // stroke(0);
        // fill(255);
        // strokeWeight(2);
        // rectMode(CORNERS);
        //rect(minx, miny, maxx, maxy);
        int x=(int)(minx+maxx)/2;
        int y=(int)(miny+maxy)/2;
        disturb(width-x, y);
        //ellipse((minx+maxx)/2,(miny+maxy)/2,30,30);
    }

    void add(float x, float y) {
        minx = min(minx, x);
        miny = min(miny, y);
        maxx = max(maxx, x);
        maxy = max(maxy, y);
    }

    float size() {
        return (maxx-minx)*(maxy-miny);
    }

    boolean isNear(float x, float y) {
        float cx = (minx + maxx) / 2;
        float cy = (miny + maxy) / 2;

        float d = distSq(cx, cy, x, y);
        if (d < distThreshold*distThreshold) {
            return true;
        } else {
            return false;
        }
    }
}