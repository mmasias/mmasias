public class TetrisGame {
    private Board board;
    private boolean gameRunning;
    private int score;
    private java.util.Scanner scanner;
    
    public TetrisGame(int width, int height) {
        this.board = new Board(width, height);
        this.gameRunning = true;
        this.score = 0;
        this.scanner = new java.util.Scanner(System.in);
    }
    
    public void spawnNewPiece() {
        Piece[] pieces = {
            PieceFactory.createIPiece(),
            PieceFactory.createOPiece(),
            PieceFactory.createTPiece(),
            PieceFactory.createLPiece()
        };
        
        int randomIndex = (int)(Math.random() * pieces.length);
        board.setCurrentPiece(pieces[randomIndex]);
    }
    
    private void processUserInput(String input) {
        if (input.length() == 0) {
            return;
        }
        
        char command = input.charAt(0);
        
        switch (command) {
            case '4' -> {if (board.canMovePiece(board.currentPiece, -1, 0)) 
                            board.currentPiece.moveLeft();}
            case '6' -> {if (board.canMovePiece(board.currentPiece, 1, 0)) 
                            board.currentPiece.moveRight();}
            case '7' -> board.canRotatePiece(board.currentPiece, false);
            case '9' -> board.canRotatePiece(board.currentPiece, true);
        }
    }
    
    private void showInstructions() {
        System.out.println("=== CONTROLES ===");
        System.out.println("4: Mover izquierda");
        System.out.println("6: Mover derecha");
        System.out.println("7: Rotar levógiro (antihorario)");
        System.out.println("9: Rotar dextrógiro (horario)");
        System.out.println("Enter: Pasar turno");
        System.out.println("================");
        System.out.println();
    }
    
    public void gameLoop() {
        showInstructions();
        spawnNewPiece();
        
        while (gameRunning) {
            for (int i = 0; i < 50; i++) {
                System.out.println();
            }
            
            board.display();
            System.out.println("Score: " + score);
            System.out.println();
            System.out.print("Comando (4=izq, 6=der, 7=rotar↺, 9=rotar↻): ");
            String input = scanner.nextLine().trim();           
            processUserInput(input);
            
            if (board.canMovePiece(board.currentPiece, 0, 1)) {
                board.currentPiece.moveDown();
            } else {
                board.placePiece(board.currentPiece);
                
                int linesCleared = board.clearCompleteLines();
                score += linesCleared * 100;
                
                if (linesCleared > 0) {
                    System.out.println("¡" + linesCleared + " línea(s) eliminada(s)!");
                    System.out.println("Presiona Enter para continuar...");
                    scanner.nextLine();
                }
                
                spawnNewPiece();
                
                if (!board.canMovePiece(board.currentPiece, 0, 0)) {
                    gameRunning = false;
                    System.out.println("¡GAME OVER!");
                    System.out.println("Puntuación final: " + score);
                }
            }
        }
        
        scanner.close();
    }
    
    public static void main(String[] args) {
        TetrisGame game = new TetrisGame(10, 20);
        game.gameLoop();
    }
}