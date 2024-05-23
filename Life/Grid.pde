class Grid {
  int rows; // Number of rows in the grid
  int cols; // Number of columns in the grid
  Cell[][] cells; // 2D array of Cell objects

  Grid(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    this.cells = new Cell[rows][cols];
  }

  // Initialize the grid with blank cells
  void initializeBlankGrid() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cells[i][j] = new Cell(0, i, j, false);
      }
    }
  }

  // Update the grid
void updateGrid() {
  // First, convert all random cells to either alive or dead
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (cells[i][j].isRandom) {
        cells[i][j].condition = (random(1) < 0.5) ? 0 : 1;
        cells[i][j].isRandom = false;
      }
    }
  }

  // Update the number of alive neighbors for each cell
  countNumAliveNeighbors();

  // Create a temporary grid to hold the new state
  Cell[][] newGrid = new Cell[rows][cols];

  // Then, apply the rules of Conway's Game of Life
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int numAliveNeighbors = cells[i][j].numAliveNeighbors;

      // Any live cell with fewer than two live neighbours dies, as if by underpopulation.
      // Any live cell with more than three live neighbours dies, as if by overpopulation.
      if (cells[i][j].condition == 1 && (numAliveNeighbors < 2 || numAliveNeighbors > 3)) {
        newGrid[i][j] = new Cell(0, i, j, false); // Dead cell in the new grid
      }
      // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
      else if (cells[i][j].condition == 0 && numAliveNeighbors == 3) {
        newGrid[i][j] = new Cell(1, i, j, false); // Alive cell in the new grid
      } else {
        // In all other cases, the cell remains in its current state
        newGrid[i][j] = new Cell(cells[i][j].condition, i, j, false);
      }
    }
  }

  // Replace the old grid with the new grid
  cells = newGrid;
}




  // Display the grid
  void displayGrid() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cells[i][j].displayCell();
      }
    }
  }

  // Count the number of alive neighbors for each cell in the grid
  void countNumAliveNeighbors() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int numAliveNeighbors = 0;

        // Check the 8 neighboring cells
        for (int di = -1; di <= 1; di++) {
          for (int dj = -1; dj <= 1; dj++) {
            if (di == 0 && dj == 0) {
              continue; // Skip the current cell
            }

            int ni = i + di; // Neighbor row index
            int nj = j + dj; // Neighbor column index

            // Check if the neighbor cell is within the grid bounds
            if (ni >= 0 && ni < rows && nj >= 0 && nj < cols) {
              if (cells[ni][nj].condition == 1) {
                numAliveNeighbors++;
              }
            }
          }
        }

        cells[i][j].numAliveNeighbors = numAliveNeighbors;
      }
    }
  }
  // Convert all random cells to either dead or alive
  void convertRandomCells() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        Cell cell = cells[i][j];
        if (cell.condition == 4) { // If the cell is random
          cell.condition = (int) random(2); // Set the cell's condition to a random value (0 or 1)
        }
      }
    }
  }
  void drawGridLines() {
  stroke(0, 0, 255); // Set the color for the grid lines
  for (int i = 0; i <= rows; i++) {
    line(0, i * cellSize, cols * cellSize, i * cellSize); // Draw horizontal lines
  }
  for (int j = 0; j <= cols; j++) {
    line(j * cellSize, 0, j * cellSize, rows * cellSize); // Draw vertical lines
  }
}
}
