class App {

    public static void main(String[] args) {
        Console console = new Console();

        console.writeln("Registro de alumno");
        String nombre = console.readString("Nombre: ");
        int edad = console.readInt("Edad: ");
        double nota = console.readDouble("Nota media: ");

        console.writeln("> Alumno: " + nombre);
        console.writeln("> Edad: " + edad);
        console.writeln("> Nota media: " + nota);
    }
}