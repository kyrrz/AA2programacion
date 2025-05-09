package programacion.dao;

import programacion.exception.UserNotFoundException;
import programacion.model.Dog;
import programacion.model.User;


import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;


public interface UserDao {

    String loginUser(String username, String password) throws SQLException, UserNotFoundException;
    boolean register(String username, String email, String password, String passwordCheck) throws SQLException;
    User get(String username) throws SQLException, UserNotFoundException;
    User get(int id) throws SQLException, UserNotFoundException;
    boolean modify(User user) throws SQLException;
    boolean delete(int userId) throws SQLException;
    ArrayList<User> getAll(String search) throws SQLException;
    ArrayList<User> getAll() throws SQLException;
}
