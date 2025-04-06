-- Create extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create core tables
CREATE TABLE Person (
    PersonID UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    DOB DATE NOT NULL
);

CREATE TABLE Neighbours (
    NeighbourID UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    NeighbourName VARCHAR(100) NOT NULL,
    NeighbourEmail VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Addresses (
    AddressID UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    Street VARCHAR(255) NOT NULL,
    ZipCode VARCHAR(20) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    City VARCHAR(100) NOT NULL
);

CREATE TABLE Favourites (
    FavouriteID UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    FavouriteType INT NOT NULL, -- 1: Book, 2: Drink, 3: Activity
    FavouriteName VARCHAR(255) NOT NULL
);

-- Create junction tables
CREATE TABLE Person_Addresses (
    PersonID UUID,
    AddressID UUID,
    is_primary BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (PersonID, AddressID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID)
);

CREATE TABLE Person_Favourites (
    PersonID UUID,
    FavouriteID UUID,
    PRIMARY KEY (PersonID, FavouriteID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (FavouriteID) REFERENCES Favourites(FavouriteID)
);

CREATE TABLE Person_Neighbours (
    PersonID UUID,
    NeighbourID UUID,
    PRIMARY KEY (PersonID, NeighbourID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (NeighbourID) REFERENCES Neighbours(NeighbourID)
);

-- Create indexes for query optimization
CREATE INDEX idx_person_dob ON Person(DOB);
CREATE INDEX idx_neighbours_email ON Neighbours(NeighbourEmail);
CREATE INDEX idx_addresses_city ON Addresses(City);
CREATE INDEX idx_favourites_type ON Favourites(FavouriteType);

-- Additional helpful indexes for join performance
CREATE INDEX idx_person_addresses_personid ON Person_Addresses(PersonID);
CREATE INDEX idx_person_favourites_personid ON Person_Favourites(PersonID);
CREATE INDEX idx_person_neighbours_personid ON Person_Neighbours(PersonID);

-- Create function for age calculation
CREATE OR REPLACE FUNCTION calculate_age(birthday DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN date_part('year', age(birthday));
END;
$$ LANGUAGE plpgsql;
