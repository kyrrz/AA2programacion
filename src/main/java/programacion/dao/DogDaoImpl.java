package programacion.dao;

import programacion.exception.DogNotFoundException;
import programacion.model.Dog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DogDaoImpl implements DogDao {

    private Connection connection;

    public DogDaoImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public boolean add(Dog dog) throws SQLException {
        String sql = "INSERT INTO dog (id_shelter, name, breed, birth_date, gender, weight, castrated, image) " +
                " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement statement;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, dog.getId_shelter());
        statement.setString(2, dog.getName());
        statement.setString(3, dog.getBreed());
        statement.setDate(4,dog.getBirth_date());
        statement.setString(5, dog.getGender());
        statement.setDouble(6, dog.getWeight());
        statement.setBoolean(7, dog.isCastrated());
        statement.setString(8, dog.getImage());


        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public ArrayList<Dog> getAll() throws SQLException {
        String sql = "SELECT * FROM dog";
        return launchQuery(sql);
    }

    @Override
    public ArrayList<Dog> getNonAdopted() throws  SQLException {
        String sql = "SELECT * FROM dog WHERE id NOT IN (SELECT id_dog FROM adoption)";
        return launchQuery(sql);
    }

    @Override
    public ArrayList<Dog> getAll(String search) throws SQLException {
        if (search == null || search.isEmpty()) {
            return getAll();
        }

        String sql = "SELECT * FROM dog WHERE name LIKE ? OR breed LIKE ?";
        return launchQuery(sql, search);
    }

    @Override
    public Dog get(int id) throws SQLException, DogNotFoundException {
        String sql = "SELECT * FROM dog WHERE id = ?";
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, id);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new DogNotFoundException();
        }

        Dog dog = new Dog();
        dog.setId(result.getInt("id"));
        dog.setId_shelter(result.getInt("id_shelter"));
        dog.setName(result.getString("name"));
        dog.setBreed(result.getString("breed"));
        dog.setBirth_date(result.getDate("birth_date"));
        dog.setGender(result.getString("gender"));
        dog.setWeight(result.getDouble("weight"));
        dog.setCastrated(result.getBoolean("castrated"));
        dog.setImage(result.getString("image"));

        System.out.println(dog);
        System.out.println(dog.getId());
        System.out.println("AAAAAAAAAAAAAAAAAAA");
        statement.close();

        return dog;
    }

    @Override
    public boolean modify(Dog dog) throws SQLException{
        String sql = "UPDATE dog SET id_shelter = ?, name = ?, breed = ?, birth_date = ?, gender = ?, weight = ?, " +
                "castrated = ? WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, dog.getId_shelter());
        statement.setString(2, dog.getName());
        statement.setString(3, dog.getBreed());
        statement.setDate(4,dog.getBirth_date());
        statement.setString(5, dog.getGender());
        statement.setDouble(6, dog.getWeight());
        statement.setBoolean(7, dog.isCastrated());
        statement.setInt(8, dog.getId());
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public boolean delete(int dogId) throws SQLException {
        String sql = "DELETE FROM dog WHERE id = ?";

        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, dogId);
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    private ArrayList<Dog> launchQuery(String query, String... search) throws SQLException {
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(query);
        if (search.length > 0) {
            statement.setString(1, "%" + search[0] + "%");
            statement.setString(2, "%" + search[0] + "%");
        }
        result = statement.executeQuery();
        ArrayList<Dog> dogList = new ArrayList<>();
        while (result.next()) {
            Dog dog = new Dog();
            dog.setId(result.getInt("id"));
            dog.setName(result.getString("name"));
            dog.setBreed(result.getString("breed"));
            dog.setBirth_date(result.getDate("birth_date"));
            dog.setGender(result.getString("gender"));
            dog.setWeight(result.getDouble("weight"));
            dog.setCastrated(result.getBoolean("castrated"));
            dog.setImage(result.getString("image"));
            dogList.add(dog);
        }

        statement.close();

        return dogList;
    }
}
