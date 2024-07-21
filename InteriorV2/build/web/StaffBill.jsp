<%@ include file="StaffHeader.jsp" %>

<!-- Main Content -->
            <main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Bill Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                        </div>
                    </div>
                </div>
                <div class="card mb-3">
                    <div class="card-header">Bill List</div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-3">
                           
                            <div class="input-group" style="width: 300px;">
                                <input type="text" id="searchInput" class="form-control" placeholder="Search Bill" onkeyup="searchBills()">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                            </div>
                            
                            <div class="d-flex ">
                            <div class="input-group me-3" style="width: 200px;">
                                <select id="statusFilter" class="form-select" onchange="filterBills()">
                                    <option value="">All Status</option>
                                    <option value="Paid">Paid</option>
                                    <option value="Unpaid">Unpaid</option>
                                </select>
                            </div>
                            <div class="input-group" style="width: 200px;">
                                <select id="typeFilter" class="form-select" onchange="filterBills()">
                                    <option value="">All Types</option>
                                    
                                    <option value="Hostel">Hostel</option>
                                    <option value="Tuition">Tuition</option>
                                    <option value="Miscellaneous">Miscellaneous</option>
                                </select>
                            </div>
                            </div>
                        </div>

                        <sql:query var="bill_list" dataSource="${myDatasource}">
                            SELECT BILL.billID, BILL.billType, STUDENT.stdName, BILL.paymentID, BILL.totalAmount
                            FROM BILL
                            JOIN STUDENT ON BILL.stdID = STUDENT.stdID
                            ORDER BY BILL.billID
                        </sql:query>

                        <table class="table" id="billTable">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Bill ID</th>
                                    <th>Student Name</th>
                                    <th>Bill Type</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty bill_list.rows}">
                                        <tr>
                                            <td colspan="6">No bills available.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <% int count = 0; %>
                                        <c:forEach var="bill" items="${bill_list.rows}">
                                            <tr>
                                                <% count++; %>
                                                <td width="20px"><%= count %></td>
                                                <td>${bill.billID}</td>
                                                <td>${bill.stdName}</td>
                                                <td>${bill.billType}</td>
                                                <td>${bill.totalAmount}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${bill.paymentID == null}">
                                                            <span class="badge bg-danger">Unpaid</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success">Paid</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
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
        const rows = document.querySelectorAll("#billTable tbody tr");

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

        function searchBills() {
            const input = document.getElementById('searchInput').value.toLowerCase();
            filterBills(input);
        }

        function filterBills(input = '') {
            const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
            const typeFilter = document.getElementById('typeFilter').value.toLowerCase();

            const rows = document.querySelectorAll('#billTable tbody tr');
            rows.forEach(row => {
                const billType = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                const billStatus = row.querySelector('td:nth-child(5) .badge').textContent.toLowerCase();
                const studentName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();

                const matchesSearch = studentName.includes(input);
                const matchesStatus = statusFilter === '' || billStatus === statusFilter;
                const matchesType = typeFilter === '' || billType === typeFilter;

                if (matchesSearch && matchesStatus && matchesType) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>