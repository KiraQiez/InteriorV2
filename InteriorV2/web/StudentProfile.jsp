<%@ include file="StudentHeader.jsp" %>
<!-- Main Content -->
<main class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Profile Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printPage()">Share</button>
                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
            </div>
        </div>
    </div>
    <div class="card mb-3">
        <div class="card-header">My Profile</div>
        <div class="card-body">
            <h4>Student Profile</h4>
            <p>Here you can view your profile and other information</p>
            <div class="row">
                <div class="col-md-4">
                    <div class="card mb-3 ">
                        <div class="card-header">Profile Picture</div>
                        <div class="card-body text-center">
                            <img src="rsc/images/profilePic.png" alt="Profile Picture" class="profile-img">
                            <h4 class="mt-3">Hafizah</h4>
                            <p>hafizah@student.uitm.edu.my</p>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#changePictureModal">Change Picture</button>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">Edit Profile</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="card mb-3">
                        <div class="card-header">Personal Information</div>
                        <div class="card-body student-info">
                            <p><strong>Name:</strong> Hafizah</p>
                            <p><strong>Matric Number:</strong> 2020123456</p>
                            <p><strong>Date of Birth:</strong> 01/01/2000</p>
                            <p><strong>Race:</strong> Malay</p>
                            <p><strong>Phone Number:</strong> 012-3456789</p>
                            <p><strong>Address:</strong> 123, Jalan Example, 45678 City, Country</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
</div>
</div>
</body>
</html>
