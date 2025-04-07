// MongoDB data population script

// Connect to MongoDB and use the peopleDatabase
db = db.getSiblingDB("peopleDatabase");

// Parse the sample data from string
function parseSampleData() {
  const sampleDataStr = `Name Email DOB Street City Country ZipCode FavoriteBook FavoriteDrink FavoriteActivity Neighbour1 Neighbour1Email Neighbour2 Neighbour2Email
Person1 person1@email.com 15/03/1995 12MapleSt London England E16AN ANewBeginning Lemonade OutdoorRunning NeighbourA neighbourA@email.com NeighbourB neighbourB@email.com
Person2 person2@email.com 22/06/1993 45OakAve Manchester England M12WD TheRoadtoSuccess Coffee Hiking NeighbourC neighbourC@email.com NeighbourD neighbourD@email.com
Person3 person3@email.com 10/09/1991 89PineRd Birmingham England B11AB EndlessPossibilities Smoothie Swimming NeighbourE neighbourE@email.com NeighbourF neighbourF@email.com
Person4 person4@email.com 05/12/1998 23BirchSt Edinburgh Scotland EH11YZ JourneyofLife IcedTea Traveling NeighbourG neighbourG@email.com NeighbourH neighbourH@email.com
Person5 person5@email.com 30/11/1983 67CedarLn Bristol England BS13XE TheAdventureContinues GreenTea Gardening NeighbourI neighbourI@email.com NeighbourJ neighbourJ@email.com
Person6 person6@email.com 18/07/1989 56ElmSt Liverpool England L11AA FindingInnerPeace CoconutWater Reading NeighbourK neighbourK@email.com NeighbourL neighbourL@email.com
Person7 person7@email.com 25/04/1996 12MapleSt Glasgow Scotland G12TF ExploringNewHorizons FruitJuice Cycling NeighbourM neighbourM@email.com NeighbourN neighbourN@email.com
Person8 person8@email.com 09/01/1990 89OakDr Leeds England LS13AB TheGreatJourney Water Hiking NeighbourO neighbourO@email.com NeighbourP neighbourP@email.com
Person9 person9@email.com 17/08/1993 123PineRd Newcastle England NE12AB ThePowerofChange HotChocolate Skiing NeighbourQ neighbourQ@email.com NeighbourR neighbourR@email.com
Person10 person10@email.com 22/10/1997 15ElmSt Cardiff Wales CF103AF NewBeginningsAwait FruitSmoothie Jogging NeighbourS neighbourS@email.com NeighbourT neighbourT@email.com
Person11 person11@email.com 13/05/1992 78OakLn Sheffield England S14GT WanderingSouls SparklingWater RockClimbing NeighbourU neighbourU@email.com NeighbourV neighbourV@email.com
Person12 person12@email.com 27/02/1986 56BirchRd Nottingham England NG12PB FreedomandChoice HerbalTea Yoga NeighbourW neighbourW@email.com NeighbourX neighbourX@email.com
Person13 person13@email.com 25/11/1991 10HolySt Cardiff Wales CF102NF NewBeginningsAwait Smoothie Hiking NeighbourY neighbourY@email.com NeighbourZ neighbourZ@email.com
Person14 person14@email.com 01/02/1987 34WillowRd Edinburgh Scotland EH11AB ChasingDreams Lemonade Running NeighbourAA neighbourAA@email.com NeighbourAB neighbourAB@email.com
Person15 person15@email.com 12/08/1984 78CedarAve Cambridge England CB12SE TheEndlessJourney IcedCoffee Cycling NeighbourAC neighbourAC@email.com NeighbourAD neighbourAD@email.com
Person16 person16@email.com 09/03/1990 45MapleRd Oxford England OX26TP TheFutureAhead FruitJuice Yoga NeighbourAE neighbourAE@email.com NeighbourAF neighbourAF@email.com
Person17 person17@email.com 17/11/1995 23BirchAve Southampton England SO143HL ThePathtoGlory GreenTea Gardening NeighbourAG neighbourAG@email.com NeighbourAH neighbourAH@email.com
Person18 person18@email.com 20/06/1994 12ElmBlvd Leicester England LE13PL Life'sAdventure CoconutWater Hiking NeighbourAI neighbourAI@email.com NeighbourAJ neighbourAJ@email.com
Person19 person19@email.com 11/12/1992 56OakRd Norwich England NR14BE IntotheWild HerbalTea Swimming NeighbourAK neighbourAK@email.com NeighbourAL neighbourAL@email.com
Person20 person20@email.com 25/09/1988 89PineAve Cardiff Wales CF103BC TheAdventureContinues Water Hiking NeighbourAM neighbourAM@email.com NeighbourAN neighbourAN@email.com`;

  const lines = sampleDataStr.split('\n');
  const headers = lines[0].split(' ');

  const result = [];
  for (let i = 1; i < lines.length; i++) {
    const values = lines[i].split(' ');
    const person = {};

    for (let j = 0; j < headers.length; j++) {
      person[headers[j]] = values[j];
    }

    result.push(person);
  }

  return result;
}

// Transform the flat data into MongoDB document structure
function transformToDocuments(data) {
  return data.map(person => {
    // Parse date (DD/MM/YYYY format)
    const [day, month, year] = person.DOB.split('/');
    const dobDate = new Date(`${year}-${month}-${day}`);

    // Create MongoDB document with embedded structure
    return {
      name: person.Name,
      email: person.Email,
      dob: dobDate,
      addresses: [
        {
          street: person.Street,
          city: person.City,
          country: person.Country,
          zipCode: person.ZipCode,
          is_primary: true
        }
      ],
      favorites: {
        books: [person.FavoriteBook],
        drinks: [person.FavoriteDrink],
        activities: [person.FavoriteActivity]
      },
      neighbours: [
        {
          name: person.Neighbour1,
          email: person.Neighbour1Email
        },
        {
          name: person.Neighbour2,
          email: person.Neighbour2Email
        }
      ]
    };
  });
}

// Parse and insert the data
const sampleData = parseSampleData();
const documents = transformToDocuments(sampleData);

// Insert the documents into the persons collection
db.persons.insertMany(documents);

print(`${documents.length} documents inserted into the 'persons' collection`);

// Display database statistics for verification
const stats = db.stats();
print("\nDatabase Statistics:");
print(`- Database: ${stats.db}`);
print(`- Collections: ${stats.collections}`);
print(`- Objects: ${stats.objects}`);

// Display collection statistics
const collStats = db.getCollection("persons").stats();
print(`- Persons collection size: ${collStats.size} bytes`);
print(`- Persons document count: ${collStats.count}`);
