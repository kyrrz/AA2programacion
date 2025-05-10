package programacion.model;

import lombok.Data;

import java.sql.Date;

@Data
public class Dog {

    private int id;
    private int id_shelter;
    private String name;
    private String breed;
    private Date birth_date;
    private String gender;
    private double weight;
    private boolean castrated;
    private String image;

}
