import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class split_sanitizer {

    static boolean checkShape(String s) {
        return s != null
            && s.length() >= 8 && s.length() <= 24
            && !s.contains(".");
    }

    static boolean checkSeparators(String s) {
        return !s.contains("/")
            && !s.contains("\\")
            && !s.contains("%");
    }

    static boolean isValidName2(String s) {
        return checkShape(s) && checkSeparators(s);
    }

    public static String read(String userInput) throws IOException {
        if (!isValidName2(userInput)) {
            throw new IllegalArgumentException();
        }
        return Files.readString(Path.of(userInput));
    }

    public static void main(String[] args) throws Exception {
        read(args.length > 0 ? args[0] : "testfile");
    }
}

