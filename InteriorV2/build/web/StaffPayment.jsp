<%@ include file="StaffHeader.jsp" %>

<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Payment Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>
    <div class="card mb-3">
        <div class="card-header">Payment List</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Payment" onkeyup="searchPayments()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
                <div class="d-flex">
                    <div class="input-group" style="width: 200px;">
                        <select id="amountFilter" class="form-select" onchange="filterPayments()">
                            <option value="">All Amounts</option>
                            <option value="lt1000">Less than 1000</option>
                            <option value="btw1000to5000">Between 1000 to 5000</option>
                            <option value="gt5000">More than 5000</option>
                        </select>
                    </div>
                </div>
            </div>

            <sql:query var="payment_list" dataSource="${myDatasource}">
                SELECT PAYMENT.paymentID, BILL.billID, STUDENT.stdName, STUDENT.stdaddress, STUDENT.stdphone, BILL.billType, BILL.totalAmount, PAYMENT.paymentDate
                FROM PAYMENT
                JOIN BILL ON PAYMENT.paymentID = BILL.paymentID
                JOIN STUDENT ON BILL.stdID = STUDENT.stdID
                ORDER BY PAYMENT.paymentID
            </sql:query>

            <table class="table" id="paymentTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Payment ID</th>
                        <th>Bill ID</th>
                        <th>Student Name</th>
                        <th>Amount</th>
                        <th>Payment Date</th>
                        <th>Receipt</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty payment_list.rows}">
                            <tr>
                                <td colspan="8">No payments available.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <% int count = 0; %>
                            <c:forEach var="payment" items="${payment_list.rows}">
                                <tr>
                                    <% count++; %>
                                    <td width="20px"><%= count %></td>
                                    <td>${payment.paymentID}</td>
                                    <td>${payment.billID}</td>
                                    <td>${payment.stdName}</td>
                                    <td>${payment.totalAmount}</td>
                                    <td>${payment.paymentDate}</td>
                                    <td><img src="rsc/images/pdf-icon.png" width="30px" height="30px"></td>
                                    <td width="150px">
                                        <a href="<%= request.getContextPath() %>/DownloadReceipt?paymentID=${payment.paymentID}&billID=${payment.billID}&amount=${payment.totalAmount}&paymentDate=${payment.paymentDate}&fullName=${payment.stdName}&address=${payment.stdaddress}&phoneNo=${payment.stdphone}&billType=${payment.billType}" class="btn btn-sm btn-view" data-bs-toggle="tooltip" title="Download"><i class="fas fa-download"></i></a>
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

<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#paymentTable tbody tr");

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

    function searchPayments() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterPayments(input);
    }

    function filterPayments(input = '') {
        const amountFilter = document.getElementById('amountFilter').value;

        const rows = document.querySelectorAll('#paymentTable tbody tr');
        rows.forEach(row => {
            const amount = parseFloat(row.querySelector('td:nth-child(5)').textContent);
            const studentName = row.querySelector('td:nth-child(4)').textContent.toLowerCase();

            const matchesSearch = studentName.includes(input);
            let matchesAmount = true;

            if (amountFilter === 'lt1000') {
                matchesAmount = amount < 1000;
            } else if (amountFilter === 'btw1000to5000') {
                matchesAmount = amount >= 1000 && amount <= 5000;
            } else if (amountFilter === 'gt5000') {
                matchesAmount = amount > 5000;
            }

            if (matchesSearch && matchesAmount) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
