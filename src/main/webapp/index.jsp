<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.DogDaoImpl" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="java.util.List" %>
<%@ page import="programacion.dao.DogDao" %>
<%@ page import="java.sql.SQLException" %>

<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>

<%
    String search = request.getParameter("search");
%>

<div class="album py-5 bg-body-tertiary">
    <div class="container mb-5">
        <form method="get" action="<%= request.getRequestURI() %>">
            <input type="text" name="search" id="search" class="form-control" placeholder="Buscar" value="<%= search != null ? search : "" %>">
        </form>
    </div>

    <div class="container">

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
            <%

                Database database = new Database();
                try {
                    database.connect();
                } catch (ClassNotFoundException e) {
                    throw new RuntimeException(e);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                DogDao dogDao = new DogDaoImpl(database.getConnection());

                List<Dog> dogList = dogDao.getAll(search);
                for (Dog dog : dogList) {
            %>
            <div class="col">
                <div class="card shadow-sm">
                    <img class="img-thumbnail" src="/shelter_images/<%= dog.getImage() %>" style="width: 100%; height: 225px; object-fit: cover;">
                    <div class="card-body">
                        <h4 class="card-text"><%= dog.getName() %></h4>
                        <p class="card-text"><%= dog.getBreed() %></p>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="btn-group">
                                <%
                                    if (role.equals("anonymous")) {
                                %>
                                <a href="login.jsp" class="btn btn-sm btn-secondary">Log In para ver</a>
                                <%
                                    } else if (role.equals("user")) {
                                %>
                                <a href="view_dog.jsp?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-secondary">Detalles</a>
                                <%
                                } else if (role.equals("admin")) {
                                %>
                                <a href="view_dog.jsp?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-secondary">Detalles</a>
                                <a href="edit_dog.jsp?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-warning">Modificar</a>
                                <a href="delete_dog?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-danger">Eliminar</a>
                                <%
                                    }
                                %>
                            </div>
                            <small class="text-body-secondary"> <%= dog.getGender() %> </small>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>

<%@include file="includes/footer.jsp"%>
