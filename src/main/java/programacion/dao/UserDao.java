package programacion.dao;

import programacion.exception.UserNotFoundException;
import programacion.model.User;


import java.sql.Connection;
import java.sql.SQLException;


public interface UserDao {

    String loginUser(String username, String password) throws SQLException, UserNotFoundException;

}
