<%@ include file="StudentHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Report Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>
    
    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) { %>
        <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger" %>" role="alert">
            <%= message %>
        </div>
    <% } %>
    
    <div class="card mb-3">
        <div class="card-header">My Reports</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addReportModal">Add Report</button>
                <div class="d-flex">
                    <div class="input-group me-2" style="width: 200px;">
                        <select id="statusFilter" class="form-select" onchange="filterReports()">
                            <option value="">All Status</option>
                            <option value="Pending">Pending</option>
                            <option value="Handled">Handled</option>
                            <option value="Checked">Checked</option>
                        </select>
                    </div>
                    <div class="input-group" style="width: 300px;">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search Report ID" onkeyup="searchReports()">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                    </div>
                </div>
            </div>

            <sql:query var="report_list" dataSource="${myDatasource}">
                SELECT REPORT.reportID, REPORT.reportTitle, REPORT.reportDesc, REPORT.reportStatus, STUDENT.stdName 
                FROM REPORT
                JOIN STUDENT ON REPORT.studentID = STUDENT.stdID
                WHERE REPORT.studentID = ?
                ORDER BY REPORT.reportID DESC
                <sql:param value="${user.userid}" />
            </sql:query>

            <table class="table" id="reportTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Report ID</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Student Name</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty report_list.rows}">
                            <tr>
                                <td colspan="6">No reports available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="report" items="${report_list.rows}">
                                <tr>
                                    <% count++; %>
                                    <td width="20px"><%= count %></td>
                                    <td>${report.reportID}</td>
                                    <td>${report.reportTitle}</td>
                                    <td>${report.reportDesc}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.reportStatus == 'Pending'}">
                                                <span class="badge bg-warning">Pending</span>
                                            </c:when>
                                            <c:when test="${report.reportStatus == 'Handled'}">
                                                <span class="badge bg-info">Handled</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">Checked</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${report.stdName}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Add Report Modal -->
    <div class="modal fade" id="addReportModal" tabindex="-1" aria-labelledby="addReportModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addReportModalLabel">Add Report</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="AddReportServlet" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="reportTitle" class="form-label">Report Title</label>
                            <input type="text" class="form-control" id="reportTitle" name="reportTitle" required>
                        </div>
                        <div class="mb-3">
                            <label for="reportDesc" class="form-label">Report Description</label>
                            <textarea class="form-control" id="reportDesc" name="reportDesc" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save Report</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>
</div>
</div>
</body>
</html>

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#reportTable tbody tr");

    function changePage(page) {
        const pagination = document.getElementById("pagination");
        if (page < 1) page = 1;
        if (page > numPages()) page = numPages();

        pagination.innerHTML = "";

        for (let i = 0; i < rows.length; i++) {
            rows[i].style.display = "none";
        }

        for (let i = (page - 1) * records_per_page; i < (page * records_per_page) && i < rows.length; i++) {
            rows[i].style.display = "";
        }

        if (page === 1) {
            pagination.innerHTML += '<li class="page-item disabled"><a class="page-link" href="javascript:prevPage();">Previous</a></li>';
        } else {
            pagination.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:prevPage();">Previous</a></li>';
        }

        for (let i = 1; i <= numPages(); i++) {
            if (i === page) {
                pagination.innerHTML += '<li class="page-item active"><a class="page-link" href="javascript:changePage(' + i + ');">' + i + '</a></li>';
            } else {
                pagination.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:changePage(' + i + ');">' + i + '</a></li>';
            }
        }

        if (page === numPages()) {
            pagination.innerHTML += '<li class="page-item disabled"><a class="page-link" href="javascript:nextPage();">Next</a></li>';
        } else {
            pagination.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:nextPage();">Next</a></li>';
        }
    }

    function numPages() {
        return Math.ceil(rows.length / records_per_page);
    }

    function prevPage() {
        if (current_page > 1) {
            current_page--;
            changePage(current_page);
        }
    }

    function nextPage() {
        if (current_page < numPages()) {
            current_page++;
            changePage(current_page);
        }
    }

    window.onload = function() {
        changePage(1);
    };

    function searchReports() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterReports(input);
    }

    function filterReports(input = '') {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#reportTable tbody tr');
        rows.forEach(row => {
            const reportID = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const reportStatus = row.querySelector('td:nth-child(5) .badge').textContent.toLowerCase();

            const matchesSearch = reportID.includes(input);
            const matchesStatus = statusFilter === '' || reportStatus === statusFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
