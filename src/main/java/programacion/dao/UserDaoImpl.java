package programacion.dao;


import programacion.exception.DogNotFoundException;
import programacion.exception.UserNotFoundException;
import programacion.model.Dog;
import programacion.model.User;

import java.sql.*;
import java.util.ArrayList;

public class UserDaoImpl implements UserDao {

    private Connection connection;

    public UserDaoImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public String loginUser(String username, String password) throws SQLException, UserNotFoundException {
        String sql = "SELECT role FROM user WHERE username = ? AND password = ?";

        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        statement.setString(2, password);
        ResultSet result = statement.executeQuery();
        if (!result.next()) {
            throw new UserNotFoundException();
        }

        return result.getString("role");
    }

    @Override
    public boolean register(String username, String email, String password, String passwordCheck) throws SQLException {
        if (username == null || email == null || password == null || passwordCheck == null) {
            return false;
        }

        if (!password.equals(passwordCheck)) {
            return false;
        }

        // Check if user already exists
        String checkQuery = "SELECT COUNT(*) FROM user WHERE username = ? OR email = ?";
        try (PreparedStatement checkStmt = connection.prepareStatement(checkQuery)) {
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // User already exists
            }
        }

        // Insert new user
        String sql = "INSERT INTO user (name, email, phone, city, birth_date, canAdopt, rating, role, username, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, email);
            statement.setInt(3, 0);
            statement.setString(4, "unknown");
            statement.setDate(5, Date.valueOf("1990-01-01"));
            statement.setBoolean(6, false);
            statement.setDouble(7, 3);
            statement.setString(8, "user");
            statement.setString(9, username);
            statement.setString(10, password);


            int affectedRows = statement.executeUpdate();

            return affectedRows != 0;
        }
    }

    @Override
    public User get(String username) throws SQLException, UserNotFoundException {
        String sql = "SELECT * FROM user WHERE username = ?";
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new UserNotFoundException();
        }

        User user = new User();
        user.setId(result.getInt("id"));
        user.setName(result.getString("name"));
        user.setEmail(result.getString("email"));
        user.setPhone(result.getInt("phone"));
        user.setCity(result.getString("city"));
        user.setBirth_date(result.getDate("birth_date"));
        user.setCanAdopt(result.getBoolean("canAdopt"));
        user.setRating(result.getDouble("rating"));
        user.setRole(result.getString("role"));
        user.setUsername(result.getString("username"));
        user.setPassword(result.getString("password"));

        statement.close();

        return user;
    }

    @Override
    public User get(int id) throws SQLException, UserNotFoundException {
        String sql = "SELECT * FROM user WHERE id = ?";
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(sql);
        statement.setInt(1, id);
        result = statement.executeQuery();
        if (!result.next()) {
            throw new UserNotFoundException();
        }

        User user = new User();
        user.setId(result.getInt("id"));
        user.setName(result.getString("name"));
        user.setEmail(result.getString("email"));
        user.setPhone(result.getInt("phone"));
        user.setCity(result.getString("city"));
        user.setBirth_date(result.getDate("birth_date"));
        user.setCanAdopt(result.getBoolean("canAdopt"));
        user.setRating(result.getDouble("rating"));
        user.setRole(result.getString("role"));
        user.setUsername(result.getString("username"));
        user.setPassword(result.getString("password"));

        statement.close();

        return user;
    }

    @Override
    public boolean modify(User user) throws SQLException{
        String sql = "UPDATE user SET name = ?, email = ?, phone = ?, city = ?, birth_date = ?, canAdopt = ?, rating = ?, " +
                "role = ?, username = ?, password = ? WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, user.getName());
        statement.setString(2, user.getEmail());
        statement.setInt(3, user.getPhone());
        statement.setString(4, user.getCity());
        statement.setDate(5, user.getBirth_date());
        statement.setBoolean(6, user.isCanAdopt());
        statement.setDouble(7, user.getRating());
        statement.setString(8, user.getRole());
        statement.setString(9, user.getUsername());
        statement.setString(10, user.getPassword());
        statement.setInt(11, user.getId());
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM user WHERE id = ?";

        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, userId);
        int affectedRows = statement.executeUpdate();

        return affectedRows != 0;
    }

    @Override
    public ArrayList<User> getAll(String search) throws SQLException {
        if (search == null || search.isEmpty()) {
            return getAll();
        }

        String sql = "SELECT * FROM user WHERE name LIKE ? OR username LIKE ?";
        return launchQuery(sql, search);
    }

    @Override
    public ArrayList<User> getAll() throws SQLException {
        String sql = "SELECT * FROM user";
        return launchQuery(sql);
    }

    private ArrayList<User> launchQuery(String query, String... search) throws SQLException {
        PreparedStatement statement;
        ResultSet result;

        statement = connection.prepareStatement(query);
        if (search.length > 0) {
            statement.setString(1, "%" + search[0] + "%");
            statement.setString(2, "%" + search[0] + "%");
        }
        result = statement.executeQuery();
        ArrayList<User> userList = new ArrayList<>();
        while (result.next()) {
            User user = new User();
            user.setId(result.getInt("id"));
            user.setName(result.getString("name"));
            user.setEmail(result.getString("email"));
            user.setPhone(result.getInt("phone"));
            user.setCity(result.getString("city"));
            user.setBirth_date(result.getDate("birth_date"));
            user.setCanAdopt(result.getBoolean("canAdopt"));
            user.setRating(result.getDouble("rating"));
            user.setRole(result.getString("role"));
            user.setUsername(result.getString("username"));
            user.setPassword(result.getString("password"));
            userList.add(user);
        }

        statement.close();

        return userList;
    }
}


