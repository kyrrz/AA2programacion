<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.model.Shelter" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="programacion.exception.ShelterNotFoundException" %>
<%@ page import="programacion.dao.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>

<%
    if ((currentSession.getAttribute("role") == null) || (!currentSession.getAttribute("role").equals("admin"))) {
        response.sendRedirect("/shelter/login.jsp");
    }

    String action;
    Shelter shelter = null;
    String shelterId = request.getParameter("shelter_id");
    System.out.println("Shelter id :" + shelterId);


    if (shelterId != null) {
        action = "Modificar";
        Database database = new Database();
        try {
            database.connect();
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException(e);
        }
        ShelterDao shelterDao = new ShelterDaoImpl(database.getConnection());
        try {
            shelter = shelterDao.get(Integer.parseInt(shelterId));
        } catch (SQLException | ShelterNotFoundException e) {
            throw new RuntimeException(e);
        }
    } else {
        action = "Registrar";
    }

%>

<script type="text/javascript">
    $(document).ready(function() {
        $("form").on("submit", function(event) {
            event.preventDefault();
            const form = $("#shelter-form")[0];
            const formValue = new FormData(form);
            console.log(formValue);
            $.ajax({
                url: "edit_shelter",
                type: "POST",
                enctype: "multipart/form-data",
                data: formValue,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 10000,
                statusCode: {
                    200: function(response) {
                        console.log(response);
                        if (response === "ok") {
                            // TODO Limpiar el formulario?
                            $("#result").html("<div class='alert alert-success' role='alert'>" + response + "</div>");
                        } else {
                            $("#result").html("<div class='alert alert-danger' role='alert'>" + response + "</div>");
                        }
                    },
                    404: function(response) {
                        $("#result").html("<div class='alert alert-danger' role='alert'>Error al enviar los datos</div>");
                    },
                    500: function(response) {
                        console.log(response);
                        $("#result").html("<div class='alert alert-danger' role='alert'>" + response.toString() + "</div>");
                    }
                }
            });
        });
    });

    function confirmModify() {
        return confirm("¿Estás seguro de que quieres modificar este refugio?");
    }

</script>
<div class="container d-flex justify-content-center">
    <div class="card" style="width: 50rem;">
        <form class="row g-2 p-5" id="shelter-form" method="post" enctype="multipart/form-data">
            <h1 class="h3 mb-3 fw-normal"><%=action%> un refugio</h1>
            <div class="form-floating col-md-6">
                <input type="text" id="floatingTextarea" name="name" class="form-control" placeholder="Dog Id"
                       value="<%=shelter != null ? shelter.getName() : ""%>">
                <label for="floatingTextarea">Nombre</label>
            </div>
            <div class="form-floating col-md-6">
                <input type="text" id="floatingTextarea" name="address" class="form-control" placeholder="User Id"
                       value="<%=shelter != null ? shelter.getAddress() : ""%>">
                <label for="floatingTextarea">Direccion</label>
            </div>
            <div class="form-floating col-md-6">
                <input type="text" id="floatingTextarea" name="city" class="form-control" placeholder="Shelter Date"
                       value="<%=shelter != null ? shelter.getCity() : ""%>">
                <label for="floatingTextarea">Ciudad</label>
            </div>
            <div class="form-floating col-md-6">
                <input type="text" id="floatingTextarea" name="number" class="form-control" placeholder="Aceptado"
                       value="<%=shelter != null ? shelter.getNumber() : ""%>">
                <label for="floatingTextarea">Telefono</label>
            </div>
            <div class="form-floating col-md-6">
                <input type="date" id="floatingTextarea" name="foundation_date" class="form-control" placeholder="Donation"
                       value="<%=shelter != null ? shelter.getFoundation_date() : ""%>">
                <label for="floatingTextarea">Año de fundacion</label>
            </div>
            <div class="form-floating col-md-6">
                <input type="text" id="floatingTextarea" name="rating" class="form-control" placeholder="Notes"
                       value="<%=shelter != null ? shelter.getRating() : ""%>">
                <label for="floatingTextarea">Valoracion</label>
            </div>
            <div class="form-floating col-md-6">
                <input type="text" id="floatingTextarea" name="active" class="form-control" placeholder="Notes"
                       value="<%=shelter != null ? shelter.isActive() : ""%>">
                <label for="floatingTextarea">Activo? (true/false)</label>
            </div>


            <div class="input-group mb-3">
                <input onclick="return confirmModify()" class="btn btn-primary" type="submit" value="Guardar">
            </div>

            <input type="hidden" name="action" value="<%=action%>">

            <%
                if (action.equals("Modificar")) {
            %>
            <input type="hidden" name="id" value="<%=Integer.parseInt(shelterId)%>">
            <%
                }
            %>

            <div id="result"></div>
        </form>
    </div>
</div>

<%@include file="includes/footer.jsp"%>
