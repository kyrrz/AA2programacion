package programacion.dao;


import programacion.exception.UserNotFoundException;
import programacion.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}
