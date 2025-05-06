package programacion.dao;

import programacion.exception.DogNotFoundException;
import programacion.model.Dog;

import java.sql.SQLException;
import java.util.ArrayList;

public interface DogDao {

    Dog getDog(int id);
    boolean add(Dog dog) throws SQLException;
    ArrayList<Dog> getAll() throws SQLException;
    ArrayList<Dog> getAll(String search) throws SQLException;
    Dog get(int id) throws SQLException, DogNotFoundException;
    boolean modify(Dog dog) throws SQLException;
    boolean delete(int dogId) throws SQLException;

}
