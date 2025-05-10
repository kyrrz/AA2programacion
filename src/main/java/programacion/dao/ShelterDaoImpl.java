package programacion.dao;

import programacion.exception.ShelterNotFoundException;
import programacion.model.Shelter;

import java.sql.*;
import java.util.ArrayList;

public class ShelterDaoImpl implements ShelterDao {

    private Connection connection;

    public ShelterDaoImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public boolean add(Shelter shelter) throws SQLException {
        String sql = "INSERT INTO shelter (name, address, city, number, foundation_date, rating, active) " +
                " VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement statement;

        statement = connection.prepareStatement(sql);
        statement.setString(1, shelter.getName());
        statement.setString(2, shelter.getAddress());
        statement.setString(3, shelter.getCity());
        statement.setInt(4,  shelter.getNumber());
        statement.setDate(5, shelter.getFoundation_date());
        statement.setDouble(6, shelter.getRating());
        statement.setBoolean(7, shelter.isActive());

        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public Shelter get(int id) throws SQLException, ShelterNotFoundException {
        String sql = "SELECT * FROM shelter WHERE id = ?";
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, id);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new ShelterNotFoundException();
        }

        Shelter shelter = new Shelter();
       shelter.setId(result.getInt("id"));
       shelter.setName(result.getString("name"));
       shelter.setAddress(result.getString("address"));
       shelter.setCity(result.getString("city"));
       shelter.setFoundation_date(result.getDate("foundation_date"));
       shelter.setRating(result.getDouble("rating"));
       shelter.setActive(result.getBoolean("active"));

        statement.close();

        return shelter;
    }

    @Override
    public ArrayList<Shelter> getAll(String search) throws SQLException {
        if (search == null || search.isEmpty()) {
            return getAll();
        }

        String sql = "SELECT * FROM shelter WHERE name LIKE ? OR city LIKE ?";
        return launchQuery(sql, search);
    }

    @Override
    public ArrayList<Shelter> getAll() throws SQLException {
        String sql = "SELECT * FROM shelter";
        return launchQuery(sql);
    }

    @Override
    public boolean modify(Shelter shelter) throws SQLException{
        String sql = "UPDATE shelter SET name = ?, address = ?, city = ?, number = ?, foundation_date = ?, rating = ?, " +
                "active = ?  WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);

        statement.setString(1, shelter.getName());
        statement.setString(2, shelter.getAddress());
        statement.setString(3, shelter.getCity());
        statement.setInt(4, shelter.getNumber());
        statement.setDate(5, shelter.getFoundation_date());
        statement.setDouble(6, shelter.getRating());
        statement.setBoolean(7, shelter.isActive());
        statement.setInt(8, shelter.getId());

        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public boolean delete(int shelterId) throws SQLException {
        String sql = "DELETE FROM shelter WHERE id = ?";

        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, shelterId);
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public boolean updateStatus(int shelterId, boolean status) throws SQLException {
        String sql = "UPDATE shelter SET active = ? WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setBoolean(1, status);
        statement.setInt(2, shelterId);
        int affectedRows = statement.executeUpdate();
        return affectedRows != 0;
    }

    private ArrayList<Shelter> launchQuery(String query, String... search) throws SQLException {
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(query);
        if (search.length > 0) {
            statement.setString(1, "%" + search[0] + "%");
            statement.setString(2, "%" + search[0] + "%");
        }
        result = statement.executeQuery();
        ArrayList<Shelter> shelterList = new ArrayList<>();
        while (result.next()) {
            Shelter shelter = new Shelter();
            shelter.setId(result.getInt("id"));
            shelter.setName(result.getString("name"));
            shelter.setAddress(result.getString("address"));
            shelter.setCity(result.getString("city"));
            shelter.setNumber(result.getInt("number"));
            shelter.setFoundation_date(result.getDate("foundation_date"));
            shelter.setRating(result.getDouble("rating"));
            shelter.setActive(result.getBoolean("active"));

            shelterList.add(shelter);
        }

        statement.close();

        return shelterList;
    }

}


