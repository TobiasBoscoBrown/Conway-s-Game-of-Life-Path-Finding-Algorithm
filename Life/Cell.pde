class Cell {
  int condition; // Condition of the cell, dead or alive
  int x; // X position of the cell
  int y; // Y position of the cell
  int numAliveNeighbors; // Number of alive neighbors
  boolean isRandom = false;

  Cell(int condition, int x, int y, boolean isRandom) {
    this.condition = condition;
    this.x = x;
    this.y = y;
    this.numAliveNeighbors = 0;
  }

  void displayCell() {
    switch (this.condition) {
    case 1:
      fill(255);
      break;
    case 2:
      fill(255, 0, 0);
      break;
    case 3:
      fill(0, 255, 0);
      break;
    case 4:
      fill(128, 0, 128);
      break;
    default:
      fill(0);
      break;
    }

    rect(x * cellSize, y * cellSize, cellSize, cellSize);
  }
}
