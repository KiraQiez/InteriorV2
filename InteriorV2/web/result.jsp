<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.interior.model.User"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body class="d-flex align-items-center min-vh-100 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h2 class="card-title text-center mb-4">Registration Result</h2>
                        <p><%= request.getAttribute("message") %></p>
                        <%
                            User user = (User) request.getAttribute("user");
                            if (user != null) {
                        %>
                        <p><strong>Generated UserID:</strong> <%= user.getUserid() %></p>
                        <p><strong>Username:</strong> <%= user.getUsername() %></p>
                        <p><strong>Email:</strong> <%= user.getEmail() %></p>
                        <p><strong>Password:</strong> <%= user.getPassword() %></p>
                        <p><strong>User Type:</strong> <%= user.getUsertype() %></p>
                        <% 
                            }
                        %>
                        <div class="mt-3 text-center">
                            <a href="MainLogin.jsp" class="btn btn-primary">Go to Login</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
