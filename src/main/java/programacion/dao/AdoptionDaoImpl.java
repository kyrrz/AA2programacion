package programacion.dao;

import programacion.exception.AdoptionNotFoundException;
import programacion.model.Adoption;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.sql.Date;


public class AdoptionDaoImpl implements AdoptionDao {

    private Connection connection;

    public AdoptionDaoImpl(Connection connection) {
        this.connection = connection;
    }


    @Override
    public Adoption getById(int id) throws SQLException, AdoptionNotFoundException {
        String sql = "SELECT * FROM adoption WHERE id = ?";

        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, id);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new AdoptionNotFoundException();
        }

        Adoption adoption = new Adoption();
        adoption.setId(result.getInt("id"));
        adoption.setId_dog(result.getInt("id_dog"));
        adoption.setId_user(result.getInt("id_user"));
        adoption.setAdoption_date(result.getDate("adoption_date"));
        adoption.setAccepted(result.getBoolean("accepted"));
        adoption.setDonation(result.getDouble("donation"));
        adoption.setNotes(result.getString("notes"));

        statement.close();

        return adoption;

    }

    @Override
    public ArrayList<Adoption> getAll() throws SQLException {
        String sql = "SELECT * FROM adoption";
        return launchQuery(sql);
    }

    @Override
    public ArrayList<Adoption> getAll(String search) throws SQLException {
        if (search == null || search.isEmpty()) {
            return getAll();
        }

        String sql = "SELECT a.* FROM adoption a JOIN dog d ON a.id_dog = d.id WHERE d.name LIKE ? OR a.notes LIKE ?";
        return launchQuery(sql, search);
    }

    @Override
    public Adoption getByUserId(int userId) throws SQLException, AdoptionNotFoundException {
        String sql = "SELECT * FROM adoption WHERE id_user = ?";

        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, userId);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new AdoptionNotFoundException();
        }

        Adoption adoption = new Adoption();
        adoption.setId(result.getInt("id"));
        adoption.setId_dog(result.getInt("id_dog"));
        adoption.setId_user(result.getInt("id_user"));
        adoption.setAdoption_date(result.getDate("adoption_date"));
        adoption.setAccepted(result.getBoolean("accepted"));
        adoption.setDonation(result.getDouble("donation"));
        adoption.setNotes(result.getString("notes"));

        statement.close();

        return adoption;
    }

    @Override
    public int getAdoptionsByUserId(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM adoption WHERE id_user = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);

            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return result.getInt(1); // Get COUNT(*) value
                } else {
                    return 0; // No rows = count is 0
                }
            }
        }
    }


    @Override
    public Adoption getByDogId(int dogId) throws SQLException, AdoptionNotFoundException {
        String sql = "SELECT * FROM adoption WHERE id_dog = ?";

        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, dogId);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new AdoptionNotFoundException();
        }

        Adoption adoption = new Adoption();
        adoption.setId(result.getInt("id"));
        adoption.setId_dog(result.getInt("id_dog"));
        adoption.setId_user(result.getInt("id_user"));
        adoption.setAdoption_date(result.getDate("adoption_date"));
        adoption.setAccepted(result.getBoolean("accepted"));
        adoption.setDonation(result.getDouble("donation"));
        adoption.setNotes(result.getString("notes"));

        statement.close();

        return adoption;
    }

    @Override
    public Adoption getByShelterId(int userId) throws SQLException, AdoptionNotFoundException {
        String sql = "SELECT * FROM adoption WHERE id_user = ?";

        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, userId);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new AdoptionNotFoundException();
        }

        Adoption adoption = new Adoption();
        adoption.setId(result.getInt("id"));
        adoption.setId_dog(result.getInt("id_dog"));
        adoption.setId_user(result.getInt("id_user"));
        adoption.setAdoption_date(result.getDate("adoption_date"));
        adoption.setAccepted(result.getBoolean("accepted"));
        adoption.setDonation(result.getDouble("donation"));
        adoption.setNotes(result.getString("notes"));

        statement.close();

        return adoption;
    }

    @Override
    public Adoption getByDateRange(Date startDate, Date endDate) throws SQLException, AdoptionNotFoundException {
        ArrayList<Adoption> adoptions = new ArrayList<>();
        String sql = "SELECT * FROM adoption WHERE adoption_date BETWEEN ? AND ?";

        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setDate(1, new java.sql.Date(startDate.getTime()));
        statement.setDate(2, new java.sql.Date(endDate.getTime()));
        result = statement.executeQuery();
        if (!result.next()) {
            throw new AdoptionNotFoundException();
        }

        Adoption adoption = new Adoption();
        adoption.setId(result.getInt("id"));
        adoption.setId_dog(result.getInt("id_dog"));
        adoption.setId_user(result.getInt("id_user"));
        adoption.setAdoption_date(result.getDate("adoption_date"));
        adoption.setAccepted(result.getBoolean("accepted"));
        adoption.setDonation(result.getDouble("donation"));
        adoption.setNotes(result.getString("notes"));

        statement.close();
        return adoption;
    }

    @Override
    public boolean modify(Adoption adoption) throws SQLException {
        String sql = "UPDATE adoption SET id_dog = ?, id_user = ?, adoption_date = ?, accepted = ?, donation = ?, " +
                "notes = ? WHERE id = ?";

        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, adoption.getId_dog());
        statement.setInt(2, adoption.getId_user());
        statement.setDate(3, adoption.getAdoption_date());
        statement.setBoolean(4, adoption.isAccepted());
        statement.setDouble(5, adoption.getDonation());
        statement.setString(6, adoption.getNotes());
        statement.setInt(7, adoption.getId());
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public boolean updateStatus(int adoptionId, boolean status) throws SQLException {
        String sql = "UPDATE adoption SET status = ? WHERE id = ?";

        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, adoptionId);
        statement.setBoolean(2, status);
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public boolean delete(int adoptionId) throws SQLException {
        String sql = "DELETE FROM adoption WHERE id = ?";

        PreparedStatement statement;
        statement = connection.prepareStatement(sql);
        statement.setInt(1, adoptionId);
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public boolean add(Adoption adoption) throws SQLException {
        String sql = "INSERT INTO adoption (id_dog, id_user, adoption_date, accepted , donation, notes) " +
                " VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement statement;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, adoption.getId_dog());
        statement.setInt(2, adoption.getId_user());
        statement.setDate(3, adoption.getAdoption_date());
        statement.setBoolean(4, adoption.isAccepted());
        statement.setDouble(5, adoption.getDonation());
        statement.setString(6, adoption.getNotes());


        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }


    private ArrayList<Adoption> launchQuery(String query, String... search) throws SQLException {
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(query);
        if (search.length > 0) {
            statement.setString(1, "%" + search[0] + "%");
            statement.setString(2, "%" + search[0] + "%");
        }
        result = statement.executeQuery();
        ArrayList<Adoption> adoptionList = new ArrayList<>();
        while (result.next()) {
            Adoption adoption = new Adoption();
            adoption.setId(result.getInt("id"));
            adoption.setId_dog(result.getInt("id_dog"));
            adoption.setId_user(result.getInt("id_user"));
            adoption.setAdoption_date(result.getDate("adoption_date"));
            adoption.setAccepted(result.getBoolean("accepted"));
            adoption.setDonation(result.getDouble("donation"));
            adoption.setNotes(result.getString("notes"));

            adoptionList.add(adoption);
        }

        statement.close();

        return adoptionList;
    }
}
