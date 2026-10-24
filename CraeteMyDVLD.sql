

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ( Create Database )
---------------------------------------------------------------------------------------------------------------------------------------------------------------

--  DVLD
CREATE DATABASE DVLD;
GO

USE DVLD;
GO

-- 1. (Countries)
CREATE TABLE Countries (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName NVARCHAR(30) NOT NULL
);
GO

-- 2. (People) - NULL for (ThirdName, Email, ImagePath)
CREATE TABLE People (
    PersonID INT IDENTITY(1,1) PRIMARY KEY,
    NationalID NVARCHAR(20) NOT NULL,
    FirstName NVARCHAR(20) NOT NULL,
    SecondName NVARCHAR(20) NOT NULL,
    ThirdName NVARCHAR(20) NULL,
    LastName NVARCHAR(20) NOT NULL,
    DateOfBirth DATETIME NOT NULL,
    Gendor TINYINT NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(50) NULL,
    NationalityCountryID INT NOT NULL FOREIGN KEY REFERENCES Countries(CountryID),
    ImagePath NVARCHAR(250) NULL
);
GO

-- 3. (Users)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    PersonID INT NOT NULL FOREIGN KEY REFERENCES People(PersonID),
    UserName NVARCHAR(50) NOT NULL,
    Password NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL
);
GO

-- 4. (Drivers)
CREATE TABLE Drivers (
    DriverID INT IDENTITY(1,1) PRIMARY KEY,
    PersonID INT NOT NULL FOREIGN KEY REFERENCES People(PersonID),
    CreatedByUserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    CreatedDate DATETIME NOT NULL
);
GO

-- 5. (ApplicationTypes)
CREATE TABLE ApplicationTypes (
    ApplicationTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationTypeTitle NVARCHAR(150) NOT NULL,
    ApplicationFees SMALLMONEY NOT NULL
);
GO

-- 6. (Applications)
CREATE TABLE Applications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationPersonID INT NOT NULL FOREIGN KEY REFERENCES People(PersonID),
    ApplicationDate DATETIME NOT NULL,
    ApplicationTypeID INT NOT NULL FOREIGN KEY REFERENCES ApplicationTypes(ApplicationTypeID),
    ApplicationStatus TINYINT NOT NULL,
    LastStatusDate DATETIME NOT NULL,
    PaidFees SMALLMONEY NOT NULL,
    CreatedByUserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID)
);
GO

-- 7. (LicenseClasses)
CREATE TABLE LicenseClasses (
    LicenseClassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassName NVARCHAR(50) NOT NULL,
    ClassDescription NVARCHAR(500) NOT NULL,
    MinimumAllowedAge INT NOT NULL,
    DefaultValidityLength INT NOT NULL,
    ClassFees SMALLMONEY NOT NULL
);
GO

-- 8. (LocalDrivingLicenseApplications)
CREATE TABLE LocalDrivingLicenseApplications (
    LocalDrivingLicenseApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationID INT NOT NULL FOREIGN KEY REFERENCES Applications(ApplicationID),
    LicenseClassID INT NOT NULL FOREIGN KEY REFERENCES LicenseClasses(LicenseClassID)
);
GO

-- 9. (TestTypes)
CREATE TABLE TestTypes (
    TestTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TestTypeTitle NVARCHAR(100) NOT NULL,
    TestTypeDescription NVARCHAR(500) NOT NULL,
    TestTypeFees SMALLMONEY NOT NULL
);
GO

-- 10. (TestAppointments) - RetakeTestApplicationID allow NULL
CREATE TABLE TestAppointments (
    TestAppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    TestTypeID INT NOT NULL FOREIGN KEY REFERENCES TestTypes(TestTypeID),
    LocalDrivingLicenseApplicationID INT NOT NULL FOREIGN KEY REFERENCES LocalDrivingLicenseApplications(LocalDrivingLicenseApplicationID),
    AppointmentDate DATETIME NOT NULL,
    PaidFees SMALLMONEY NOT NULL,
    CreatedByUserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    IsLocked BIT NOT NULL,
    RetakeTestApplicationID INT NULL FOREIGN KEY REFERENCES Applications(ApplicationID)
);
GO

-- 11. (Tests) - Notes allow NULL
CREATE TABLE Tests (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    TestAppointmentID INT NOT NULL FOREIGN KEY REFERENCES TestAppointments(TestAppointmentID),
    TestResult BIT NOT NULL,
    Notes NVARCHAR(500) NULL,
    CreatedByUserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID)
);
GO

-- 12. (Licenses) -  Notes allow NULL
CREATE TABLE Licenses (
    LicenseID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationID INT NOT NULL FOREIGN KEY REFERENCES Applications(ApplicationID),
    DriverID INT NOT NULL FOREIGN KEY REFERENCES Drivers(DriverID),
    LicenseClassID INT NOT NULL FOREIGN KEY REFERENCES LicenseClasses(LicenseClassID),
    IssueDate DATETIME NOT NULL,
    ExpirationDate DATETIME NOT NULL,
    Notes NVARCHAR(500) NULL,
    PaidFees SMALLMONEY NOT NULL,
    IsActive BIT NOT NULL,
    IssueReason TINYINT NOT NULL,
    CreatedByUserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID)
);
GO

-- 13. (InternationalLicenses)
CREATE TABLE InternationalLicenses (
    InternationalLicenseID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationID INT NOT NULL FOREIGN KEY REFERENCES Applications(ApplicationID),
    DriverID INT NOT NULL FOREIGN KEY REFERENCES Drivers(DriverID),
    IssuedUsingLocalLicenseID INT NOT NULL FOREIGN KEY REFERENCES Licenses(LicenseID),
    IssueDate DATETIME NOT NULL,
    ExpirationDate DATETIME NOT NULL,
    IsActive BIT NOT NULL,
    CreatedByUserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID)
);
GO

-- 14. (DetainedLicenses) - ReleaseDate و ReleasedByUserID و ReleaseApplicationID allow NULL
CREATE TABLE DetainedLicenses (
    DetainedLicenseID INT IDENTITY(1,1) PRIMARY KEY,
    LicenseID INT NOT NULL FOREIGN KEY REFERENCES Licenses(LicenseID),
    DetainDate DATETIME NOT NULL,
    FineFees SMALLMONEY NOT NULL,
    CreatedByUserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    IsReleased BIT NOT NULL,
    ReleaseDate DATETIME NULL,
    ReleasedByUserID INT NULL FOREIGN KEY REFERENCES Users(UserID),
    ReleaseApplicationID INT NULL FOREIGN KEY REFERENCES Applications(ApplicationID)
);
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ( ...... )
---------------------------------------------------------------------------------------------------------------------------------------------------------------


