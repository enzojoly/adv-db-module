{
  description = "Task 1 PostgreSQL Database with Queries";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Simple PostgreSQL wrapper script - SIMPLIFIED
        createWrapper = pkgs.writeScriptBin "pg-wrapper" ''
          #!${pkgs.bash}/bin/bash

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"
          export PGPORT=5432

          mkdir -p "$PGHOST"

          if [ "$1" = "start" ]; then
            if ! ${pkgs.postgresql}/bin/pg_isready -h "$PGHOST" -p $PGPORT > /dev/null 2>&1; then
              echo "Starting PostgreSQL server..."
              ${pkgs.postgresql}/bin/pg_ctl -D "$PGDATA" -l "$PWD/postgres.log" start
              sleep 3

              if ! ${pkgs.postgresql}/bin/pg_isready -h "$PGHOST" -p $PGPORT > /dev/null 2>&1; then
                echo "ERROR: PostgreSQL failed to start. Log output:"
                cat "$PWD/postgres.log"
                exit 1
              fi
              echo "PostgreSQL server started successfully."
            else
              echo "PostgreSQL server is already running."
            fi
          elif [ "$1" = "stop" ]; then
            if ${pkgs.postgresql}/bin/pg_isready -h "$PGHOST" -p $PGPORT > /dev/null 2>&1; then
              echo "Stopping PostgreSQL server..."
              ${pkgs.postgresql}/bin/pg_ctl -D "$PGDATA" stop
            else
              echo "PostgreSQL server is not running."
            fi
          else
            echo "Usage: pg-wrapper [start|stop]"
            exit 1
          fi
        '';

        # Database initialization - SIMPLIFIED
        initnodataScript = pkgs.writeScriptBin "initnodata" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"
          export PGPORT=5432

          if [ -d "$PGDATA" ]; then
            echo "Database directory already exists. Cleaning up first..."
            pg-wrapper stop || true
            rm -rf "$PGDATA" "$PGHOST" postgres.log
          fi

          mkdir -p "$PGHOST"

          echo "Initializing PostgreSQL without database tables..."
          ${pkgs.postgresql}/bin/initdb -D "$PGDATA" --no-locale --encoding=UTF8

          # Configure PostgreSQL
          echo "Configuring PostgreSQL..."
          echo "unix_socket_directories = '$PGHOST'" >> "$PGDATA/postgresql.conf"

          echo "local all all trust" > "$PGDATA/pg_hba.conf"
          echo "host all all 127.0.0.1/32 trust" >> "$PGDATA/pg_hba.conf"

          # Start server
          pg-wrapper start

          # Create database
          echo "Creating database..."
          ${pkgs.postgresql}/bin/createdb -h "$PGHOST" task1_db

          echo "Initialised empty PostgreSQL environment"
        '';

        # Database initialization - SIMPLIFIED
        initialiseScript = pkgs.writeScriptBin "initialise" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"
          export PGPORT=5432

          if [ -d "$PGDATA" ]; then
            echo "Database directory already exists. Cleaning up first..."
            pg-wrapper stop || true
            rm -rf "$PGDATA" "$PGHOST" postgres.log
          fi

          mkdir -p "$PGHOST"

          echo "Initializing PostgreSQL database..."
          ${pkgs.postgresql}/bin/initdb -D "$PGDATA" --no-locale --encoding=UTF8

          # Configure PostgreSQL
          echo "Configuring PostgreSQL..."
          echo "unix_socket_directories = '$PGHOST'" >> "$PGDATA/postgresql.conf"

          echo "local all all trust" > "$PGDATA/pg_hba.conf"
          echo "host all all 127.0.0.1/32 trust" >> "$PGDATA/pg_hba.conf"

          # Start server
          pg-wrapper start

          # Create database
          echo "Creating database..."
          ${pkgs.postgresql}/bin/createdb -h "$PGHOST" task1_db

          # Initialize schema
          echo "Initializing schema..."
          ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db -f ${./sql/db_init.sql}

          echo "Schema initialized successfully."
        '';

        # Data population - SIMPLIFIED
        populateScript = pkgs.writeScriptBin "populate" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"
          export PGPORT=5432

          # Ensure server is running
          pg-wrapper start

          echo "Populating database with data..."
          ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db -f ${./sql/populate_tables.sql}

          echo "Data population complete."
        '';

        # Query 1
        query1 = pkgs.writeScriptBin "query1" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    export PGDATA="$PWD/pgdata"
                    export PGHOST="$PWD/tmp"
                    export PGDATABASE="task1_db"

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          SELECT
              p.Name,
              calculate_age(p.DOB) AS Age
          FROM
              Person p
          ORDER BY
              p.Name;
          EOF
                      exit 0
                    fi

                    pg-wrapper start

                    echo "Running Query 1: Display person's name and age in years"
                    ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db <<EOF
          SELECT
              p.Name,
              calculate_age(p.DOB) AS Age
          FROM
              Person p
          ORDER BY
              p.Name;
          EOF
        '';

        # Query 2
        query2 = pkgs.writeScriptBin "query2" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    export PGDATA="$PWD/pgdata"
                    export PGHOST="$PWD/tmp"
                    export PGDATABASE="task1_db"

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          SELECT
              f.FavouriteName AS FavouriteDrink,
              ROUND(AVG(calculate_age(p.DOB))::NUMERIC, 2) AS AverageAge
          FROM
              Person p
          JOIN Person_Favourites pf ON p.PersonID = pf.PersonID
          JOIN Favourites f ON pf.FavouriteID = f.FavouriteID
          WHERE
              f.FavouriteType = 2
          GROUP BY
              f.FavouriteName
          ORDER BY
              AverageAge DESC;
          EOF
                      exit 0
                    fi

                    pg-wrapper start

                    echo "Running Query 2: Group persons by favorite drink and return average age"
                    ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db <<EOF
          SELECT
              f.FavouriteName AS FavouriteDrink,
              ROUND(AVG(calculate_age(p.DOB))::NUMERIC, 2) AS AverageAge
          FROM
              Person p
          JOIN Person_Favourites pf ON p.PersonID = pf.PersonID
          JOIN Favourites f ON pf.FavouriteID = f.FavouriteID
          WHERE
              f.FavouriteType = 2
          GROUP BY
              f.FavouriteName
          ORDER BY
              AverageAge DESC;
          EOF
        '';

        # Query 3
        query3 = pkgs.writeScriptBin "query3" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    export PGDATA="$PWD/pgdata"
                    export PGHOST="$PWD/tmp"
                    export PGDATABASE="task1_db"

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          SELECT
              ROUND(AVG(calculate_age(p.DOB))::NUMERIC, 2) AS AverageAgeOfHikers
          FROM
              Person p
          JOIN Person_Favourites pf ON p.PersonID = pf.PersonID
          JOIN Favourites f ON pf.FavouriteID = f.FavouriteID
          WHERE
              f.FavouriteType = 3 AND f.FavouriteName = 'Hiking';
          EOF
                      exit 0
                    fi

                    pg-wrapper start

                    echo "Running Query 3: Display average age of people who like Hiking"
                    ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db <<EOF
          SELECT
              ROUND(AVG(calculate_age(p.DOB))::NUMERIC, 2) AS AverageAgeOfHikers
          FROM
              Person p
          JOIN Person_Favourites pf ON p.PersonID = pf.PersonID
          JOIN Favourites f ON pf.FavouriteID = f.FavouriteID
          WHERE
              f.FavouriteType = 3 AND f.FavouriteName = 'Hiking';
          EOF
        '';

        # Query 4
        query4 = pkgs.writeScriptBin "query4" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    export PGDATA="$PWD/pgdata"
                    export PGHOST="$PWD/tmp"
                    export PGDATABASE="task1_db"

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          SELECT
              a.City,
              COUNT(DISTINCT p.PersonID) AS TotalPeople
          FROM
              Person p
          JOIN Person_Addresses pa ON p.PersonID = pa.PersonID
          JOIN Addresses a ON pa.AddressID = a.AddressID
          GROUP BY
              a.City
          ORDER BY
              TotalPeople ASC;
          EOF
                      exit 0
                    fi

                    pg-wrapper start

                    echo "Running Query 4: Display total number of people from each City"
                    ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db <<EOF
          SELECT
              a.City,
              COUNT(DISTINCT p.PersonID) AS TotalPeople
          FROM
              Person p
          JOIN Person_Addresses pa ON p.PersonID = pa.PersonID
          JOIN Addresses a ON pa.AddressID = a.AddressID
          GROUP BY
              a.City
          ORDER BY
              TotalPeople ASC;
          EOF
        '';

        # Query 5
        query5 = pkgs.writeScriptBin "query5" ''
                    #!${pkgs.bash}/bin/bash
                    set -e

                    export PGDATA="$PWD/pgdata"
                    export PGHOST="$PWD/tmp"
                    export PGDATABASE="task1_db"

                    if [ "$1" = "-v" ]; then
                      cat <<EOF
          SELECT DISTINCT
              p.Name
          FROM
              Person p
          JOIN Person_Neighbours pn ON p.PersonID = pn.PersonID
          JOIN Neighbours n ON pn.NeighbourID = n.NeighbourID
          WHERE
              n.NeighbourName = 'NeighbourC'
          ORDER BY
              p.Name;
          EOF
                      exit 0
                    fi

                    pg-wrapper start

                    echo "Running Query 5: Display name of person(s) whose neighbour is neighbour C"
                    ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db <<EOF
          SELECT DISTINCT
              p.Name
          FROM
              Person p
          JOIN Person_Neighbours pn ON p.PersonID = pn.PersonID
          JOIN Neighbours n ON pn.NeighbourID = n.NeighbourID
          WHERE
              n.NeighbourName = 'NeighbourC'
          ORDER BY
              p.Name;
          EOF
        '';

        # List tables command
        listTablesCmd = pkgs.writeScriptBin "list-tables" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"

          pg-wrapper start

          echo "Listing all tables in the database:"
          ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db -c "\\dt"
        '';

        # Show table contents
        showTableCmd = pkgs.writeScriptBin "show-table" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"

          if [ $# -eq 0 ]; then
            echo "Usage: show-table TABLE_NAME [LIMIT]"
            echo "Example: show-table Person 5"
            exit 1
          fi

          TABLE="$1"
          LIMIT=10

          if [ $# -gt 1 ]; then
            LIMIT="$2"
          fi

          pg-wrapper start

          echo "Contents of table $TABLE (limit $LIMIT):"
          ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db -c "SELECT * FROM $TABLE LIMIT $LIMIT;"
        '';

        # Interactive psql session
        psqlCmd = pkgs.writeScriptBin "psql-shell" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"

          pg-wrapper start

          echo "Starting interactive PostgreSQL session..."
          echo "Type '\\q' to exit"

          ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db
        '';

        # Execute arbitrary SQL
        sqlCmd = pkgs.writeScriptBin "sql" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"
          export PGDATABASE="task1_db"

          if [ $# -eq 0 ]; then
            echo "Usage: sql \"YOUR SQL COMMAND\""
            exit 1
          fi

          pg-wrapper start

          echo "Executing SQL command..."
          ${pkgs.postgresql}/bin/psql -h "$PGHOST" -d task1_db -c "$1"
        '';

        # Cleanup command
        cleanupScript = pkgs.writeScriptBin "cleanup" ''
          #!${pkgs.bash}/bin/bash
          set -e

          export PGDATA="$PWD/pgdata"
          export PGHOST="$PWD/tmp"

          pg-wrapper stop || true

          echo "Removing database files..."
          rm -rf "$PGDATA" "$PGHOST" postgres.log

          echo "Cleanup complete!"
        '';

      in
      {
        # Default package combines all scripts
        packages.default = pkgs.symlinkJoin {
          name = "task1-db-commands";
          paths = [
            createWrapper
            initnodataScript
            initialiseScript
            populateScript
            query1
            query2
            query3
            query4
            query5
            listTablesCmd
            showTableCmd
            psqlCmd
            sqlCmd
            cleanupScript
          ];
        };

        # Development shell
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.postgresql
            createWrapper
            initnodataScript
            initialiseScript
            populateScript
            query1
            query2
            query3
            query4
            query5
            listTablesCmd
            showTableCmd
            psqlCmd
            sqlCmd
            cleanupScript
          ];

          shellHook = ''
            echo "Task 1 PostgreSQL Database Environment"
            echo "--------------------------------------"
            echo "Commands:"
            echo "  initnodata      - Set up database without schema"
            echo "  initialise      - Set up database schema"
            echo "  populate        - Populate database with sample data"
            echo "  query1          - Display person's name and age in years"
            echo "  query2          - Group persons by favorite drink and return average age"
            echo "  query3          - Display average age of people who like Hiking"
            echo "  query4          - Display total number of people from each City"
            echo "  query5          - Display name of person(s) whose neighbour is neighbour C"
            echo ""
            echo "Table inspection:"
            echo "  list-tables     - Show all tables in the database"
            echo "  show-table      - Display contents of a table (e.g., show-table Person 5)"
            echo ""
            echo "Advanced usage:"
            echo "  psql-shell      - Start an interactive PostgreSQL shell"
            echo "  sql \"QUERY\"    - Execute arbitrary SQL command"
            echo "  cleanup         - Remove database files"
            echo ""
            echo "Add -v to any query command to view the SQL instead of running it"
            echo "Example: query1 -v"
          '';
        };
      }
    );
}
