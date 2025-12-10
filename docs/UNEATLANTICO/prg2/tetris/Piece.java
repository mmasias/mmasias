class Piece {
    private boolean[][] shape;
    private Position position;
    private char symbol;

    public Piece(boolean[][] shape, char symbol) {
        this.shape = shape;
        this.symbol = symbol;
        this.position = new Position(0, 0);
    }

    public boolean[][] getShape() {
        return shape;
    }

    public Position getPosition() {
        return position;
    }

    public char getSymbol() {
        return symbol;
    }

    public void moveDown() {
        position.setY(position.getY() + 1);
    }

    public void moveLeft() {
        position.setX(position.getX() - 1);
    }

    public void moveRight() {
        position.setX(position.getX() + 1);
    }

    public void rotate() {
        rotateClockwise();
    }

    public void rotateClockwise() {
        int rows = shape.length;
        int cols = shape[0].length;
        boolean[][] rotated = new boolean[cols][rows];

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                rotated[j][rows - 1 - i] = shape[i][j];
            }
        }
        shape = rotated;
    }

    public void rotateCounterClockwise() {
        int rows = shape.length;
        int cols = shape[0].length;
        boolean[][] rotated = new boolean[cols][rows];

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                rotated[cols - 1 - j][i] = shape[i][j];
            }
        }
        shape = rotated;
    }
}