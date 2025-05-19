<%@ page import="programacion.database.Database" %>
<%@ page import="programacion.dao.DogDao" %>
<%@ page import="programacion.dao.DogDaoImpl" %>
<%@ page import="programacion.model.Dog" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp"%>
<%@include file="includes/navbar.jsp"%>

<!-- TODO Retringir acceso a los no administradores -->
<%
    if ((currentSession.getAttribute("role") == null) || (!currentSession.getAttribute("role").equals("admin"))) {
        response.sendRedirect("/shelter/login.jsp");
    }

    String action = null;
    Dog dog = null;
    String dogId = request.getParameter("id");
    if (dogId != null) {
        action = "Delete";
        Database db = new Database();
        db.connect();
        DogDao dogDao = new DogDaoImpl(db.getConnection());
        dog = dogDao.get(Integer.parseInt(dogId));
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
                url: "edit_dog",
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
</script>

<div class="album">
    <div class="container d-flex justify-content-center">


        <div id="result"></div>
        </form>
    </div>
</div>

<%@include file="includes/footer.jsp"%>
