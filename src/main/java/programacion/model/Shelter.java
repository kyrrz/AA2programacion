package programacion.model;

import lombok.Data;

import java.sql.Date;

@Data
public class Shelter {

    private int id;
    private String name;
    private String address  ;
    private String city;
    private int number;
    private Date foundation_date;
    private double rating;
    private boolean active;
}
