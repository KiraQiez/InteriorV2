<%@ include file="StudentHeader.jsp" %>
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Homepage</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card mb-3">
                <div class="card-header">Welcome, <c:out value="${user.username}" />!</div>
                <div class="card-body">
                    <p>This is your student homepage where you can manage your profile, room, and bill payments.</p>
                    <p>Feel free to explore the options in the sidebar to view your profile, room details, bookings, and bill payments.</p>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Your Room</h5>
                                </div>
                                <div class="card-body">
                                    <p>Click the button below to view your room details, including your current room assignment and booking history.</p>
                                    <a href="StudentRoom.jsp" class="btn btn-primary">View Room Details</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Your Profile</h5>
                                </div>
                                <div class="card-body">
                                    <p>Click the button below to view and edit your profile information, including your personal details and contact information.</p>
                                    <a href="StudentProfile.jsp" class="btn btn-primary">View and Edit Profile</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card mb-3">
                <div class="card-header">Recent Unpaid Bills</div>
                <div class="card-body">
                    <sql:query var="unpaidBills" dataSource="${myDatasource}">
                        SELECT billID, paymentID 
                        FROM BILL 
                        WHERE stdID = ? AND paymentID IS NULL
                        FETCH FIRST 5 ROWS ONLY
                        <sql:param value="${user.userid}" />
                    </sql:query>
                    <c:choose>
                        <c:when test="${empty unpaidBills.rows}">
                            <p>No unpaid bills.</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="list-group">
                                <c:forEach var="bill" items="${unpaidBills.rows}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Bill ID: ${bill.billID}
                                        <c:choose>
                                            <c:when test="${bill.paymentID == null}">
                                                <span class="badge bg-danger">Unpaid</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">Paid</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>
</div>
</div>
</body>
</html>
