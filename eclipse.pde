// Andrew Barlow
// eclipse.pde
// tryin to create an eclipse effect in processing

// CLASSES //////////////////////////////////////////////////

// Andrew's sane rendering manager
class Renderer {
    private String filetype;

    public Renderer(String filetype) {
        // ".png" ".jpg" ".jpeg" ".tif"
        this.filetype = filetype;
    }

    public void Render() {
        String date = (month() + "-" + day() + "-" + year() + "/" + hour() + "-" + minute() + "-" + second());
        saveFrame("renders/" + date + ".png");
    }
}

// GLOBAL VARS //////////////////////////////////////////////////

// track renders
int ticker = 0;
// define total renders
final int renders = 1;
// draw lines in color
final boolean useColor = false;
// rendering manager
Renderer r;
// center of canvas
PVector center; 


// FUNCTIONS //////////////////////////////////////////////////

void setup() {
    size(2560, 1440);
    background(0, 0, 0, 255);
    r = new Renderer(".png");
    center = new PVector(width / 2, height / 2);
}

// createPoints calculates a pair of points starting at the edge of a circle using trigonometry, and ending in a random spot outward from the circle
PVector[] createPoints(float theta, float m, int randomDisplacementRange) {

        // creating interesting forms of randomness 

        // uniform random displacement
        PVector randomDisplacement = new PVector(
            random(-randomDisplacementRange, randomDisplacementRange),
            random(-randomDisplacementRange, randomDisplacementRange)
        );


        // attempt at creating random walk-quality to the boundaries of corona
        PVector perlinDisplacement = new PVector( 
            ( noise( (theta*100000) % (2 * TWO_PI)) - 0.5 ) * randomDisplacementRange * 2,
            ( noise( (theta*100000 + 100) % (2 * TWO_PI)) - 0.5) * randomDisplacementRange * 2
            // ( noise(theta*100000) - 0.5 ) * randomDisplacementRange * 10,
            // ( noise(theta*100000 + 100) - 0.5) * randomDisplacementRange * 10
        );

        // creating the starting points for my line
        PVector point1 = new PVector(
            cos(theta) * m + center.x, 
            sin(theta) * m + center.y
        );

        // creating the ending points for my line
        PVector point2 = new PVector(
            cos(theta) * m + center.x + randomDisplacement.x + perlinDisplacement.x, 
            sin(theta) * m + center.y + randomDisplacement.y + perlinDisplacement.y
        );

    return  new PVector[] {point1, point2};

}

void draw() {

    stroke(255, 255, 255, 3);
    

    // multiplier determines base size of corona
    float multiplier = height / 3;

    // go around a circle pseudo-randomly a large number of times
    for (float theta = 0; theta < 100000 * TWO_PI; theta += random(100) * PI / 100) {

        // range of random vals
        int randomDisplacementRange = 100;

        // calculate points
        PVector [] points = createPoints(theta, multiplier, randomDisplacementRange);

        // determine line stroke color
        float r, g, b;

        if (useColor) {
            r = ((255/5) * randomGaussian()) + (255/2);
            g = ((255/5) * randomGaussian()) + (255/2);
            b = ((255/5) * randomGaussian()) + (255/2);
        }
        else {
            r = 255;
            g = 255;
            b = 255;
        }

        // draw the line; change alpha depending on # of iterations
        stroke(r, g, b, 10);
        line(points[0].x, points[0].y, points[1].x, points[1].y);
    }

    fill(0, 0, 0, 255);

    circle(center.x, center.y, 2 * multiplier);
    

    if (ticker < renders) {
        ticker++;
        draw();
        r.Render();
    }

    noLoop();
}