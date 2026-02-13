import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class single_sanitizer {

    public static boolean isValidName(String s) {
        return s != null
            && s.length() >= 8 && s.length() <= 24
            && !s.contains(".")
            && !s.contains("/")
            && !s.contains("\\")
            && !s.contains("%");
    }

    public static String read(String userInput) throws IOException {
        if (!isValidName(userInput)) {
            throw new IllegalArgumentException();
        }
        return Files.readString(Path.of(userInput));
    }

    public static void main(String[] args) throws Exception {
        read(args.length > 0 ? args[0] : "testfile");
    }
}

