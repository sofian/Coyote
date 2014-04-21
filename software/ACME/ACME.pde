import controlP5.*;
import java.util.Map;

static final int BACKGROUND = #777CAF;

static final int N_COLUMNS = 49;
static final int N_ROWS    = 12;
static final int FONT_SIZE = N_ROWS;

static final int WINDOW_WIDTH  = 800;
static final int WINDOW_HEIGHT = 600;

//static final int EDITOR_BORDER = 20;
static final int EDITOR_WIDTH   = 600;
static final int EDITOR_HEIGHT  = EDITOR_WIDTH*N_ROWS/N_COLUMNS;
static final int EDITOR_PADDING = 50;
static final int CONTROL_TOP    = 2*EDITOR_PADDING+EDITOR_HEIGHT;

static final int BUTTON_SIZE    = 40;

static final int TOOL_PEN  = 1;
static final int TOOL_TEXT = 2;

ClipHelper clipboard = new ClipHelper();

Pixmap pixmap = new Pixmap(N_COLUMNS, N_ROWS);

PixmapEditor editor;
PixmapTool tool;

PenTool penTool;
TextTool textTool;

ControlP5 cp5;
RadioButton toolButtons;
DropdownList fontDropdownList;

HashMap<String,PFont> fonts;
ArrayList<String> fontNames;

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  frameRate(20);
  
  cp5 =  new ControlP5(this);

  editor = new PixmapEditor((width-EDITOR_WIDTH)/2, EDITOR_PADDING, EDITOR_WIDTH, EDITOR_HEIGHT, pixmap);

  fonts = new HashMap<String,PFont>();
  fontNames = new ArrayList<String>();
  addFont("Arial",    createFont("Arial", FONT_SIZE));
  addFont("Arapix",   loadFont("29LTArapix-12.vlw"));

  // Create tools.
  penTool = new PenTool(editor);
  textTool = new TextTool(editor, fonts.get(fontNames.get(0)));

  // Controllers.
  toolButtons = cp5.addRadioButton("chooseTool")
                   .setPosition(EDITOR_PADDING, CONTROL_TOP)
                   .setSize(BUTTON_SIZE, BUTTON_SIZE)
                   .setColorForeground(color(120))
                   .setColorActive(color(255))
                   .setColorLabel(color(255))
                   .setItemsPerRow(2)
                   .setSpacingColumn(50)
                   .addItem("text", TOOL_TEXT)
                   .addItem("pen",  TOOL_PEN)
                   ;
  // Toggle for LTR/RTL.
  cp5.addToggle("toggleLTR")
     .setPosition(EDITOR_PADDING + 5*BUTTON_SIZE, CONTROL_TOP)
     .setSize(BUTTON_SIZE, BUTTON_SIZE/2)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
  
  // Drop-down list for fonts.
  fontDropdownList = cp5.addDropdownList("chooseFont")
                        .setPosition(EDITOR_PADDING + 5*BUTTON_SIZE, CONTROL_TOP + 2*BUTTON_SIZE)
                        .setItemHeight(BUTTON_SIZE/2)
                        .setBarHeight(BUTTON_SIZE/2)
                        ;
  fontDropdownList.captionLabel().style().marginTop    = 5;
  fontDropdownList.captionLabel().style().marginBottom = 5;
  for (int i=0; i<fontNames.size(); i++) {
    fontDropdownList.addItem(fontNames.get(i), i);
  }

  // Add export buttons.
  cp5.addButton("exportToArduino")
     .setPosition(width - EDITOR_PADDING - BUTTON_SIZE*3, CONTROL_TOP)
     .setLabel("-> Arduino")     ;
  
  cp5.addButton("exportToPureData")
     .setPosition(width - EDITOR_PADDING - BUTTON_SIZE*3, CONTROL_TOP + BUTTON_SIZE)
     .setLabel("-> PureData")     ;

  // Assign default tool.
  toolButtons.activate(0);
  fontDropdownList.setIndex(0);
  tool = textTool;
}

void draw() {
  background(BACKGROUND);
  editor.display();
  tool.display();
}

void chooseTool(int id) {
  if (id == TOOL_PEN) {
    tool = penTool;
  }
  else if (id == TOOL_TEXT) {
    tool = textTool;
    textTool.reset();
  }
}

void toggleLTR(boolean ltr) {
  textTool.setLTR(ltr);
}


void exportToArduino() {
  /*
  prog_int16_t povArray[] PROGMEM
   
   */
  String code = "#define POVARRAYSIZE "+N_COLUMNS+"\rint povArray[] = { "; 
  for ( int c =0 ; c <  N_COLUMNS ; c++ ) {
    int compresssedRow = 0;
    for ( int r =0 ; r < N_ROWS ; r++) {
      compresssedRow = compresssedRow << 1;
      compresssedRow = compresssedRow | (pixmap.get(c, r) == Pixmap.OFF ? Pixmap.OFF : Pixmap.ON);
    }
    code = code + compresssedRow ;
    if ( c != N_COLUMNS - 1 ) code = code + " , ";
  }
  code = code + "};\r";
  clipboard.copyString(code);
}

void exportToPureData() {
  String code = ""; 
  for ( int c =0 ; c <  N_COLUMNS ; c++ ) {
    int compresssedRow = 0;
    for ( int r =0 ; r < N_ROWS ; r++) {
      compresssedRow = compresssedRow << 1;
      compresssedRow = compresssedRow | (pixmap.get(c, r) == Pixmap.OFF ? Pixmap.OFF : Pixmap.ON);
    }
    code = code + compresssedRow ;
    if ( c != N_COLUMNS - 1 ) code = code + " ";
  }
  clipboard.copyString(code);
}

void controlEvent(ControlEvent event) {
  if (event.isGroup()) {
    if (event.getGroup() == fontDropdownList) {
      textTool.setFont( fonts.get( fontNames.get( (int) event.getGroup().getValue() ) ) );
    }
  }
}

void mousePressed() {
  tool.mousePressed();
}

void mouseDragged() {
  tool.mouseDragged();
}

void mouseMoved() {
  tool.mouseMoved();
}

void mouseReleased() {
  tool.mouseReleased();
}

void keyTyped() {
  tool.keyTyped();
}

void keyPressed() {
  tool.keyPressed();
  if ( keyCode == DELETE ) {
    for (int i =0; i < pixmap.nPixels(); i++) {
      pixmap.set(i, Pixmap.OFF);
    }
  } 
}

void keyReleased() {
  tool.keyReleased();
}

void addFont(String name, PFont font) {
  fonts.put(name, font);
  fontNames.add(name);
}


