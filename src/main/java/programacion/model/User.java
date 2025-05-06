package programacion.model;

import lombok.Data;

import java.util.Date;

@Data
public class User {

    private int id;
    private String name;
    private String email;
    private int phone;
    private String city;
    private Date birth_date;
    private boolean canAdopt;
    private double rating;
    private String role;
    private String username;
    private String password;

}
