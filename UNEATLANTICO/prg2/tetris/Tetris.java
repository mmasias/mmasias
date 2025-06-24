public class Tetris {
    private Board board;
    private boolean gameRunning;
    private int score;
    private Console console;
    
    public Tetris(int width, int height) {
        board = new Board(width, height, new Console());
        gameRunning = true;
        score = 0;
        console = new Console();
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
        if (input.length() != 0) {
            char command = input.charAt(0);
            
            switch (command) {
                case '4' -> {if (board.canMovePiece(board.getCurrentPiece(), -1, 0)) 
                                board.getCurrentPiece().moveLeft();}
                case '6' -> {if (board.canMovePiece(board.getCurrentPiece(), 1, 0)) 
                                board.getCurrentPiece().moveRight();}
                case '7' -> board.canRotatePiece(board.getCurrentPiece(), false);
                case '9' -> board.canRotatePiece(board.getCurrentPiece(), true);
            }
        }
    }
    
    private void showInstructions() {
        console.writeln("CONTROLES");
        console.writeln("4     : Mover izquierda");
        console.writeln("6     : Mover derecha");
        console.writeln("7     : Rotar levógiro (antihorario)");
        console.writeln("9     : Rotar dextrógiro (horario)");
        console.writeln("Enter : Pasar turno");
        console.writeln("-".repeat(20));
        console.writeln();
    }
    
    public void gameLoop() {
        showInstructions();
        spawnNewPiece();
        
        while (gameRunning) {
            for (int i = 0; i < 50; i++) {
                System.out.println();
            }
            
            board.display();
            String input = console.readString("Score: " + score + "\n\nComando (4=izq, 6=der, 7=rotar↺, 9=rotar↻): ");
            processUserInput(input);
            
            if (board.canMovePiece(board.getCurrentPiece(), 0, 1)) {
                board.getCurrentPiece().moveDown();
            } else {
                board.placePiece(board.getCurrentPiece());
                
                int linesCleared = board.clearCompleteLines();
                score += linesCleared * 100;
                
                if (linesCleared > 0) {
                    console.writeln("¡" + linesCleared + " línea(s) eliminada(s)!");
                    console.readString("Presiona Enter para continuar...");
                }
                
                spawnNewPiece();
                
                if (!board.canMovePiece(board.getCurrentPiece(), 0, 0)) {
                    gameRunning = false;
                    console.writeln("¡GAME OVER!");
                    console.writeln("Puntuación final: " + score);
                }
            }
        }   
    }
}