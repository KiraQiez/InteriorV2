<%@ include file="StudentHeader.jsp" %>
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

    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) {%>
    <div class="alert <%= message.contains("success") ? "alert-success" : "alert-danger"%>" role="alert">
        <%= message%>
    </div>
    <% } %>

    <div class="card mb-3">
        <div class="card-header">My Bills</div>
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <div class="input-group" style="width: 300px;">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search Bill ID" onkeyup="searchBills()">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                </div>
                <div class="d-flex">
                    <div class="input-group me-2" style="width: 200px;">
                        <select id="statusFilter" class="form-select" onchange="filterBills()">
                            <option value="">All Status</option>
                            <option value="Unpaid">Unpaid</option>
                            <option value="Paid">Paid</option>
                        </select>
                    </div>
                </div>
            </div>

            <sql:query var="bill_list" dataSource="${myDatasource}">
                SELECT BILL.billID, BILL.billType, BILL.totalAmount, BILL.paymentID, STUDENT.stdName 
                FROM BILL
                JOIN STUDENT ON BILL.stdID = STUDENT.stdID
                WHERE BILL.stdID = ?
                ORDER BY BILL.billID DESC
                <sql:param value="${user.userid}" />
            </sql:query>

            <table class="table" id="billTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Bill ID</th>
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
                                    <% count++;%>
                                    <td width="20px"><%= count%></td>
                                    <td>${bill.billID}</td>
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
                                    <td>
                                        <c:if test="${bill.paymentID == null}">
                                            <button type="button" class="btn btn-sm btn-primary" onclick="openPaymentModal('${bill.billID}', '${bill.billType}', '${bill.totalAmount}')">Pay Bill</button>
                                        </c:if>
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

<!-- Payment Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="paymentModalLabel">Confirm Payment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="paymentForm" action="PaymentServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" id="modalBillID" name="billID">
                    <div class="mb-3">
                        <label for="modalBillType" class="form-label">Bill Type</label>
                        <input type="text" class="form-control" id="modalBillType" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="modalTotalAmount" class="form-label">Total Amount</label>
                        <input type="text" class="form-control" id="modalTotalAmount" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="paymentProof" class="form-label">Upload Payment Proof</label>
                        <input type="file" class="form-control" id="paymentProof" name="paymentProof" accept="image/*" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Confirm Payment</button>
                </form>
            </div>
        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js" integrity="sha384-eMN2JSg6EGcEGNdbt9H1DNWrPnnQ4lch2LkZbCxnH6DO0P2KUg+4WZyy8c+gPb0E" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12W8cFJF6F2nqToz8+Zf6Q8tMpoALewrNJ7CejL+dXGq1kcz" crossorigin="anonymous"></script>
<script>
    let current_page = 1;
    const records_per_page = 10;
    const rows = document.querySelectorAll("#billTable tbody tr");

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

    function searchBills() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        filterBills(input);
    }

    function filterBills(input = '') {
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();

        const rows = document.querySelectorAll('#billTable tbody tr');
        rows.forEach(row => {
            const billID = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const billStatus = row.querySelector('td:nth-child(5) .badge').textContent.toLowerCase();

            const matchesSearch = billID.includes(input);
            const matchesStatus = statusFilter === '' || billStatus === statusFilter;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function openPaymentModal(billID, billType, totalAmount) {
        document.getElementById('modalBillID').value = billID;
        document.getElementById('modalBillType').value = billType;
        document.getElementById('modalTotalAmount').value = totalAmount;
        const paymentModal = new bootstrap.Modal(document.getElementById('paymentModal'));
        paymentModal.show();
    }
</script>
