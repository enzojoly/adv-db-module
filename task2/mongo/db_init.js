// MongoDB database initialization script

// Connect to MongoDB and create database
db = db.getSiblingDB("peopleDatabase");

// Drop database if it exists (for clean initialization)
db.dropDatabase();

// Create collections
db.createCollection("persons");

// Create indexes for better query performance
db.persons.createIndex({ "name": 1 });
db.persons.createIndex({ "email": 1 }, { unique: true });
db.persons.createIndex({ "addresses.city": 1 });
db.persons.createIndex({ "favorites.books": 1 });
db.persons.createIndex({ "favorites.drinks": 1 });
db.persons.createIndex({ "favorites.activities": 1 });
db.persons.createIndex({ "neighbours.name": 1 });
db.persons.createIndex({ "neighbours.email": 1 }, { unique: true });

print("Database initialization complete");
