<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.DogDaoImpl" %>
<%@ page import="programacion.model.Dog" %>
<%@ page import="java.util.List" %>
<%@ page import="programacion.util.CurrencyUtils" %>
<%@ page import="programacion.dao.DogDao" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>

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
                    <img class="img-thumbnail" src="./images/<%= dog.getImage() %>" >
                    <div class="card-body">
                        <h4 class="card-text"><%= dog.getName() %></h4>
                        <p class="card-text"><%= dog.getBreed() %></p>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="btn-group">
                                <a href="view_dog.jsp?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-outline-secondary">Mas info</a>
                                <%
                                    if (role.equals("user")) {
                                %>
                                <a href="add_to_cart?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-outline-secondary">Comprar</a>
                                <%
                                } else if (role.equals("admin")) {
                                %>
                                <a href="edit_dog.jsp?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-outline-warning">Modificar</a>
                                <a href="delete_dog?dog_id=<%= dog.getId() %>" class="btn btn-sm btn-outline-danger">Eliminar</a>
                                <%
                                    }
                                %>
                            </div>
                            <small class="text-body-secondary">Peso: <%= dog.getWeight() %> kg</small>
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
