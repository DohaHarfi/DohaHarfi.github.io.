-- Create Client Table
CREATE TABLE Client (
  ClientID INT NOT NULL AUTO_INCREMENT,
  LastName VARCHAR(55) NOT NULL,
  FirstName VARCHAR(55) NOT NULL,
  Address VARCHAR(55),
  PostalCode VARCHAR(55),
  City VARCHAR(55),
  Phone VARCHAR(55) UNIQUE,
  RegistrationDate DATE NOT NULL,
  AdditionalAddress VARCHAR(55),
  PRIMARY KEY (ClientID)
);

-- Create Employee Table
CREATE TABLE Employee (
  EmpID INT NOT NULL AUTO_INCREMENT,
  LastName VARCHAR(55) NOT NULL,
  FirstName VARCHAR(55) NOT NULL,
  Address VARCHAR(55),
  PostalCode VARCHAR(55),
  City VARCHAR(55),
  Email VARCHAR(55) UNIQUE,
  Phone VARCHAR(55) UNIQUE,
  Role VARCHAR(55) NOT NULL,
  PRIMARY KEY (EmpID)
);

-- Create Event Table
CREATE TABLE Event (
  EventID INT NOT NULL AUTO_INCREMENT,
  EventName VARCHAR(55) NOT NULL,
  EventLocation VARCHAR(55) NOT NULL,
  EventDate DATE NOT NULL,
  Program TEXT,
  EventTheme VARCHAR(55),
  ClientID INT,
  PRIMARY KEY (EventID),
  INDEX `fk_Event_Client_idx` (`ClientID` ASC) VISIBLE,
  CONSTRAINT `fk_Event_Client` FOREIGN KEY (`ClientID`) REFERENCES
  Client(ClientID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Create Provider Table
CREATE TABLE Provider (
  ProviderID INT NOT NULL AUTO_INCREMENT,
  LastName VARCHAR(55) NOT NULL,
  FirstName VARCHAR(55) NOT NULL,
  Address VARCHAR(55),
  PostalCode VARCHAR(55),
  City VARCHAR(55),
  Phone VARCHAR(55) UNIQUE,
  Email VARCHAR(55) UNIQUE,
  RegistrationDate DATE NOT NULL,
  PRIMARY KEY (ProviderID)
);

-- Create Invoice Table
CREATE TABLE Invoice (
  InvoiceID INT NOT NULL AUTO_INCREMENT,
  Amount DECIMAL NOT NULL,
  InvoiceDate DATE NOT NULL,
  ProviderID INT,
  ClientID INT NOT NULL,
  PRIMARY KEY (InvoiceID),
  INDEX `fk_Invoice_Provider_idx` (`ProviderID` ASC) VISIBLE,
  INDEX `fk_Invoice_Client_idx` (`ClientID` ASC) VISIBLE,
  CONSTRAINT `fk_Invoice_Provider` FOREIGN KEY (`ProviderID`) REFERENCES
  Provider(ProviderID) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Invoice_Client` FOREIGN KEY (`ClientID`) REFERENCES
  Client(ClientID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create Participant Table
CREATE TABLE Participant (
  ParticipantID INT PRIMARY KEY,
  LastName VARCHAR(55) NOT NULL,
  FirstName VARCHAR(55) NOT NULL,
  Address VARCHAR(55),
  PostalCode VARCHAR(55),
  City VARCHAR(55),
  Phone VARCHAR(55) UNIQUE
);

-- Create Service Table
CREATE TABLE Service (
  ServiceID INT PRIMARY KEY,
  ServiceName VARCHAR(55) NOT NULL,
  Description TEXT,
  ServiceRate DECIMAL NOT NULL,
  ServiceType VARCHAR(55) NOT NULL,
  ProviderID INT,
  FOREIGN KEY (ProviderID) REFERENCES Provider(ProviderID) ON DELETE
  CASCADE ON UPDATE CASCADE
);

-- Create Participant Registration Table
CREATE TABLE RegistrationParticipant (
  ParticipantID INT,
  EventID INT,
  EventTheme VARCHAR(55),
  FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID) ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE
  CASCADE ON UPDATE CASCADE,
  UNIQUE(ParticipantID, EventID)
);

-- Create Provider Event Table
CREATE TABLE ProviderEvent (
  ServiceType VARCHAR(55) NOT NULL,
  ProviderID INT,
  EventID INT,
  FOREIGN KEY (ProviderID) REFERENCES Provider(ProviderID) ON DELETE CASCADE ON
  UPDATE CASCADE,
  FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE
  CASCADE ON UPDATE CASCADE,
  UNIQUE(ProviderID, EventID)
);

-- Create Employee Event Table
CREATE TABLE EmployeeEvent (
  EmpID INT,
  EventID INT,
  HoursWorked INT NOT NULL,
  FOREIGN KEY (EmpID) REFERENCES Employee(EmpID) ON DELETE CASCADE ON
  UPDATE CASCADE,
  FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE
  CASCADE ON UPDATE CASCADE,
  UNIQUE(EmpID, EventID)
);

-- Create Billing Service Table
CREATE TABLE BillingService (
  InvoiceID INT,
  ServiceID INT,
  SalePrice DECIMAL NOT NULL,
  Quantity INT NOT NULL,
  FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID) ON DELETE CASCADE ON
  UPDATE CASCADE,
  FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID) ON DELETE CASCADE
  ON UPDATE CASCADE
);

-- Create Service Assignment Table
CREATE TABLE ServiceAssignment (
  EventID INT,
  ServiceID INT,
  InvoiceID INT,
  ServiceUseDate DATE NOT NULL,
  NumberOfServicesUsed INT NOT NULL,
  FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (EventID, ServiceID, InvoiceID)
);

-- Inserting Data
-- Insert clients
INSERT INTO Client (LastName, FirstName, Address, PostalCode, City, Phone, RegistrationDate, AdditionalAddress) VALUES
('Dupont', 'Jean', '123 rue de la Paix', '75001', 'Paris', '0102030405', '1990-01-01', '123 rue de la Paix');

-- Insert employees
INSERT INTO Employee (LastName, FirstName, Address, PostalCode, City, Email, Phone, Role) VALUES
('Martin', 'Lucie', '456 avenue des Champs-Élysées', '75008', 'Paris', 'lucie.martin@email.com', '0607080910', 'Director');

-- Insert events
INSERT INTO Event (EventName, EventLocation, EventDate, Program, EventTheme, ClientID) VALUES
('Rock Concert', 'Stade de France', '2024-06-15', 'International rock concert featuring several famous bands.', 'Music', 1);

-- Insert providers
INSERT INTO Provider (LastName, FirstName, Address, PostalCode, City, Phone, Email, RegistrationDate) VALUES
('Light & Sound', 'Alexandre', '789 rue du Théâtre', '75009', 'Paris', '0712131415', 'contact@lightsound.com', '2023-01-01');

-- Insert invoices
INSERT INTO Invoice (Amount, InvoiceDate, ProviderID, ClientID) VALUES
(1500.00, '2024-06-01', 1, 1);

-- Insert participants
INSERT INTO Participant (ParticipantID, LastName, FirstName, Address, PostalCode, City, Phone) VALUES
(1, 'Lefebvre', 'Marie', '101 boulevard Voltaire', '75011', 'Paris', '0611223344');

-- Insert services
INSERT INTO Service (ServiceID, ServiceName, Description, ServiceRate, ServiceType, ProviderID) VALUES
(1, 'Sound System', 'Sound system services for events', 500.00, 'Technical', 1);

-- Register participants for an event
INSERT INTO RegistrationParticipant (ParticipantID, EventID, EventTheme) VALUES
(1, 1, 'Music');

-- Associate a provider with an event
INSERT INTO ProviderEvent (ServiceType, ProviderID, EventID) VALUES
('Technical', 1, 1);

-- Assign an employee to an event
INSERT INTO EmployeeEvent (EmpID, EventID, HoursWorked) VALUES
(1, 1, 10);

-- Bill a service
INSERT INTO BillingService (InvoiceID, ServiceID, SalePrice, Quantity) VALUES
(1, 1, 500.00, 1);

-- Service assignment
INSERT INTO ServiceAssignment (EventID, ServiceID, InvoiceID, ServiceUseDate, NumberOfServicesUsed) VALUES
(1, 1, 1, '2024-06-15', 1);

-- Views
-- View of complete event information
CREATE VIEW CompleteEventDetails AS
SELECT e.EventID, e.EventName, e.EventLocation, e.EventDate, e.Program, e.EventTheme,
  c.LastName, c.FirstName, c.Address, c.PostalCode, c.City, c.Phone
FROM Event e
JOIN Client c ON e.ClientID = c.ClientID;

-- View of invoices with provider details
CREATE VIEW InvoiceProviderDetails AS
SELECT i.InvoiceID, i.Amount, i.InvoiceDate, p.LastName, p.Address, p.Phone, p.Email
FROM Invoice i
JOIN Provider p ON i.ProviderID = p.ProviderID;

-- View of total project hours per employee for events
CREATE VIEW TotalProjectHoursByEmployee AS
SELECT e.EmpID, e.LastName, e.FirstName,
SUM(ee.HoursWorked) AS TotalHours
FROM Employee e
JOIN EmployeeEvent ee ON e.EmpID = ee.EmpID
GROUP BY e.EmpID;

-- View of the most popular services
CREATE VIEW PopularServices AS
SELECT s.ServiceID, s.ServiceName, COUNT(bs.ServiceID) AS NumberInvoices
FROM Service s
JOIN BillingService bs ON s.ServiceID = bs.ServiceID
GROUP BY s.ServiceID
ORDER BY NumberInvoices DESC;

-- View of event participants with themes
CREATE VIEW EventParticipantsWithTheme AS
SELECT e.EventName, e.EventTheme, p.LastName, p.FirstName
FROM RegistrationParticipant rp
JOIN Participant p ON rp.ParticipantID = p.IDParticip
JOIN Event e ON rp.EventID = e.EventID;

-- Triggers
-- Update the total amount of an invoice after inserting or updating a billed service
DELIMITER //
CREATE TRIGGER UpdateInvoiceAmountAfterInsertOrUpdate
AFTER INSERT ON BillingService
FOR EACH ROW
BEGIN
  UPDATE Invoice
  SET Amount = Amount + (NEW.SalePrice * NEW.Quantity)
  WHERE InvoiceID = NEW.InvoiceID;
END;
//
DELIMITER ;

-- Delete participant registrations after an event is deleted
DELIMITER //
CREATE TRIGGER DeleteRegistrationsAfterEventDeletion
AFTER DELETE ON Event
FOR EACH ROW
BEGIN
  DELETE FROM RegistrationParticipant
  WHERE EventID = OLD.EventID;
END;
//
DELIMITER ;

-- Decrease the number of participants after canceling a registration
DELIMITER //
CREATE TRIGGER DecreaseParticipantCount
AFTER DELETE ON RegistrationParticipant
FOR EACH ROW
BEGIN
  UPDATE Event
  SET NumberOfParticipants = NumberOfParticipants - 1
  WHERE EventID = OLD.EventID;
END;
//
DELIMITER ;

-- Stored Procedures
-- Register a participant for an event
DELIMITER //
CREATE PROCEDURE RegisterParticipantForEvent(
  IN ParticipantID INT,
  IN EventID INT,
  IN EventTheme VARCHAR(55)
)
BEGIN
  INSERT INTO RegistrationParticipant (ParticipantID, EventID, EventTheme)
  VALUES (ParticipantID, EventID, EventTheme);
END;
//
DELIMITER ;

-- Calculate total revenues generated by events for a given client
DELIMITER //
CREATE PROCEDURE CalculateClientRevenue(
  IN ClientID INT
)
BEGIN
  SELECT Client.ClientID, Client.LastName, SUM(Invoice.Amount) AS TotalRevenue
  FROM Invoice
  JOIN Event ON Invoice.ClientID = Event.ClientID
  JOIN Client ON Event.ClientID = Client.ClientID
  WHERE Client.ClientID = ClientID
  GROUP BY Client.ClientID;
END;
//
DELIMITER ;

-- Update provider information
DELIMITER //
CREATE PROCEDURE UpdateProviderInfo(
  IN ProviderID INT,
  IN newAddress VARCHAR(55),
  IN newPostalCode VARCHAR(55),
  IN newCity VARCHAR(55),
  IN newPhone VARCHAR(55),
  IN newEmail VARCHAR(55)
)
BEGIN
  UPDATE Provider
  SET Address = newAddress,
      PostalCode = newPostalCode,
      City = newCity,
      Phone = newPhone,
      Email = newEmail
  WHERE ProviderID = ProviderID;
END;
//
DELIMITER ;

