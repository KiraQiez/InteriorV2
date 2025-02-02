<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:useBean id="user" scope="session" class="com.interior.model.User" />
<jsp:useBean id="staff" scope="session" class="com.interior.model.Staff" />

<%
    // Redirect to main login if user is not staff
    if (session.getAttribute("user") == null || !"Staff".equals(((com.interior.model.User) session.getAttribute("user")).getUsertype())) {
        response.sendRedirect("MainLogin.jsp?message=You are not authorized to access this page.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interior Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="rsc/styles.css">
    <link rel="stylesheet" href="rsc/staff.css">
</head>
<body>
    
    <sql:setDataSource var="myDatasource" driver="org.apache.derby.jdbc.ClientDriver"
                       url="jdbc:derby://localhost:1527/InteriorDB" user="root" password="root" />
     
    <script>
        function printPage() {
            window.print();
        }
    </script>
    <div class="container-fluid">
        <div class="row">
            <!-- Header -->
            <nav class="navbar navbar-expand-lg navbar-light bg-light d-md-block col-md-12">
                <div class="container-fluid">
                    <div class="logo d-flex align-items-center col-md-2">
                        <img src="rsc/images/logo.svg" alt="logo" width="50" height="50">
                        <h2 class="ms-3">INTERIOR</h2>
                    </div>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav ms-auto d-flex align-items-center">
                            <li class="nav-item me-1">
                                <a class="nav-link d-flex align-items-center" href="#">
                                    <img src="rsc/images/flag-icon.png" alt="Flag" width="25" height="20" class="me-2">English
                                </a>
                            </li>
                            <li class="nav-item me-1">
                                <a class="nav-link" href="#"><i class="fas fa-bell"></i></a>
                            </li>
                            <li class="nav-item me-1">
                                <a class="nav-link" href="#"><i class="fas fa-envelope"></i></a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="profileDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <img src="rsc/images/profilePic.png" class="rounded-circle me-2" alt="Profile" width="40" height="40">
                                    <c:out value="${user.username}" />
                                    <i class="fas fa-ellipsis-v ms-2"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                                    <li><a class="dropdown-item" href="LogoutServlet">Logout</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Sidebar -->
            <nav class="sidebar col-md-2 d-none d-md-block bg-light">
                <div class="profile mb-3 text-center">
                    <img src="rsc/images/profilePic.png" alt="Profile">
                    <div class="profile-info mt-2">
                        <h4>
                            <c:out value="${user.username}" />
                        </h4>
                        <c:out value="${staff.staffType}" />
                    </div>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a href="StaffHomepage.jsp" class="nav-link"><i class="fas fa-home"></i>Home</a>
                    </li>
                    <li class="nav-item">
                        <a href="#studentSubMenu" class="nav-link d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button"
                           aria-expanded="false" aria-controls="studentSubMenu">
                            <div><i class="fas fa-user-graduate"></i>Student</div>
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <ul class="nav flex-column collapse submenu" id="studentSubMenu" >
                            <li class="nav-item">
                                <a href="StaffStudent.jsp" class="nav-link"><i class="fas fa-list-ul"></i>Student List</a>
                            </li>
                            <li class="nav-item">
                                <a href="StaffBill.jsp" class="nav-link"><i class="fas fa-file"></i>Student Bill</a>
                            </li>
                            <li class="nav-item">
                                <a href="StaffPayment.jsp" class="nav-link"><i class="fas fa-credit-card"></i>Payment</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a href="#roomSubMenu" class="nav-link d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button"
                           aria-expanded="false" aria-controls="roomSubMenu">
                            <div><i class="fas fa-bed"></i>Room</div>
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <ul class="nav flex-column collapse submenu" id="roomSubMenu" >
                            <li class="nav-item">
                                <a href="StaffRoom.jsp" class="nav-link"><i class="fas fa-list-ul"></i>Room List</a>
                            </li>
                            <li class="nav-item">
                                <a href="StaffBooking.jsp" class="nav-link"><i class="fas fa-book"></i>Bookings</a>
                            </li>
                            <li class="nav-item">
                                <a href="StaffReport.jsp" class="nav-link"><i class="fas fa-flag"></i>Reports</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav-item">
                         <a href="StaffBlock.jsp" class="nav-link"><i class="fas fa-square"></i>Block</a>
                    </li>
               
                    <li class="nav-item">
                         <a href="StaffSession.jsp" class="nav-link"><i class="fas fa-calendar"></i>Session</a>
                    </li>
                    <li class="nav-item">
                        <a href="StaffStaff.jsp" class="nav-link"><i class="fas fa-chalkboard-teacher"></i>Staff</a>
                    </li>
                </ul>
            </nav>
   
