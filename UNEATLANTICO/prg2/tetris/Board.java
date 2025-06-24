public class Board {
    private char[][] grid;
    private int width;
    private int height;
    private Piece currentPiece;
    private Console console;

    public Board(int width, int height, Console console) {
        this.width = width;
        this.height = height;
        this.grid = new char[height][width];
        this.console = console;
        clearBoard();
    }

    private void clearBoard() {
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                grid[i][j] = '.';
            }
        }
    }

    public void setCurrentPiece(Piece piece) {
        this.currentPiece = piece;
        piece.getPosition().setX(width / 2 - piece.getShape()[0].length / 2);
        piece.getPosition().setY(0);
    }

    public Piece getCurrentPiece(){
        return currentPiece;
    }

    public boolean canMovePiece(Piece piece, int deltaX, int deltaY) {
        boolean[][] shape = piece.getShape();
        Position pos = piece.getPosition();

        for (int i = 0; i < shape.length; i++) {
            for (int j = 0; j < shape[i].length; j++) {
                if (shape[i][j]) {
                    int newX = pos.getX() + j + deltaX;
                    int newY = pos.getY() + i + deltaY;

                    if (newX < 0 || newX >= width || newY >= height) {
                        return false;
                    }

                    if (newY >= 0 && grid[newY][newX] != '.') {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    public boolean canRotatePiece(Piece piece, boolean clockwise) {

        if (clockwise) {
            piece.rotateClockwise();
        } else {
            piece.rotateCounterClockwise();
        }

        boolean canRotate = canMovePiece(piece, 0, 0);

        if (!canRotate) {
            if (clockwise) {
                piece.rotateCounterClockwise();
                piece.rotateCounterClockwise();
                piece.rotateCounterClockwise();
            } else {
                piece.rotateClockwise();
                piece.rotateClockwise();
                piece.rotateClockwise();
            }
        }

        return canRotate;
    }

    public void placePiece(Piece piece) {
        boolean[][] shape = piece.getShape();
        Position pos = piece.getPosition();

        for (int i = 0; i < shape.length; i++) {
            for (int j = 0; j < shape[i].length; j++) {
                if (shape[i][j]) {
                    int x = pos.getX() + j;
                    int y = pos.getY() + i;
                    if (y >= 0 && y < height && x >= 0 && x < width) {
                        grid[y][x] = piece.getSymbol();
                    }
                }
            }
        }
    }

    public int clearCompleteLines() {
        int linesCleared = 0;

        for (int i = height - 1; i >= 0; i--) {
            boolean isComplete = true;

            for (int j = 0; j < width; j++) {
                if (grid[i][j] == '.') {
                    isComplete = false;
                    break;
                }
            }

            if (isComplete) {
                for (int k = i; k > 0; k--) {
                    for (int j = 0; j < width; j++) {
                        grid[k][j] = grid[k - 1][j];
                    }
                }

                for (int j = 0; j < width; j++) {
                    grid[0][j] = '.';
                }

                linesCleared++;
                i++;
            }
        }

        return linesCleared;
    }

    public void display() {
        char[][] displayGrid = new char[height][width];
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                displayGrid[i][j] = grid[i][j];
            }
        }

        if (currentPiece != null) {
            boolean[][] shape = currentPiece.getShape();
            Position pos = currentPiece.getPosition();

            for (int i = 0; i < shape.length; i++) {
                for (int j = 0; j < shape[i].length; j++) {
                    if (shape[i][j]) {
                        int x = pos.getX() + j;
                        int y = pos.getY() + i;
                        if (y >= 0 && y < height && x >= 0 && x < width) {
                            displayGrid[y][x] = currentPiece.getSymbol();
                        }
                    }
                }
            }
        }

        console.writeln("<!" + "=".repeat(((width+2)*2)-1) + "!>");
        for (int i = 0; i < height; i++) {
            console.write("<!  ");
            for (int j = 0; j < width; j++) {
                console.write(displayGrid[i][j] + " ");
            }
            console.writeln(" !>");
        }
        console.writeln("<!" + "=".repeat(((width+2)*2)-1) + "!>");
        console.writeln("\\/".repeat(width+4));
    }
}