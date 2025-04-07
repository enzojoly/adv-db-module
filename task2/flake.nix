{
  description = "Task 2 MongoDB Database with Queries using FerretDB (MongoDB alternative)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Use FerretDB - A binary MongoDB-compatible database
        db = pkgs.ferretdb;

        # Create scripts for database management
        createWrapper = pkgs.writeScriptBin "mongo-wrapper" ''
          #!${pkgs.bash}/bin/bash

          # Keep the original directory structure that was working
          export MONGO_DATA="$PWD/mongodata"
          export MONGO_PORT=27017
          export MONGO_DB="peopleDatabase"
          export FERRETDB_DIR="$MONGO_DATA/ferretdb_data"

          mkdir -p "$MONGO_DATA"
          mkdir -p "$FERRETDB_DIR"

          if [ "$1" = "start" ]; then
            if [ -f "$PWD/mongodb.pid" ] && ps -p $(cat "$PWD/mongodb.pid") > /dev/null 2>&1; then
              echo "FerretDB server is already running."
            else
              echo "Starting FerretDB server..."

              # Important! SQLite URL path must end with / for directory
              export FERRETDB_HANDLER="sqlite"
              export FERRETDB_SQLITE_URL="file:$FERRETDB_DIR/"
              export FERRETDB_LISTEN_ADDR=":$MONGO_PORT"

              # Start FerretDB with proper logging
              ${db}/bin/ferretdb > "$PWD/mongodb.log" 2>&1 &

              # Save PID
              echo $! > "$PWD/mongodb.pid"

              # Wait for server to start
              for i in {1..10}; do
                if ${pkgs.netcat}/bin/nc -z localhost $MONGO_PORT 2>/dev/null; then
                  echo "FerretDB server started successfully."
                  break
                fi

                if [ $i -eq 10 ]; then
                  echo "ERROR: FerretDB failed to start. Log output:"
                  cat "$PWD/mongodb.log"
                  exit 1
                fi

                echo "Waiting for FerretDB to start... (attempt $i)"
                sleep 1
              done
            fi
          elif [ "$1" = "stop" ]; then
            if [ -f "$PWD/mongodb.pid" ]; then
              PID=$(cat "$PWD/mongodb.pid")
              if ps -p $PID > /dev/null 2>&1; then
                echo "Stopping FerretDB server (PID: $PID)..."
                kill $PID

                # Wait for process to actually terminate
                for i in {1..5}; do
                  if ! ps -p $PID > /dev/null 2>&1; then
                    break
                  fi
                  sleep 1
                done

                # Force kill if still running
                if ps -p $PID > /dev/null 2>&1; then
                  echo "Force stopping FerretDB server..."
                  kill -9 $PID
                fi

                echo "FerretDB server stopped."
              else
                echo "No running FerretDB process found with PID: $PID"
              fi
              rm -f "$PWD/mongodb.pid"
            else
              echo "FerretDB server is not running or PID file not found."
            fi
          else
            echo "Usage: mongo-wrapper [start|stop]"
            exit 1
          fi
        '';

        # Install mongosh separately
        mongoshPkg = pkgs.mongosh;

        # Database initialization
        initialiseScript = pkgs.writeScriptBin "initialise" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    export MONGO_DATA="$PWD/mongodata"

                    if [ -d "$MONGO_DATA" ]; then
                      echo "Database directory already exists. Cleaning up first..."
                      mongo-wrapper stop || true
                      rm -rf "$MONGO_DATA" mongodb.log mongodb.pid
                    fi

                    mkdir -p "$MONGO_DATA"

                    echo "Starting FerretDB server..."
                    mongo-wrapper start

                    echo "Initializing MongoDB database..."

                    # First, check if the script exists in mongo/ directory
                    if [ -f "./mongo/db_init.js" ]; then
                      echo "Using existing db_init.js from mongo directory..."
                      cp ./mongo/db_init.js ./db_init.js
                    elif [ ! -f "./db_init.js" ]; then
                      echo "Creating db_init.js..."
                      cat > ./db_init.js << 'EOF'
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
          db.persons.createIndex({ "favorites.drinks": 1 });
          db.persons.createIndex({ "favorites.activities": 1 });
          db.persons.createIndex({ "neighbours.name": 1 });

          print("Database initialization complete");
          EOF
                    fi

                    ${mongoshPkg}/bin/mongosh --port 27017 --file ./db_init.js

                    echo "Schema initialized successfully."
        '';

        # Data population
        populateScript = pkgs.writeScriptBin "populate" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    # Ensure server is running
                    mongo-wrapper start

                    echo "Populating database with data..."

                    # First, check if the script exists in mongo/ directory
                    if [ -f "./mongo/populate_data.js" ]; then
                      echo "Using existing populate_data.js from mongo directory..."
                      cp ./mongo/populate_data.js ./populate_data.js
                    elif [ ! -f "./populate_data.js" ]; then
                      echo "Creating populate_data.js..."
                      cat > ./populate_data.js << 'EOF'
          // MongoDB data population script

          // Connect to MongoDB and use the peopleDatabase
          db = db.getSiblingDB("peopleDatabase");

          // Sample data directly as documents
          var sampleData = [
            {
              name: "Person1", email: "person1@email.com", dob: new Date("1995-03-15"),
              addresses: [{ street: "12MapleSt", city: "London", country: "England", zipCode: "E16AN", is_primary: true, created_at: new Date() }],
              favorites: { books: ["ANewBeginning"], drinks: ["Lemonade"], activities: ["OutdoorRunning"] },
              neighbours: [
                { name: "NeighbourA", email: "neighbourA@email.com", neighbour_since: new Date(), moved_out: null },
                { name: "NeighbourB", email: "neighbourB@email.com", neighbour_since: new Date(), moved_out: null }
              ],
              created_at: new Date(), updated_at: new Date()
            },
            {
              name: "Person2", email: "person2@email.com", dob: new Date("1993-06-22"),
              addresses: [{ street: "45OakAve", city: "Manchester", country: "England", zipCode: "M12WD", is_primary: true, created_at: new Date() }],
              favorites: { books: ["TheRoadtoSuccess"], drinks: ["Coffee"], activities: ["Hiking"] },
              neighbours: [
                { name: "NeighbourC", email: "neighbourC@email.com", neighbour_since: new Date(), moved_out: null },
                { name: "NeighbourD", email: "neighbourD@email.com", neighbour_since: new Date(), moved_out: null }
              ],
              created_at: new Date(), updated_at: new Date()
            },
            {
              name: "Person3", email: "person3@email.com", dob: new Date("1991-09-10"),
              addresses: [{ street: "89PineRd", city: "Birmingham", country: "England", zipCode: "B11AB", is_primary: true, created_at: new Date() }],
              favorites: { books: ["EndlessPossibilities"], drinks: ["Smoothie"], activities: ["Swimming"] },
              neighbours: [
                { name: "NeighbourE", email: "neighbourE@email.com", neighbour_since: new Date(), moved_out: null },
                { name: "NeighbourF", email: "neighbourF@email.com", neighbour_since: new Date(), moved_out: null }
              ],
              created_at: new Date(), updated_at: new Date()
            },
            {
              name: "Person8", email: "person8@email.com", dob: new Date("1990-01-09"),
              addresses: [{ street: "89OakDr", city: "Leeds", country: "England", zipCode: "LS13AB", is_primary: true, created_at: new Date() }],
              favorites: { books: ["TheGreatJourney"], drinks: ["Water"], activities: ["Hiking"] },
              neighbours: [
                { name: "NeighbourO", email: "neighbourO@email.com", neighbour_since: new Date(), moved_out: null },
                { name: "NeighbourP", email: "neighbourP@email.com", neighbour_since: new Date(), moved_out: null }
              ],
              created_at: new Date(), updated_at: new Date()
            },
            {
              name: "Person13", email: "person13@email.com", dob: new Date("1991-11-25"),
              addresses: [{ street: "10HolySt", city: "Cardiff", country: "Wales", zipCode: "CF102NF", is_primary: true, created_at: new Date() }],
              favorites: { books: ["NewBeginningsAwait"], drinks: ["Smoothie"], activities: ["Hiking"] },
              neighbours: [
                { name: "NeighbourY", email: "neighbourY@email.com", neighbour_since: new Date(), moved_out: null },
                { name: "NeighbourZ", email: "neighbourZ@email.com", neighbour_since: new Date(), moved_out: null }
              ],
              created_at: new Date(), updated_at: new Date()
            }
          ];

          // Insert sample data
          db.persons.insertMany(sampleData);
          print("Inserted " + sampleData.length + " documents into persons collection");

          // Display database statistics for verification
          var stats = db.stats();
          print("\nDatabase Statistics:");
          print("- Database: " + stats.db);
          print("- Collections: " + stats.collections);
          print("- Objects: " + stats.objects);

          // Display collection statistics
          var collStats = db.getCollection("persons").stats();
          print("- Persons collection size: " + collStats.size + " bytes");
          print("- Persons document count: " + collStats.count);
          EOF
                    fi

                    ${mongoshPkg}/bin/mongosh --port 27017 --file ./populate_data.js

                    echo "Data population complete."
        '';

        # Create queries.js if it doesn't exist
        createQueriesFile = pkgs.writeScriptBin "create-queries-file" ''
                    #!${pkgs.bash}/bin/bash

                    # First, check if the script exists in mongo/ directory
                    if [ -f "./mongo/queries.js" ]; then
                      echo "Using existing queries.js from mongo directory..."
                      cp ./mongo/queries.js ./queries.js
                      echo "Queries file copied successfully."
                      exit 0
                    fi

                    if [ ! -f "./queries.js" ]; then
                      echo "Creating queries.js..."
                      cat > ./queries.js << 'EOF'
          // MongoDB queries implementation

          // Connect to MongoDB and use the peopleDatabase
          db = db.getSiblingDB("peopleDatabase");

          // Helper function to calculate age in years - FerretDB-compatible
          function calculateAge(dobDate) {
            const now = new Date();
            const diffMs = now - dobDate;
            const ageDate = new Date(diffMs);
            return Math.abs(ageDate.getUTCFullYear() - 1970);
          }

          // Query 1: Display person's name and their age in years
          function query1() {
            print("\n=== Query 1: Display person's name and their age in years ===");

            // First get all persons with their DOB
            const persons = db.persons.find({}, { _id: 0, name: 1, dob: 1 }).sort({ name: 1 }).toArray();

            // Calculate ages manually
            const result = persons.map(person => ({
              name: person.name,
              age: calculateAge(person.dob)
            }));

            printjson(result);
            return result;
          }

          // Query 2: Group Persons by their favourite drink and return average age
          function query2() {
            print("\n=== Query 2: Group Persons by their favourite drink and return average age of each group ===");

            // First get all persons with their drinks and DOB
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

            // First get all persons who like hiking
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

            // First get all persons with their addresses
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

          // Execute all queries
          print("\nExecuting all queries...");
          query1();
          query2();
          query3();
          query4();
          query5();

          print("\nAll queries executed successfully");
          EOF
                      echo "Queries file created successfully."
                    else
                      echo "Queries file already exists."
                    fi
        '';

        # Query 1
        query1 = pkgs.writeScriptBin "query1" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          // Query 1: Display person's name and their age in years (FerretDB compatible)
          function calculateAge(dobDate) {
            const now = new Date();
            const diffMs = now - dobDate;
            const ageDate = new Date(diffMs);
            return Math.abs(ageDate.getUTCFullYear() - 1970);
          }

          // First get all persons with their DOB
          const persons = db.persons.find({}, { _id: 0, name: 1, dob: 1 }).sort({ name: 1 }).toArray();

          // Calculate ages manually
          const result = persons.map(person => ({
            name: person.name,
            age: calculateAge(person.dob)
          }));

          printjson(result);
          EOF
                      exit 0
                    fi

                    mongo-wrapper start

                    echo "Running Query 1: Display person's name and age in years"
                    ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
                      db = db.getSiblingDB('peopleDatabase');

                      // Helper function to calculate age in years - FerretDB-compatible
                      function calculateAge(dobDate) {
                        const now = new Date();
                        const diffMs = now - dobDate;
                        const ageDate = new Date(diffMs);
                        return Math.abs(ageDate.getUTCFullYear() - 1970);
                      }

                      // First get all persons with their DOB
                      const persons = db.persons.find({}, { _id: 0, name: 1, dob: 1 }).sort({ name: 1 }).toArray();

                      // Calculate ages manually
                      const result = persons.map(person => ({
                        name: person.name,
                        age: calculateAge(person.dob)
                      }));

                      // Print result
                      printjson(result);
                    "
        '';

        # Query 2
        query2 = pkgs.writeScriptBin "query2" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          // Query 2: Group Persons by their favourite drink and return average age (FerretDB compatible)
          function calculateAge(dobDate) {
            const now = new Date();
            const diffMs = now - dobDate;
            const ageDate = new Date(diffMs);
            return Math.abs(ageDate.getUTCFullYear() - 1970);
          }

          // First get all persons with their drinks and DOB
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
          EOF
                      exit 0
                    fi

                    mongo-wrapper start

                    echo "Running Query 2: Group persons by favorite drink and return average age"
                    ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
                      db = db.getSiblingDB('peopleDatabase');

                      // Helper function to calculate age in years - FerretDB-compatible
                      function calculateAge(dobDate) {
                        const now = new Date();
                        const diffMs = now - dobDate;
                        const ageDate = new Date(diffMs);
                        return Math.abs(ageDate.getUTCFullYear() - 1970);
                      }

                      // First get all persons with their drinks and DOB
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

                      // Print result
                      printjson(result);
                    "
        '';

        # Query 3
        query3 = pkgs.writeScriptBin "query3" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          // Query 3: Display average age of people who likes Hiking (FerretDB compatible)
          function calculateAge(dobDate) {
            const now = new Date();
            const diffMs = now - dobDate;
            const ageDate = new Date(diffMs);
            return Math.abs(ageDate.getUTCFullYear() - 1970);
          }

          // First get all persons who like hiking
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
          EOF
                      exit 0
                    fi

                    mongo-wrapper start

                    echo "Running Query 3: Display average age of people who like Hiking"
                    ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
                      db = db.getSiblingDB('peopleDatabase');

                      // Helper function to calculate age in years - FerretDB-compatible
                      function calculateAge(dobDate) {
                        const now = new Date();
                        const diffMs = now - dobDate;
                        const ageDate = new Date(diffMs);
                        return Math.abs(ageDate.getUTCFullYear() - 1970);
                      }

                      // First get all persons who like hiking
                      const hikers = db.persons.find(
                        { 'favorites.activities': 'Hiking' },
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

                      // Print result
                      printjson(result);
                    "
        '';

        # Query 4
        query4 = pkgs.writeScriptBin "query4" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          // Query 4: Display the total number of people from each City (FerretDB compatible)
          // First get all persons with their addresses
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
          EOF
                      exit 0
                    fi

                    mongo-wrapper start

                    echo "Running Query 4: Display total number of people from each City"
                    ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
                      db = db.getSiblingDB('peopleDatabase');

                      // First get all persons with their addresses
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

                      // Print result
                      printjson(result);
                    "
        '';

        # Query 5
        query5 = pkgs.writeScriptBin "query5" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          // Query 5: Display name of person(s) whose neighbour is neighbour C (FerretDB compatible)
          // Get persons whose neighbor is NeighbourC
          const result = db.persons.find(
            { "neighbours.name": "NeighbourC" },
            { _id: 0, name: 1, email: 1 }
          ).toArray();

          printjson(result);
          EOF
                      exit 0
                    fi

                    mongo-wrapper start

                    echo "Running Query 5: Display name of person(s) whose neighbour is neighbour C"
                    ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
                      db = db.getSiblingDB('peopleDatabase');

                      // Get persons whose neighbor is NeighbourC
                      const result = db.persons.find(
                        { 'neighbours.name': 'NeighbourC' },
                        { _id: 0, name: 1, email: 1 }
                      ).toArray();

                      // Print result
                      printjson(result);
                    "
        '';

        # Run all queries at once using the existing queries.js file
        runAllQueriesCmd = pkgs.writeScriptBin "run-all-queries" ''
          #!${pkgs.bash}/bin/bash
          set -e

          # Make sure queries.js exists
          create-queries-file

          mongo-wrapper start

          echo "Running all queries..."
          ${mongoshPkg}/bin/mongosh --port 27017 --file ./queries.js

          echo "All queries executed successfully."
        '';

        # List collections command
        listCollectionsCmd = pkgs.writeScriptBin "list-collections" ''
          #!${pkgs.bash}/bin/bash
          set -e

          mongo-wrapper start

          echo "Listing all collections in the database:"
          ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
            db = db.getSiblingDB('peopleDatabase');
            db.getCollectionNames().forEach(function(name) { print(name); });
          "
        '';

        # Show collection contents
        showCollectionCmd = pkgs.writeScriptBin "show-collection" ''
          #!${pkgs.bash}/bin/bash
          set -e

          if [ $# -eq 0 ]; then
            echo "Usage: show-collection COLLECTION_NAME [LIMIT]"
            echo "Example: show-collection persons 5"
            exit 1
          fi

          COLLECTION="$1"
          LIMIT=10

          if [ $# -gt 1 ]; then
            LIMIT="$2"
          fi

          mongo-wrapper start

          echo "Contents of collection $COLLECTION (limit $LIMIT):"
          ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
            db = db.getSiblingDB('peopleDatabase');
            var result = db.$COLLECTION.find().limit($LIMIT).toArray();
            printjson(result);
          "
        '';

        # Interactive mongo session
        mongoShellCmd = pkgs.writeScriptBin "mongo-shell" ''
          #!${pkgs.bash}/bin/bash
          set -e

          mongo-wrapper start

          echo "Starting interactive MongoDB session..."
          echo "Type 'exit' to exit"

          ${mongoshPkg}/bin/mongosh --port 27017
        '';

        # Execute arbitrary MongoDB command
        mongoCmd = pkgs.writeScriptBin "mongo-cmd" ''
          #!${pkgs.bash}/bin/bash
          set -e

          if [ $# -eq 0 ]; then
            echo "Usage: mongo-cmd \"YOUR MONGODB COMMAND\""
            exit 1
          fi

          mongo-wrapper start

          echo "Executing MongoDB command..."
          ${mongoshPkg}/bin/mongosh --port 27017 --quiet --eval "
            db = db.getSiblingDB('peopleDatabase');
            $1
          "
        '';

        # Cleanup command
        cleanupScript = pkgs.writeScriptBin "cleanup" ''
          #!${pkgs.bash}/bin/bash
          set -e

          mongo-wrapper stop || true

          echo "Removing database files..."
          rm -rf "$PWD/mongodata" mongodb.log mongodb.pid

          echo "Cleanup complete!"
        '';

      in
      {
        # Default package combines all scripts
        packages.default = pkgs.symlinkJoin {
          name = "task2-mongo-commands";
          paths = [
            createWrapper
            initialiseScript
            populateScript
            createQueriesFile
            query1
            query2
            query3
            query4
            query5
            runAllQueriesCmd
            listCollectionsCmd
            showCollectionCmd
            mongoShellCmd
            mongoCmd
            cleanupScript
          ];
        };

        # Development shell
        devShell = pkgs.mkShell {
          buildInputs = [
            db
            mongoshPkg
            pkgs.netcat
            createWrapper
            initialiseScript
            populateScript
            createQueriesFile
            query1
            query2
            query3
            query4
            query5
            runAllQueriesCmd
            listCollectionsCmd
            showCollectionCmd
            mongoShellCmd
            mongoCmd
            cleanupScript
          ];

          shellHook = ''
                        echo "Task 2 MongoDB Database Environment (FerretDB)"
                        echo "-----------------------------------------------"
                        echo "Commands:"
                        echo "  initialise        - Set up database schema"
                        echo "  populate          - Populate database with sample data"
                        echo "  query1            - Display person's name and age in years"
                        echo "  query2            - Group persons by favorite drink and return average age"
                        echo "  query3            - Display average age of people who like Hiking"
                        echo "  query4            - Display total number of people from each City"
                        echo "  query5            - Display name of person(s) whose neighbour is neighbour C"
                        echo "  run-all-queries   - Run all five queries at once"
                        echo ""
                        echo "Collection inspection:"
                        echo "  list-collections  - Show all collections in the database"
                        echo "  show-collection   - Display contents of a collection (e.g., show-collection persons 5)"
                        echo ""
                        echo "Advanced usage:"
                        echo "  mongo-shell       - Start an interactive MongoDB shell"
                        echo "  mongo-cmd \"CMD\"   - Execute arbitrary MongoDB command"
                        echo "  cleanup           - Remove database files"
                        echo ""
                        echo "Add -v to any query command to view the MongoDB query instead of running it"
                        echo "Example: query1 -v"
                        echo ""
            #            echo "Files to gitignore:"
            #            echo "  /mongodata/       - Database directory"
            #            echo "  *.log             - Log files"
            #            echo "  *.pid             - Process ID files"
            #            echo "  *.js              - Generated JavaScript files (excluding mongo/*.js)"
            #            echo ""
                        echo "NOTE: This uses FerretDB, a MongoDB-compatible database"
          '';
        };
      }
    );
}
