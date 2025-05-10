package programacion.dao;

import programacion.exception.AdoptionNotFoundException;
import programacion.model.Adoption;

import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Date;

public interface AdoptionDao {
    // Create
    boolean add(Adoption adoption) throws SQLException;

    // Read
    Adoption getById(int adoptionId) throws SQLException, AdoptionNotFoundException;
    ArrayList<Adoption> getAll() throws SQLException;
    ArrayList<Adoption> getAll(String search) throws SQLException;
    Adoption getByUserId(int userId) throws SQLException, AdoptionNotFoundException;
    public int getAdoptionsByUserId(int userId) throws SQLException;
    Adoption getByDogId(int dogId) throws SQLException, AdoptionNotFoundException;
    Adoption getByShelterId(int shelterId) throws SQLException, AdoptionNotFoundException;
    Adoption getByDateRange(Date startDate, Date endDate) throws SQLException, AdoptionNotFoundException;

    // Update
    boolean modify(Adoption adoption) throws SQLException;
    boolean updateStatus(int adoptionId, boolean status) throws SQLException;

    // Delete
    boolean delete(int adoptionId) throws SQLException;
}