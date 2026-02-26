import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.regex.Pattern;

public class Console {

    private static final String INTEGER_regExp = "-?\\d+";
    private static final String DOUBLE_regExp = "-?(\\d+(\\.\\d+)?([eE][+-]?\\d+)?|\\.\\d+([eE][+-]?\\d+)?)";
    private static final String CHAR_regExp = ".";

    private BufferedReader input;

    public Console() {
        this.input = new BufferedReader(new InputStreamReader(System.in));
    }

    public String readString() {
        return this.readString("");
    }

    public String readString(String title) {
        assert title != null;

        this.write(title);
        String string = "";
        try {
            string = this.input.readLine();
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return string;
    }

    public char readChar() {
        return this.readChar("");
    }

    public char readChar(String title) {
        assert title != null;

        Pattern charPattern = Pattern.compile(CHAR_regExp);
        char characterInput = ' ';
        boolean ok;
        do {
            String string = this.readString(title);
            ok = charPattern.matcher(string).find();
            if (ok) {
                characterInput = string.charAt(0);
            } else {
                this.writeError(charPattern.toString());
            }
        } while (!ok);
        return characterInput;
    }

    public int readInt() {
        return this.readInt("");
    }

    public int readInt(String title) {
        assert title != null;

        Pattern intPattern = Pattern.compile(INTEGER_regExp);
        int intInput = 0;
        boolean ok;
        do {
            String string = this.readString(title);
            ok = intPattern.matcher(string.trim()).matches();
            if (ok) {
                intInput = Integer.parseInt(string.trim());
            } else {
                this.writeError(intPattern.toString());
            }
        } while (!ok);
        return intInput;
    }

    public double readDouble() {
        return this.readDouble("");
    }

    public double readDouble(String title) {
        assert title != null;

        Pattern doublePattern = Pattern.compile(DOUBLE_regExp);
        double doubleInput = 0;
        boolean ok;
        do {
            String string = this.readString(title);
            ok = doublePattern.matcher(string.trim()).matches();
            if (ok) {
                doubleInput = Double.parseDouble(string.trim());
            } else {
                this.writeError(doublePattern.toString());
            }
        } while (!ok);
        return doubleInput;
    }

    public void write(String string) {
        assert string != null;

        System.out.print(string);
    }

    public void writeln(String string) {
        this.write(string + "\n");
    }

    public void writeln() {
        this.writeln("");
    }

    public void write(char character) {
        System.out.print(character);
    }

    public void writeln(char character) {
        this.write(character + "\n");
    }

    public void write(int value) {
        System.out.print(value);
    }

    public void writeln(int value) {
        this.write(value + "\n");
    }

    public void write(double value) {
        System.out.print(value);
    }

    public void writeln(double value) {
        this.write(value + "\n");
    }

    public void write(Object object) {
        System.out.print(object);
    }

    public void writeln(Object object) {
        this.write(object + "\n");
    }

    private void writeError(String regExp) {
        System.out.println("Error de formato: se esperaba " + regExp);
    }
}