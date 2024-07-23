<%@ include file="StaffHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Staff Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>
    <div class="card mb-3">
        <div class="card-header">Staff List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">

                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Staff" onkeyup="searchStaff()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
                <div class="input-group" style="width: 300px;">
                    <sql:query var="staff_list" dataSource="${myDatasource}">
                        SELECT DISTINCT staffType FROM STAFF
                    </sql:query>
                    <select id="staffFilter" class="form-select" onchange="filterStaff()">
                        <option value="">All Staff</option>
                        <c:forEach var="staff" items="${staff_list.rows}">
                            <option value="${staff.staffType}">${staff.staffType}</option>
                        </c:forEach>
                    </select>
                </div>

            </div>

            <sql:query var="staff_list" dataSource="${myDatasource}">
                SELECT * FROM STAFF ORDER BY staffID
            </sql:query>

            <table class="table" id="staffTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Staff ID</th>
                        <th>Full Name</th>
                        <th>Type</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty staff_list.rows}">
                            <tr>
                                <td colspan="5">No staff available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="staff" items="${staff_list.rows}">
                                <tr>
                                    <% count++; %>
                                    <td width="20px"><%= count %></td>
                                    <td>${staff.staffID}</td>
                                    <td>${staff.staffName}</td>
                                    <td>${staff.staffType}</td>
                                    <td width="150px">
                                        <button type="button" class="btn btn-sm btn-view" data-bs-toggle="tooltip" title="View"><i class="fas fa-eye"></i></button>
                                        <button type="button" class="btn btn-sm btn-edit ms-1" data-bs-toggle="tooltip" title="Edit"><i class="fas fa-edit"></i></button>
                                        <button type="button" class="btn btn-sm btn-delete ms-1" data-bs-toggle="tooltip" title="Disable"><i class="fas fa-trash"></i></button>
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
    </div>
</main>
</div>
</div>

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#staffTable tbody tr");

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

    function searchStaff() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterStaff(input);
    }

    function filterStaff(input = '') {
        const staffFilter = document.getElementById('staffFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#staffTable tbody tr');
        rows.forEach(row => {
            const staffName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const staffType = row.querySelector('td:nth-child(4)').textContent.toLowerCase();

            const matchesSearch = staffName.includes(input);
            const matchesStatus = staffFilter === '' || staffType === staffFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>