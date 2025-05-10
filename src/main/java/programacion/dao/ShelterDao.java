package programacion.dao;

import programacion.exception.ShelterNotFoundException;
import programacion.model.Shelter;

import java.sql.SQLException;
import java.util.ArrayList;

public interface ShelterDao {

    Shelter get(int id) throws SQLException, ShelterNotFoundException;
    ArrayList<Shelter> getAll() throws SQLException;
    ArrayList<Shelter> getAll(String search) throws SQLException;
    boolean modify(Shelter shelter) throws SQLException;
    boolean delete(int shelterId) throws SQLException;
    boolean updateStatus(int shelterId, boolean status) throws SQLException;
    boolean add(Shelter shelter) throws SQLException;
}
