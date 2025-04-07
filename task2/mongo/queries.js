// MongoDB queries implementation

// Connect to MongoDB and use the peopleDatabase
db = db.getSiblingDB('peopleDatabase');

// Query 1: Display person's name and their age in years
function query1() {
  print("\n=== Query 1: Display person's name and their age in years ===");

  const result = db.persons.aggregate([
    {
      $project: {
        _id: 0,
        name: 1,
        age: {
          $floor: {
            $divide: [
              { $subtract: [new Date(), "$dob"] },
              (365.25 * 24 * 60 * 60 * 1000)
            ]
          }
        }
      }
    },
    { $sort: { name: 1 } }
  ]).toArray();

  printjson(result);
  return result;
}

// Query 2: Group Persons by their favourite drink and return average age of each group
function query2() {
  print("\n=== Query 2: Group Persons by their favourite drink and return average age of each group ===");

  const result = db.persons.aggregate([
    { $unwind: "$favorites.drinks" },
    {
      $group: {
        _id: "$favorites.drinks",
        count: { $sum: 1 },
        totalAge: {
          $sum: {
            $floor: {
              $divide: [
                { $subtract: [new Date(), "$dob"] },
                (365.25 * 24 * 60 * 60 * 1000)
              ]
            }
          }
        }
      }
    },
    {
      $project: {
        _id: 0,
        drink: "$_id",
        averageAge: { $round: [{ $divide: ["$totalAge", "$count"] }, 2] }
      }
    },
    { $sort: { averageAge: -1 } }
  ]).toArray();

  printjson(result);
  return result;
}

// Query 3: Display average age of people who likes Hiking
function query3() {
  print("\n=== Query 3: Display average age of people who like Hiking ===");

  const result = db.persons.aggregate([
    { $match: { "favorites.activities": "Hiking" } },
    {
      $group: {
        _id: null,
        count: { $sum: 1 },
        averageAge: {
          $avg: {
            $floor: {
              $divide: [
                { $subtract: [new Date(), "$dob"] },
                (365.25 * 24 * 60 * 60 * 1000)
              ]
            }
          }
        }
      }
    },
    {
      $project: {
        _id: 0,
        count: 1,
        averageAge: { $round: ["$averageAge", 2] }
      }
    }
  ]).toArray();

  printjson(result);
  return result;
}

// Query 4: Display the total number of people from each City and sort it in ascending order
function query4() {
  print("\n=== Query 4: Display the total number of people from each City and sort in ascending order ===");

  const result = db.persons.aggregate([
    { $unwind: "$addresses" },
    {
      $group: {
        _id: "$addresses.city",
        totalPeople: { $sum: 1 }
      }
    },
    {
      $project: {
        _id: 0,
        city: "$_id",
        totalPeople: 1
      }
    },
    { $sort: { totalPeople: 1, city: 1 } }
  ]).toArray();

  printjson(result);
  return result;
}

// Query 5: Display name of person(s) whose neighbour is neighbour C
function query5() {
  print("\n=== Query 5: Display name of person(s) whose neighbour is neighbour C ===");

  const result = db.persons.aggregate([
    { $match: { "neighbours.name": "NeighbourC" } },
    {
      $project: {
        _id: 0,
        name: 1,
        email: 1
      }
    }
  ]).toArray();

  printjson(result);
  return result;
}

// Execute all queries
print("\nExecuting all queries...");
query1();
query2();
query3();
query4();
query5();

print("\nAll queries executed successfully");
