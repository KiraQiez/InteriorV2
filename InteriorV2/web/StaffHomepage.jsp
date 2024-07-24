<%@ include file="StaffHeader.jsp" %>
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

    <%-- Fetch Data for Summary Cards --%>
    <sql:query var="totalStudents" dataSource="${myDatasource}">
        SELECT COUNT(*) AS total FROM STUDENT
    </sql:query>
    <sql:query var="totalRegistrations" dataSource="${myDatasource}">
        SELECT COUNT(*) AS total FROM BOOKING
    </sql:query>
    <sql:query var="totalStaff" dataSource="${myDatasource}">
        SELECT COUNT(*) AS total FROM STAFF
    </sql:query>
    <sql:query var="feesCollection" dataSource="${myDatasource}">
        SELECT SUM(totalAmount) AS total FROM BILL
    </sql:query>

    <%-- Display Summary Cards --%>
    <div class="row">
        <div class="col-md-3">
            <div class="card text-white bg-success mb-3">
                <div class="card-header d-flex align-items-center">
                    <i class="fas fa-user-graduate me-2"></i>Total Students
                </div>
                <div class="card-body">
                    <h5 class="card-title">${totalStudents.rows[0].total}</h5>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-warning mb-3">
                <div class="card-header d-flex align-items-center">
                    <i class="fas fa-file-signature me-2"></i>Total Registration
                </div>
                <div class="card-body">
                    <h5 class="card-title">${totalRegistrations.rows[0].total}</h5>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-info mb-3">
                <div class="card-header d-flex align-items-center">
                    <i class="fas fa-users me-2"></i>Total Staff
                </div>
                <div class="card-body">
                    <h5 class="card-title">${totalStaff.rows[0].total}</h5>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-danger mb-3">
                <div class="card-header d-flex align-items-center">
                    <i class="fas fa-dollar-sign me-2"></i>Fees Collection
                </div>
                <div class="card-body">
                    <h5 class="card-title">$${feesCollection.rows[0].total}</h5>
                </div>
            </div>
        </div>
    </div>

    <%-- Fetch and Display Newest Reports --%>
    <sql:query var="newestReports" dataSource="${myDatasource}">
        SELECT R.reportTitle, R.reportStatus 
        FROM REPORT R 
        ORDER BY R.reportID DESC FETCH FIRST 5 ROWS ONLY
    </sql:query>

    <%-- Fetch and Display Reports Chart --%>
    <sql:query var="reportStats" dataSource="${myDatasource}">
        SELECT reportStatus, COUNT(*) AS count FROM REPORT GROUP BY reportStatus
    </sql:query>

    <div class="row">
        <div class="col-md-9">
            <div class="card">
                <div class="card-header">Reports Overview</div>
                <div class="card-body">
                    <canvas id="reportsChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card mb-3">
                <div class="card-header">Newest Reports</div>
                <div class="card-body">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${newestReports.rows}">
                                <tr>
                                    <td>${report.reportTitle}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.reportStatus == 'Completed'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:when test="${report.reportStatus == 'Pending'}">
                                                <span class="badge bg-warning">Pending</span>
                                            </c:when>
                                            <c:when test="${report.reportStatus == 'Rejected'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const ctx = document.getElementById('reportsChart').getContext('2d');
        const reportStatsData = {
           
        const reportsChart = new Chart(ctx, {
            type: 'pie',
            data: reportStatsData,
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.raw !== null) {
                                    label += context.raw;
                                }
                                return label;
                            }
                        }
                    }
                }
            }
        });
    });
</script>
</body>
</html>
