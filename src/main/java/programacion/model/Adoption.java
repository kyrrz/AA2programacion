package programacion.model;

import lombok.Data;

import java.sql.Date;

@Data
public class Adoption {

    private int id;
    private int id_dog;
    private int id_user;
    private Date adoption_date;
    private boolean accepted;
    private double donation;
    private String notes;
}
