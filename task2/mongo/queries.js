// MongoDB queries implementation

// Connect to MongoDB and use the peopleDatabase
db = db.getSiblingDB("peopleDatabase");

// Helper function to calculate age in years - clean year-based calculation
function calculateAge(dobDate) {
  const now = new Date();
  const birthYear = dobDate.getFullYear();
  const birthMonth = dobDate.getMonth();
  const birthDay = dobDate.getDate();

  const currentYear = now.getFullYear();
  const currentMonth = now.getMonth();
  const currentDay = now.getDate();

  let age = currentYear - birthYear;

  // Adjust if birthday hasn't occurred yet this year
  if (birthMonth > currentMonth ||
     (birthMonth === currentMonth && birthDay > currentDay)) {
    age--;
  }

  return age;
}

// Query 1: Display person's name and their age in years
function query1() {
  print("\n=== Query 1: Display person's name and their age in years ===");

  // Get all persons with their DOB
  const persons = db.persons.find({}, { _id: 0, name: 1, dob: 1 }).sort({ name: 1 }).toArray();

  // Calculate ages using our helper function
  const result = persons.map(person => ({
    name: person.name,
    age: calculateAge(person.dob)
  }));

  printjson(result);
  return result;
}

// Query 2: Group Persons by their favourite drink and return average age of each group
function query2() {
  print("\n=== Query 2: Group Persons by their favourite drink and return average age of each group ===");

  // Get all persons with their drinks and DOB
  const persons = db.persons.find({}, { _id: 0, favorites: 1, dob: 1 }).toArray();

  // Group by drink and calculate average age
  const drinkMap = new Map();

  persons.forEach(person => {
    const age = calculateAge(person.dob);

    person.favorites.drinks.forEach(drink => {
      if (!drinkMap.has(drink)) {
        drinkMap.set(drink, { count: 0, totalAge: 0 });
      }

      const entry = drinkMap.get(drink);
      entry.count++;
      entry.totalAge += age;
    });
  });

  // Convert to array of results
  const result = Array.from(drinkMap.entries()).map(([drink, data]) => ({
    drink: drink,
    averageAge: parseFloat((data.totalAge / data.count).toFixed(2))
  }));

  // Sort by average age descending
  result.sort((a, b) => b.averageAge - a.averageAge);

  printjson(result);
  return result;
}

// Query 3: Display average age of people who likes Hiking
function query3() {
  print("\n=== Query 3: Display average age of people who like Hiking ===");

  // Get all persons who like hiking
  const hikers = db.persons.find(
    { "favorites.activities": "Hiking" },
    { _id: 0, dob: 1 }
  ).toArray();

  // Calculate average age
  const totalAge = hikers.reduce((sum, person) => sum + calculateAge(person.dob), 0);
  const count = hikers.length;
  const averageAge = parseFloat((totalAge / count).toFixed(2));

  const result = {
    count: count,
    averageAge: averageAge
  };

  printjson(result);
  return result;
}

// Query 4: Display the total number of people from each City and sort it in ascending order
function query4() {
  print("\n=== Query 4: Display the total number of people from each City and sort in ascending order ===");

  // Get all persons with their addresses
  const persons = db.persons.find({}, { _id: 0, addresses: 1 }).toArray();

  // Count people per city
  const cityMap = new Map();

  persons.forEach(person => {
    person.addresses.forEach(address => {
      const city = address.city;
      if (!cityMap.has(city)) {
        cityMap.set(city, 0);
      }

      cityMap.set(city, cityMap.get(city) + 1);
    });
  });

  // Convert to array of results
  const result = Array.from(cityMap.entries()).map(([city, count]) => ({
    city: city,
    totalPeople: count
  }));

  // Sort by total people ascending, then by city name
  result.sort((a, b) => {
    if (a.totalPeople !== b.totalPeople) {
      return a.totalPeople - b.totalPeople;
    }
    return a.city.localeCompare(b.city);
  });

  printjson(result);
  return result;
}

// Query 5: Display name of person(s) whose neighbour is neighbour C
function query5() {
  print("\n=== Query 5: Display name of person(s) whose neighbour is neighbour C ===");

  // Get persons whose neighbor is NeighbourC
  const result = db.persons.find(
    { "neighbours.name": "NeighbourC" },
    { _id: 0, name: 1, email: 1 }
  ).toArray();

  printjson(result);
  return result;
}

// Only execute all queries when run directly (not when loaded by individual query commands)
if (typeof __dirname === 'undefined') {
  print("\nExecuting all queries...");
  query1();
  query2();
  query3();
  query4();
  query5();
  print("\nAll queries executed successfully");
}
