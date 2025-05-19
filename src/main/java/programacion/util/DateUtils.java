package programacion.util;

import java.sql.Date;
import java.text.SimpleDateFormat;

public class DateUtils {

    private final static String DATE_PATTERN = "dd/MM/yyyy";

    public static String format(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_PATTERN);
        return sdf.format(date);
    }

    public static String bul(Boolean bool) {
        return Boolean.TRUE.equals(bool) ? "Si" : "No";
    }

}
