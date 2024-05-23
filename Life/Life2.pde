int gridSize = 200; // Size of the grid (number of rows and columns)
int cellSize = 8; // Size of each cell in pixels
float panX = 0; // Horizontal panning
float panY = 0; // Vertical panning
float panSpeed = 10.0; // Speed of panning

boolean isPaused = true; // Variable to track if the simulation is paused or not

Grid grid; // Declare a Grid object
ToolSelectWindow toolSelectWindow; // Declare a ToolSelectWindow object

void settings() {
  size(gridSize * cellSize, gridSize * cellSize); // Set the size of the canvas
}

void setup() {
  size(gridSize * cellSize, gridSize * cellSize);
  grid = new Grid(gridSize, gridSize);
  grid.initializeBlankGrid();
  grid.drawGridLines(); // Draw the grid lines
  toolSelectWindow = new ToolSelectWindow();
  isPaused = true;
}

float zoom = 1.0; // Default zoom level

void draw() {
  background(0);

  pushMatrix();
  translate(width/2 + panX, height/2 + panY);
  scale(zoom);
  translate(-gridSize * cellSize / 2, -gridSize * cellSize / 2);

  grid.displayGrid(); // Display the grid

  popMatrix();

  // Display the toolbar without any transformation
  toolSelectWindow.display();

  if (!isPaused) {
    grid.updateGrid(); // Update the grid only if the simulation is not paused
  }
}

void mouseClicked() {
  // Only change cells when clicking on the grid, not on the toolbar
  if (!isMouseWithinToolbar()) {
    handleDrag(mouseX, mouseY);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom -= e * 0.1; // Adjust the zoom level based on the mouse wheel
  zoom = constrain(zoom, 0.5, 5.0); // Constrain the zoom level to a range of 0.5 to 5.0
}

void keyPressed() {
  if (key == ' ') { // If the spacebar is pressed
    isPaused = !isPaused; // Toggle the paused state
  } else if (key == 'c') { // If the 'c' key is pressed
    grid.initializeBlankGrid(); // Clear the grid by initializing it to a blank state
  } else if (key == '1') {
    toolSelectWindow.toggleBrushWindow(); // Toggle the visibility of the brush window when "1" is pressed
  } else if (key == 's') {
    saveGrid(); // Save the current grid when "s" is pressed
  } else if (key == 'l') {
    loadGrid(); // Load a saved grid when "l" is pressed
  }

  // Handle the arrow keys
  if (keyCode == UP) {
    panY += panSpeed;
  } else if (keyCode == DOWN) {
    panY -= panSpeed;
  } else if (keyCode == LEFT) {
    panX += panSpeed;
  } else if (keyCode == RIGHT) {
    panX -= panSpeed;
  }
}

void mousePressed() {
  // If the mouse is clicked inside the toolbar area
  if (mouseY < toolSelectWindow.height) {
    toolSelectWindow.handlePress(mouseX, mouseY);
  }
}

void mouseDragged() {
  // If the mouse is dragged inside the grid area (not in the toolbar area)
  if (!isMouseWithinToolbar()) {
    handleDrag(mouseX, mouseY);
  }
}

void mouseReleased() {
  // If the mouse is released inside the toolbar area
  if (mouseY < toolSelectWindow.height) {
    toolSelectWindow.handleRelease(mouseX, mouseY);
  }
}

void handleDrag(int mouseX, int mouseY) {
  // Calculate the brush size in terms of cells based on the zoom level and brush size
  int cellBrushSize = (toolSelectWindow.brushSize - 1) * 2 + 1;
  
  // Adjust the mouse coordinates based on the pan offset and cell size
  int adjustedMouseX = (int) ((mouseX / zoom - width / (2 * zoom) - panX / zoom) / cellSize + gridSize / 2);
  int adjustedMouseY = (int) ((mouseY / zoom - height / (2 * zoom) - panY / zoom) / cellSize + gridSize / 2);

  // Set the brush size and condition for each affected cell
  int startX = max(adjustedMouseX - cellBrushSize / 2, 0);
  int startY = max(adjustedMouseY - cellBrushSize / 2, 0);
  int endX = min(adjustedMouseX + cellBrushSize / 2 + 1, gridSize);
  int endY = min(adjustedMouseY + cellBrushSize / 2 + 1, gridSize);

  for (int i = startX; i < endX; i++) {
    for (int j = startY; j < endY; j++) {
      Cell cell = grid.cells[i][j]; // Get the cell
      cell.condition = toolSelectWindow.brushType; // Set the cell's condition to the current brush type
      if (toolSelectWindow.brushType == 4) { // If the brush type is "random"
        cell.isRandom = true;
      } else {
        cell.isRandom = false;
      }
    }
  }
}



boolean isMouseWithinToolbar() {
  if (toolSelectWindow.isBrushWindowVisible()){
  return (mouseX <= toolSelectWindow.width && mouseY <= toolSelectWindow.height);
  }
  else{
  return false;
  }
}

void saveGrid() {
  String[] lines = new String[gridSize];
  for (int i = 0; i < gridSize; i++) {
    StringBuilder line = new StringBuilder();
    for (int j = 0; j < gridSize; j++) {
      line.append(grid.cells[i][j].condition).append(" ");
    }
    lines[i] = line.toString().trim();
  }

  selectOutput("Save Grid", "saveGridFileSelected");
}

void saveGridFileSelected(File selection) {
  if (selection == null) {
    println("File selection canceled");
  } else {
    String[] lines = new String[gridSize];
    for (int i = 0; i < gridSize; i++) {
      StringBuilder line = new StringBuilder();
      for (int j = 0; j < gridSize; j++) {
        line.append(grid.cells[i][j].condition).append(" ");
      }
      lines[i] = line.toString().trim();
    }
    
    saveStrings(selection, lines);
    println("Grid saved to file: " + selection.getAbsolutePath());
  }
}

void loadGrid() {
  selectInput("Load Grid", "loadGridFileSelected");
}

void loadGridFileSelected(File selection) {
  if (selection == null) {
    println("Load dialog was cancelled");
  } else {
    String[] lines = loadStrings(selection.getAbsolutePath());
    if (lines.length != gridSize) {
      println("Invalid grid file format");
    } else {
      for (int i = 0; i < gridSize; i++) {
        String[] tokens = lines[i].split(" ");
        if (tokens.length != gridSize) {
          println("Invalid grid file format");
          return;
        }
        for (int j = 0; j < gridSize; j++) {
          int condition = Integer.parseInt(tokens[j]);
          grid.cells[i][j].condition = condition;
          grid.cells[i][j].isRandom = (condition == 4); // Set the "isRandom" flag for random cells
        }
      }
      println("Grid loaded successfully!");
    }
  }
}
