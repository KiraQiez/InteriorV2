<%@ include file="StaffHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Room Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>

    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) {%>
    <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger"%>" role="alert">
        <%= message%>
    </div>
    <% } %>

    <div class="card mb-3">
        <div class="card-header">Report List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">

                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Report" onkeyup="searchReport()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
                <div class="input-group" style="width: 300px;">
                    <select id="statusFilter" class="form-select" onchange="filterReport()">
                        <option value="">All Status</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="REJECTED">Rejected</option>
                        <option value="PENDING">Pending</option>
                    </select>
                </div>
            </div>

            <sql:query var="report_list" dataSource="${myDatasource}">
                SELECT * FROM REPORT R 
                JOIN STUDENT ST ON ST.STDID = R.STUDENTID
                ORDER BY reportID 
            </sql:query>

            <table class="table" id="reportTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Report ID</th>
                        <th>Reported by</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty report_list.rows}">
                            <tr>
                                <td colspan="5">No report available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="report" items="${report_list.rows}">
                                <tr>
                                    <% count++;%>
                                    <td width="20px"><%= count%></td>
                                    <td>${report.reportID}</td>
                                    <td>${report.stdName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.reportStatus == 'COMPLETED'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:when test="${report.reportStatus == 'REJECTED'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:when test="${report.reportStatus == 'PENDING'}">
                                                <span class="badge bg-warning">Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-edit" data-bs-toggle="modal" data-bs-target="#viewReportModal" 
                                                data-id="${report.reportID}" data-title="${report.reportTitle}" data-desc="${report.reportDesc}" 
                                                data-status="${report.reportStatus}" data-std-id="${report.studentID}" data-bs-toggle="tooltip" title="View">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="tooltip" title="View"><i class="fas fa-eye"></i></button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <nav aria-label="Page navigation example">
                <ul class="pagination justify-content-center" id="pagination"></ul>
            </nav>
        </div>
        
        <!-- Modal -->
        <div class="modal fade" id="viewReportModal" tabindex="-1" aria-labelledby="viewReportModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewReportModalLabel">View Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="ReportChangeStatusServlet" method="POST">
                            <input type="hidden" class="form-control" id="stdID" name="stdID">
                            <div class="mb-3">
                                <label for="reportID" class="form-label">Report ID</label>
                                <input type="text" class="form-control" id="reportID" name="reportID" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="reportTitle" class="form-label">Report Title</label>
                                <input type="text" class="form-control" id="reportTitle" name="reportTitle" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="reportDesc" class="form-label">Report Description</label>
                                <textarea class="form-control" id="reportDesc" name="reportDesc" rows="3" readonly></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="reportStatus" class="form-label">Report Status</label>
                                <select class="form-select" id="reportStatus" name="reportStatus">
                                    <option value="COMPLETED">Completed</option>
                                    <option value="REJECTED">Rejected</option>
                                    <option value="PENDING">Pending</option>
                                </select>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <input type="submit" class="btn btn-primary" value="Save changes">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
</main>
</div>
</div>

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#reportTable tbody tr");

    function changePage(page) {
        const pagination = document.getElementById("pagination");
        if (page < 1)
            page = 1;
        if (page > numPages())
            page = numPages();

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

    window.onload = function () {
        changePage(1);
    };

    function searchReport() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterStudents(input);
    }

    function filterReport(input = '') {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#reportTable tbody tr');
        rows.forEach(row => {
            const reportID = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const reportStatus = row.querySelector('td:nth-child(4) .badge').textContent.toLowerCase();

            const matchesSearch = reportID.includes(input);
            const matchesStatus = statusFilter === '' || reportStatus === statusFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // View Report Modal
    var viewReportModal = document.getElementById('viewReportModal');
    viewReportModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget; // Button that triggered the modal
        var reportID = button.getAttribute('data-id');
        var reportTitle = button.getAttribute('data-title');
        var reportDesc = button.getAttribute('data-desc');
        var reportStatus = button.getAttribute('data-status');
        var stdID = button.getAttribute('data-std-id');

        var modalID = viewReportModal.querySelector('#reportID');
        var modalTitle = viewReportModal.querySelector('#reportTitle');
        var modalDesc = viewReportModal.querySelector('#reportDesc');
        var modalStatus = viewReportModal.querySelector('#reportStatus');
        var modalStdID = viewReportModal.querySelector('#stdID');

        modalID.value = reportID;
        modalTitle.value = reportTitle;
        modalDesc.value = reportDesc;
        modalStatus.value = reportStatus;
        modalStdID.value = stdID;
    });
</script>
</body>
</html>