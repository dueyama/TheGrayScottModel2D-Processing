// The Gray-Scott model
// Reference:
// [1]Gray, P., and S. K. Scott. "Autocatalytic reactions in the isothermal, continuous stirred tank reactor: Oscillations and instabilities in the system A+ 2B→ 3B; B→ C." Chemical Engineering Science 39.6 (1984): 1087-1097.
// [2]Pearson, John E. "Complex patterns in a simple system." Science 261.5118 (1993): 189-192.
// [3]Nishiura, Yasumasa, and Daishin Ueyama. "A skeleton structure of self-replicating dynamics." Physica D: Nonlinear Phenomena 130.1-2 (1999): 73-104.
// F and K are the control parameters
// Here are the several conbinations that makes interesting patterns.
// (F, K) = (0.02, 0.059), (0.02, 0.05), (0.037, 0.06), (0.078, 0.061), (0.014, 0.054)

float Fv[] = {0.02, 0.02, 0.037, 0.078, 0.014, 0.01};
float Kv[] = {0.059, 0.05, 0.06, 0.061, 0.054, 0.045};

int selected = 3;

float F2 = Fv[3];
float K2 = Kv[3];

float F1 = Fv[4];
float K1 = Kv[4];

int N = 300;
float L = 3.0;
int INUM = 3;
int IWID = 15;
int LOOP = 60;

int time = 0;

float DU = 2.0e-5;
float DV = 1.0e-5;
float DT = 1.0;

float DX = L/N;
float DY = L/N;

float alphaU = DT*DU/(DX*DX);
float alphaV = DT*DV/(DX*DX);

float[][] u = new float[N+2][N+2];
float[][] v = new float[N+2][N+2];

float[][] pF = new float[N+2][N+2];
float[][] pK = new float[N+2][N+2];

int WSIZE = 600;
float dx = WSIZE/float(N - 1);
float dy = WSIZE/float(N - 1);

void settings() {
  size(WSIZE, WSIZE);
}

void setup() {
  noStroke();
  frameRate(30);
  colorMode(HSB, 256);

  for (int i = 0; i < N+2; i++) {
    for (int j = 0; j < N+2; j++) {
      u[i][j] = 1.0;
      v[i][j] = 0.0;
      pF[i][j] = F1;
      pK[i][j] = K1;
    }
  }

  for (int k = 0; k < INUM; k++) {
    int iix = int(random(N - IWID));
    int iiy = int(random(N - IWID));

    for (int i = iix; i < iix + IWID; i++) {
      for (int j = iiy; j < iiy + IWID; j++) {
        u[i][j] = 0.2;
        v[i][j] = 0.8;
      }
    }
  }
}

void update(int loop) {
  float uu, vv, F, K;
  for (int k = 0; k < loop; k++) {
    time++;
    // Boundary conditions (Periodic)
    for (int i = 1; i < N+1; i++) {
      u[i][0  ] = u[i][N];
      u[i][N+1] = u[i][1];
      v[i][0  ] = v[i][N];
      v[i][N+1] = v[i][1];
    }
    for (int j = 1; j < N+1; j++) {
      u[0  ][j] = u[N][j];
      u[N+1][j] = u[1][j];
      v[0  ][j] = v[N][j];
      v[N+1][j] = v[1][j];
    }

    // Main scheme
    for (int i = 1; i < N+1; i++) {
      for (int j = 1; j < N+1; j++) {
        uu = u[i][j];
        vv = v[i][j];
        F = pF[i][j];
        K = pK[i][j];

        u[i][j] = uu + (u[i-1][j] + u[i+1][j] + u[i][j+1] + u[i][j-1] - 4*uu)*alphaU + (-uu*vv*vv + F*(1 - uu))*DT;
        v[i][j] = vv + (v[i-1][j] + v[i+1][j] + v[i][j+1] + v[i][j-1] - 4*vv)*alphaV + ( uu*vv*vv - (F + K)*vv)*DT;
      }
    }
  }
}

void draw() {
  update(LOOP);

  float x, y, value;

  for (int i = 1; i < N+1; i++) {
    x = (i - 1)*dx;
    for (int j = 1; j < N+1; j++) {
      y = (j - 1)*dy;
      value = u[i][j]*180;
      fill(value, 255, 255);
      rect(x, y, dx, dy);
    }
  }
  //Uncomment this for making an animation
  //saveFrame("frames/######.png");
}

void mouseDragged() {
  int iix = int(mouseX/dx);
  int iiy = int(mouseY/dy);

  float FF = Fv[selected];
  float KK = Kv[selected];

  if (mouseButton == RIGHT) {
    FF = F1;
    KK = K1;
  }

  for (int i = 1; i < N+1; i++) {
    for (int j = 1; j < N+1; j++) {
      if ((iix - i)*(iix - i) + (iiy - j)*(iiy - j) < IWID*IWID) {
        pF[i][j] = FF;
        pK[i][j] = KK;
      }
    }
  }
}

int a = 0;
void keyPressed() {
  // Push Enter then save image ###.png 
  if (keyCode == ENTER) {
    save("sample" + a + ".png");
    a++;
  }

  switch(key) {
  case '0':
    selected = 0;
    break;
  case '1':
    selected = 1;
    break;
  case '2':
    selected = 2;
    break;
  case '3':
    selected = 3;
    break;
  case '4':
    selected = 4;
    break;
  case '5':
    selected = 5;
    break;
  }
}
