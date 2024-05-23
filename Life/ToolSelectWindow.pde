class ToolSelectWindow {
  int x;
  int y;
  int width;
  int height;
  int brushType; // 0: dead, 1: alive, 2: wall, 3: goal, 4: random
  int brushSize = 1; // Default brush size
  int maxBrushSize = 10; // Maximum brush size
  boolean showBrushSizeOptions = false; // Flag to show/hide the brush size options
  boolean brushSizeChanged = false; // Flag to track if brush size was changed

  boolean showBrushWindow = true; // Flag to show/hide the brush window
  
  ToolSelectWindow() {
    x = 20;
    y = 20;
    width = 100;
    height = 230; // Increase height to accommodate the brush size button
    brushType = 1; // Default brush type: alive
  }

  void display() {
        if (!showBrushWindow) {
      return; // If the brush window is hidden, do not display anything
    }
    
    fill(200);
    rect(x, y, width, height);

    // Display brush type buttons
    fill(0);
    textAlign(LEFT, CENTER);
    text("Brush Type:", x + 10, y + 30);

    for (int i = 0; i < 5; i++) {
      float buttonX = x + 10;
      float buttonY = y + 40 + i * 30;

      if (mouseX >= buttonX && mouseX <= buttonX + 80 && mouseY >= buttonY && mouseY <= buttonY + 20) {
        if (mousePressed) {
          brushType = i;
        }
        fill(150);
      } else {
        fill(255);
      }

      rect(buttonX, buttonY, 80, 20);
      fill(0);
      textAlign(CENTER, CENTER);
      text(getBrushTypeName(i), buttonX + 40, buttonY + 10);
    }

    // Display brush size button
    float brushSizeButtonX = x + 10;
    float brushSizeButtonY = y + 190;

    if (mouseX >= brushSizeButtonX && mouseX <= brushSizeButtonX + 80 && mouseY >= brushSizeButtonY && mouseY <= brushSizeButtonY + 20) {
      if (mousePressed) {
        showBrushSizeOptions = !showBrushSizeOptions; // Toggle the flag when the button is pressed
      }
      fill(150);
    } else {
      fill(255);
    }

    rect(brushSizeButtonX, brushSizeButtonY, 80, 20);
    fill(0);
    textAlign(CENTER, CENTER);
    text("Brush Size", brushSizeButtonX + 40, brushSizeButtonY + 10);

    // Display brush size options when the button is pressed
    if (showBrushSizeOptions) {
      for (int i = 1; i <= maxBrushSize; i++) {
        float optionButtonX = x + 10;
        float optionButtonY = y + 200 + i * 30;

        if (mouseX >= optionButtonX && mouseX <= optionButtonX + 80 && mouseY >= optionButtonY && mouseY <= optionButtonY + 20) {
          if (mousePressed) {
            brushSize = i; // Update brush size when an option is clicked
            showBrushSizeOptions = false; // Hide the options after a selection is made
          }
          fill(150);
        } else {
          fill(255);
        }

        rect(optionButtonX, optionButtonY, 80, 20);
        fill(0);
        textAlign(CENTER, CENTER);
        text(str(i), optionButtonX + 40, optionButtonY + 10);
      }
    }
  }

  String getBrushTypeName(int index) {
    switch (index) {
      case 0:
        return "Dead";
      case 1:
        return "Alive";
      case 2:
        return "Wall";
      case 3:
        return "Goal";
      case 4:
        return "Random";
      default:
        return "";
    }
  }
  
    void toggleBrushWindow() {
    showBrushWindow = !showBrushWindow;
  }

  // Function to handle mouse press event
  void handlePress(int mouseX, int mouseY) {
    // Check if the click is inside the toolbar area
    if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height) {
      // Code to handle toolbar interactions (if any)
      // You can add more interactions here if needed
    }
  }

  // Function to handle mouse release event
  void handleRelease(int mouseX, int mouseY) {
    // Check if the release is inside the toolbar area
    if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height) {
      // Code to handle toolbar interactions (if any)
      // You can add more interactions here if needed
    }
  }
  boolean isBrushWindowVisible() {
    return showBrushWindow;
  }
}


class ToolButton {
  int x; // X position of the button
  int y; // Y position of the button
  int type; // Type of the tool that this button represents

  int buttonSize = 40; // Size of the button

  ToolButton(int x, int y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

void display() {
  // Display the button
  switch (type) {
    case 0:
      fill(0); // Black for dead cells
      break;
    case 1:
      fill(255); // White for alive cells
      break;
    case 2:
      fill(255, 0, 0); // Red for wall cells
      break;
    case 3:
      fill(0, 255, 0); // Green for goal cells
      break;
    case 4:
      fill(128, 0, 128); // Purple for random cells
      break;
  }
  rect(x, y, buttonSize, buttonSize); // Draw the button as a rectangle
}

  boolean isOver(int mouseX, int mouseY) {
    // Check if the mouse is over this button
    return mouseX > x && mouseX < x + buttonSize && mouseY > y && mouseY < y + buttonSize;
  }
  
  
}
