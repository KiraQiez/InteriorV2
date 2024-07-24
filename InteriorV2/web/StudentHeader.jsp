<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:useBean id="user" scope="session" class="com.interior.model.User" />

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
    <link rel="stylesheet" href="rsc/student.css">
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
                                    <img src="rsc/images/flag-icon.png" alt="Flag" width="25" height="20"
                                        class="me-2">English
                                </a>
                            </li>
                            <li class="nav-item me-1">
                                <a class="nav-link" href="#"><i class="fas fa-bell"></i></a>
                            </li>
                            <li class="nav-item me-1">
                                <a class="nav-link" href="#"><i class="fas fa-envelope"></i></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link d-flex align-items-center" href="#">
                                    <img src="rsc/images/profilePic.png" class="rounded-circle me-2" alt="Profile"
                                        width="40" height="40">
                                        <c:out value="${user.username}" />
                                    <i class="fas fa-ellipsis-v ms-2"></i>
                                </a>
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
                        <p>Student</p>
                    </div>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a href="StudentHomepage.jsp" class="nav-link"><i class="fas fa-home"></i>Home</a>
                    </li>
                    <li class="nav-item">
                        <a href="StudentProfile.jsp" class="nav-link"><i class="fas fa-user-graduate"></i>My Profile</a>
                    </li>
                    <li class="nav-item">
                        <a href="#roomSubMenu" class="nav-link d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button"
                           aria-expanded="false" aria-controls="roomSubMenu">
                            <div><i class="fas fa-bed"></i>Room</div>
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <ul class="nav flex-column collapse submenu" id="roomSubMenu" >
                            <li class="nav-item">
                                <a href="StudentRoom.jsp" class="nav-link"><i class="fas fa-list-ul"></i>My Room</a>
                            </li>
                            <li class="nav-item">
                                <a href="StudentBooking.jsp" class="nav-link"><i class="fas fa-book"></i>Bookings</a>
                            </li>
                            <li class="nav-item">
                                <a href="StudentReport.jsp" class="nav-link"><i class="fas fa-flag"></i>Reports</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a href="#billSubMenu" class="nav-link d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button"
                           aria-expanded="false" aria-controls="billSubMenu">
                            <div><i class="fas fa-file-invoice-dollar"></i>Bill Payment</div>
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <ul class="nav flex-column collapse submenu" id="billSubMenu" >
                            <li class="nav-item">
                                <a href="StudentBill.jsp" class="nav-link"><i class="fas fa-list-ul"></i>My Bill</a>
                            </li>
                            <li class="nav-item">
                                <a href="StudentPayment.jsp" class="nav-link"><i class="fas fa-dollar-sign"></i>Payment</a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </nav>
