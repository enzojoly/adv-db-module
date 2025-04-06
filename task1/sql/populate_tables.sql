-- Populate Person table
INSERT INTO Person (
    Name,
    Email,
    DOB
)
VALUES
('Person1', 'person1@email.com', '1995-03-15'),
('Person2', 'person2@email.com', '1993-06-22'),
('Person3', 'person3@email.com', '1991-09-10'),
('Person4', 'person4@email.com', '1998-12-05'),
('Person5', 'person5@email.com', '1983-11-30'),
('Person6', 'person6@email.com', '1989-07-18'),
('Person7', 'person7@email.com', '1996-04-25'),
('Person8', 'person8@email.com', '1990-01-09'),
('Person9', 'person9@email.com', '1993-08-17'),
('Person10', 'person10@email.com', '1997-10-22'),
('Person11', 'person11@email.com', '1992-05-13'),
('Person12', 'person12@email.com', '1986-02-27'),
('Person13', 'person13@email.com', '1991-11-25'),
('Person14', 'person14@email.com', '1987-02-01'),
('Person15', 'person15@email.com', '1984-08-12'),
('Person16', 'person16@email.com', '1990-03-09'),
('Person17', 'person17@email.com', '1995-11-17'),
('Person18', 'person18@email.com', '1994-06-20'),
('Person19', 'person19@email.com', '1992-12-11'),
('Person20', 'person20@email.com', '1988-09-25');

-- Populate Addresses table
INSERT INTO Addresses (
    Street,
    ZipCode,
    Country,
    City
)
VALUES
('12MapleSt', 'E16AN', 'England', 'London'),
('45OakAve', 'M12WD', 'England', 'Manchester'),
('89PineRd', 'B11AB', 'England', 'Birmingham'),
('23BirchSt', 'EH11YZ', 'Scotland', 'Edinburgh'),
('67CedarLn', 'BS13XE', 'England', 'Bristol'),
('56ElmSt', 'L11AA', 'England', 'Liverpool'),
('12MapleSt', 'G12TF', 'Scotland', 'Glasgow'),
('89OakDr', 'LS13AB', 'England', 'Leeds'),
('123PineRd', 'NE12AB', 'England', 'Newcastle'),
('15ElmSt', 'CF103AF', 'Wales', 'Cardiff'),
('78OakLn', 'S14GT', 'England', 'Sheffield'),
('56BirchRd', 'NG12PB', 'England', 'Nottingham'),
('10HolySt', 'CF102NF', 'Wales', 'Cardiff'),
('34WillowRd', 'EH11AB', 'Scotland', 'Edinburgh'),
('78CedarAve', 'CB12SE', 'England', 'Cambridge'),
('45MapleRd', 'OX26TP', 'England', 'Oxford'),
('23BirchAve', 'SO143HL', 'England', 'Southampton'),
('12ElmBlvd', 'LE13PL', 'England', 'Leicester'),
('56OakRd', 'NR14BE', 'England', 'Norwich'),
('89PineAve', 'CF103BC', 'Wales', 'Cardiff');

-- Populate Favourites table with book type entries (Type 1)
INSERT INTO Favourites (
    FavouriteType,
    FavouriteName
)
VALUES
(1, 'ANewBeginning'),
(1, 'TheRoadtoSuccess'),
(1, 'EndlessPossibilities'),
(1, 'JourneyofLife'),
(1, 'TheAdventureContinues'),
(1, 'FindingInnerPeace'),
(1, 'ExploringNewHorizons'),
(1, 'TheGreatJourney'),
(1, 'ThePowerofChange'),
(1, 'NewBeginningsAwait'),
(1, 'WanderingSouls'),
(1, 'FreedomandChoice'),
(1, 'ChasingDreams'),
(1, 'TheEndlessJourney'),
(1, 'TheFutureAhead'),
(1, 'ThePathtoGlory'),
(1, 'Life''sAdventure'),
(1, 'IntotheWild');

-- Populate Favourites table with drink type entries (Type 2)
INSERT INTO Favourites (
    FavouriteType,
    FavouriteName
)
VALUES
(2, 'Lemonade'),
(2, 'Coffee'),
(2, 'Smoothie'),
(2, 'IcedTea'),
(2, 'GreenTea'),
(2, 'CoconutWater'),
(2, 'FruitJuice'),
(2, 'Water'),
(2, 'HotChocolate'),
(2, 'FruitSmoothie'),
(2, 'SparklingWater'),
(2, 'HerbalTea'),
(2, 'IcedCoffee');

-- Populate Favourites table with activity type entries (Type 3)
INSERT INTO Favourites (
    FavouriteType,
    FavouriteName
)
VALUES
(3, 'OutdoorRunning'),
(3, 'Hiking'),
(3, 'Swimming'),
(3, 'Traveling'),
(3, 'Gardening'),
(3, 'Reading'),
(3, 'Cycling'),
(3, 'Skiing'),
(3, 'Jogging'),
(3, 'RockClimbing'),
(3, 'Yoga'),
(3, 'Running');

-- Populate Neighbours table
INSERT INTO Neighbours (
    NeighbourName,
    NeighbourEmail
)
VALUES
('NeighbourA', 'neighbourA@email.com'),
('NeighbourB', 'neighbourB@email.com'),
('NeighbourC', 'neighbourC@email.com'),
('NeighbourD', 'neighbourD@email.com'),
('NeighbourE', 'neighbourE@email.com'),
('NeighbourF', 'neighbourF@email.com'),
('NeighbourG', 'neighbourG@email.com'),
('NeighbourH', 'neighbourH@email.com'),
('NeighbourI', 'neighbourI@email.com'),
('NeighbourJ', 'neighbourJ@email.com'),
('NeighbourK', 'neighbourK@email.com'),
('NeighbourL', 'neighbourL@email.com'),
('NeighbourM', 'neighbourM@email.com'),
('NeighbourN', 'neighbourN@email.com'),
('NeighbourO', 'neighbourO@email.com'),
('NeighbourP', 'neighbourP@email.com'),
('NeighbourQ', 'neighbourQ@email.com'),
('NeighbourR', 'neighbourR@email.com'),
('NeighbourS', 'neighbourS@email.com'),
('NeighbourT', 'neighbourT@email.com'),
('NeighbourU', 'neighbourU@email.com'),
('NeighbourV', 'neighbourV@email.com'),
('NeighbourW', 'neighbourW@email.com'),
('NeighbourX', 'neighbourX@email.com'),
('NeighbourY', 'neighbourY@email.com'),
('NeighbourZ', 'neighbourZ@email.com'),
('NeighbourAA', 'neighbourAA@email.com'),
('NeighbourAB', 'neighbourAB@email.com'),
('NeighbourAC', 'neighbourAC@email.com'),
('NeighbourAD', 'neighbourAD@email.com'),
('NeighbourAE', 'neighbourAE@email.com'),
('NeighbourAF', 'neighbourAF@email.com'),
('NeighbourAG', 'neighbourAG@email.com'),
('NeighbourAH', 'neighbourAH@email.com'),
('NeighbourAI', 'neighbourAI@email.com'),
('NeighbourAJ', 'neighbourAJ@email.com'),
('NeighbourAK', 'neighbourAK@email.com'),
('NeighbourAL', 'neighbourAL@email.com'),
('NeighbourAM', 'neighbourAM@email.com'),
('NeighbourAN', 'neighbourAN@email.com');

-- Populate junction tables
-- Person_Addresses
INSERT INTO Person_Addresses (
    PersonID,
    AddressID,
    is_primary
)
SELECT
    p.PersonID,
    a.AddressID,
    TRUE
FROM
    Person p, Addresses a
WHERE
    (p.Name = 'Person1' AND a.Street = '12MapleSt' AND a.ZipCode = 'E16AN') OR
    (p.Name = 'Person2' AND a.Street = '45OakAve' AND a.ZipCode = 'M12WD') OR
    (p.Name = 'Person3' AND a.Street = '89PineRd' AND a.ZipCode = 'B11AB') OR
    (p.Name = 'Person4' AND a.Street = '23BirchSt' AND a.ZipCode = 'EH11YZ') OR
    (p.Name = 'Person5' AND a.Street = '67CedarLn' AND a.ZipCode = 'BS13XE') OR
    (p.Name = 'Person6' AND a.Street = '56ElmSt' AND a.ZipCode = 'L11AA') OR
    (p.Name = 'Person7' AND a.Street = '12MapleSt' AND a.ZipCode = 'G12TF') OR
    (p.Name = 'Person8' AND a.Street = '89OakDr' AND a.ZipCode = 'LS13AB') OR
    (p.Name = 'Person9' AND a.Street = '123PineRd' AND a.ZipCode = 'NE12AB') OR
    (p.Name = 'Person10' AND a.Street = '15ElmSt' AND a.ZipCode = 'CF103AF') OR
    (p.Name = 'Person11' AND a.Street = '78OakLn' AND a.ZipCode = 'S14GT') OR
    (p.Name = 'Person12' AND a.Street = '56BirchRd' AND a.ZipCode = 'NG12PB') OR
    (p.Name = 'Person13' AND a.Street = '10HolySt' AND a.ZipCode = 'CF102NF') OR
    (p.Name = 'Person14' AND a.Street = '34WillowRd' AND a.ZipCode = 'EH11AB') OR
    (p.Name = 'Person15' AND a.Street = '78CedarAve' AND a.ZipCode = 'CB12SE') OR
    (p.Name = 'Person16' AND a.Street = '45MapleRd' AND a.ZipCode = 'OX26TP') OR
    (p.Name = 'Person17' AND a.Street = '23BirchAve' AND a.ZipCode = 'SO143HL') OR
    (p.Name = 'Person18' AND a.Street = '12ElmBlvd' AND a.ZipCode = 'LE13PL') OR
    (p.Name = 'Person19' AND a.Street = '56OakRd' AND a.ZipCode = 'NR14BE') OR
    (p.Name = 'Person20' AND a.Street = '89PineAve' AND a.ZipCode = 'CF103BC');

-- Person_Favourites for books (Type 1)
INSERT INTO Person_Favourites (
    PersonID,
    FavouriteID
)
SELECT
    p.PersonID,
    f.FavouriteID
FROM
    Person p
JOIN Favourites f ON
    f.FavouriteType = 1 AND
    (
        (p.Name = 'Person1' AND f.FavouriteName = 'ANewBeginning') OR
        (p.Name = 'Person2' AND f.FavouriteName = 'TheRoadtoSuccess') OR
        (p.Name = 'Person3' AND f.FavouriteName = 'EndlessPossibilities') OR
        (p.Name = 'Person4' AND f.FavouriteName = 'JourneyofLife') OR
        (p.Name = 'Person5' AND f.FavouriteName = 'TheAdventureContinues') OR
        (p.Name = 'Person6' AND f.FavouriteName = 'FindingInnerPeace') OR
        (p.Name = 'Person7' AND f.FavouriteName = 'ExploringNewHorizons') OR
        (p.Name = 'Person8' AND f.FavouriteName = 'TheGreatJourney') OR
        (p.Name = 'Person9' AND f.FavouriteName = 'ThePowerofChange') OR
        (p.Name = 'Person10' AND f.FavouriteName = 'NewBeginningsAwait') OR
        (p.Name = 'Person11' AND f.FavouriteName = 'WanderingSouls') OR
        (p.Name = 'Person12' AND f.FavouriteName = 'FreedomandChoice') OR
        (p.Name = 'Person13' AND f.FavouriteName = 'NewBeginningsAwait') OR
        (p.Name = 'Person14' AND f.FavouriteName = 'ChasingDreams') OR
        (p.Name = 'Person15' AND f.FavouriteName = 'TheEndlessJourney') OR
        (p.Name = 'Person16' AND f.FavouriteName = 'TheFutureAhead') OR
        (p.Name = 'Person17' AND f.FavouriteName = 'ThePathtoGlory') OR
        (p.Name = 'Person18' AND f.FavouriteName = 'Life''sAdventure') OR
        (p.Name = 'Person19' AND f.FavouriteName = 'IntotheWild') OR
        (p.Name = 'Person20' AND f.FavouriteName = 'TheAdventureContinues')
    );

-- Person_Favourites for drinks (Type 2)
INSERT INTO Person_Favourites (
    PersonID,
    FavouriteID
)
SELECT
    p.PersonID,
    f.FavouriteID
FROM
    Person p
JOIN Favourites f ON
    f.FavouriteType = 2 AND
    (
        (p.Name = 'Person1' AND f.FavouriteName = 'Lemonade') OR
        (p.Name = 'Person2' AND f.FavouriteName = 'Coffee') OR
        (p.Name = 'Person3' AND f.FavouriteName = 'Smoothie') OR
        (p.Name = 'Person4' AND f.FavouriteName = 'IcedTea') OR
        (p.Name = 'Person5' AND f.FavouriteName = 'GreenTea') OR
        (p.Name = 'Person6' AND f.FavouriteName = 'CoconutWater') OR
        (p.Name = 'Person7' AND f.FavouriteName = 'FruitJuice') OR
        (p.Name = 'Person8' AND f.FavouriteName = 'Water') OR
        (p.Name = 'Person9' AND f.FavouriteName = 'HotChocolate') OR
        (p.Name = 'Person10' AND f.FavouriteName = 'FruitSmoothie') OR
        (p.Name = 'Person11' AND f.FavouriteName = 'SparklingWater') OR
        (p.Name = 'Person12' AND f.FavouriteName = 'HerbalTea') OR
        (p.Name = 'Person13' AND f.FavouriteName = 'Smoothie') OR
        (p.Name = 'Person14' AND f.FavouriteName = 'Lemonade') OR
        (p.Name = 'Person15' AND f.FavouriteName = 'IcedCoffee') OR
        (p.Name = 'Person16' AND f.FavouriteName = 'FruitJuice') OR
        (p.Name = 'Person17' AND f.FavouriteName = 'GreenTea') OR
        (p.Name = 'Person18' AND f.FavouriteName = 'CoconutWater') OR
        (p.Name = 'Person19' AND f.FavouriteName = 'HerbalTea') OR
        (p.Name = 'Person20' AND f.FavouriteName = 'Water')
    );

-- Person_Favourites for activities (Type 3)
INSERT INTO Person_Favourites (
    PersonID,
    FavouriteID
)
SELECT
    p.PersonID,
    f.FavouriteID
FROM
    Person p
JOIN Favourites f ON
    f.FavouriteType = 3 AND
    (
        (p.Name = 'Person1' AND f.FavouriteName = 'OutdoorRunning') OR
        (p.Name = 'Person2' AND f.FavouriteName = 'Hiking') OR
        (p.Name = 'Person3' AND f.FavouriteName = 'Swimming') OR
        (p.Name = 'Person4' AND f.FavouriteName = 'Traveling') OR
        (p.Name = 'Person5' AND f.FavouriteName = 'Gardening') OR
        (p.Name = 'Person6' AND f.FavouriteName = 'Reading') OR
        (p.Name = 'Person7' AND f.FavouriteName = 'Cycling') OR
        (p.Name = 'Person8' AND f.FavouriteName = 'Hiking') OR
        (p.Name = 'Person9' AND f.FavouriteName = 'Skiing') OR
        (p.Name = 'Person10' AND f.FavouriteName = 'Jogging') OR
        (p.Name = 'Person11' AND f.FavouriteName = 'RockClimbing') OR
        (p.Name = 'Person12' AND f.FavouriteName = 'Yoga') OR
        (p.Name = 'Person13' AND f.FavouriteName = 'Hiking') OR
        (p.Name = 'Person14' AND f.FavouriteName = 'Running') OR
        (p.Name = 'Person15' AND f.FavouriteName = 'Cycling') OR
        (p.Name = 'Person16' AND f.FavouriteName = 'Yoga') OR
        (p.Name = 'Person17' AND f.FavouriteName = 'Gardening') OR
        (p.Name = 'Person18' AND f.FavouriteName = 'Hiking') OR
        (p.Name = 'Person19' AND f.FavouriteName = 'Swimming') OR
        (p.Name = 'Person20' AND f.FavouriteName = 'Hiking')
    );

-- Person_Neighbours
INSERT INTO Person_Neighbours (
    PersonID,
    NeighbourID
)
SELECT
    p.PersonID,
    n.NeighbourID
FROM
    Person p, Neighbours n
WHERE
    (p.Name = 'Person1' AND n.NeighbourEmail = 'neighbourA@email.com') OR
    (p.Name = 'Person2' AND n.NeighbourEmail = 'neighbourC@email.com') OR
    (p.Name = 'Person3' AND n.NeighbourEmail = 'neighbourE@email.com') OR
    (p.Name = 'Person4' AND n.NeighbourEmail = 'neighbourG@email.com') OR
    (p.Name = 'Person5' AND n.NeighbourEmail = 'neighbourI@email.com') OR
    (p.Name = 'Person6' AND n.NeighbourEmail = 'neighbourK@email.com') OR
    (p.Name = 'Person7' AND n.NeighbourEmail = 'neighbourM@email.com') OR
    (p.Name = 'Person8' AND n.NeighbourEmail = 'neighbourO@email.com') OR
    (p.Name = 'Person9' AND n.NeighbourEmail = 'neighbourQ@email.com') OR
    (p.Name = 'Person10' AND n.NeighbourEmail = 'neighbourS@email.com') OR
    (p.Name = 'Person11' AND n.NeighbourEmail = 'neighbourU@email.com') OR
    (p.Name = 'Person12' AND n.NeighbourEmail = 'neighbourW@email.com') OR
    (p.Name = 'Person13' AND n.NeighbourEmail = 'neighbourY@email.com') OR
    (p.Name = 'Person14' AND n.NeighbourEmail = 'neighbourAA@email.com') OR
    (p.Name = 'Person15' AND n.NeighbourEmail = 'neighbourAC@email.com') OR
    (p.Name = 'Person16' AND n.NeighbourEmail = 'neighbourAE@email.com') OR
    (p.Name = 'Person17' AND n.NeighbourEmail = 'neighbourAG@email.com') OR
    (p.Name = 'Person18' AND n.NeighbourEmail = 'neighbourAI@email.com') OR
    (p.Name = 'Person19' AND n.NeighbourEmail = 'neighbourAK@email.com') OR
    (p.Name = 'Person20' AND n.NeighbourEmail = 'neighbourAM@email.com');

-- Add second neighbours for each person
INSERT INTO Person_Neighbours (
    PersonID,
    NeighbourID
)
SELECT
    p.PersonID,
    n.NeighbourID
FROM
    Person p, Neighbours n
WHERE
    (p.Name = 'Person1' AND n.NeighbourEmail = 'neighbourB@email.com') OR
    (p.Name = 'Person2' AND n.NeighbourEmail = 'neighbourD@email.com') OR
    (p.Name = 'Person3' AND n.NeighbourEmail = 'neighbourF@email.com') OR
    (p.Name = 'Person4' AND n.NeighbourEmail = 'neighbourH@email.com') OR
    (p.Name = 'Person5' AND n.NeighbourEmail = 'neighbourJ@email.com') OR
    (p.Name = 'Person6' AND n.NeighbourEmail = 'neighbourL@email.com') OR
    (p.Name = 'Person7' AND n.NeighbourEmail = 'neighbourN@email.com') OR
    (p.Name = 'Person8' AND n.NeighbourEmail = 'neighbourP@email.com') OR
    (p.Name = 'Person9' AND n.NeighbourEmail = 'neighbourR@email.com') OR
    (p.Name = 'Person10' AND n.NeighbourEmail = 'neighbourT@email.com') OR
    (p.Name = 'Person11' AND n.NeighbourEmail = 'neighbourV@email.com') OR
    (p.Name = 'Person12' AND n.NeighbourEmail = 'neighbourX@email.com') OR
    (p.Name = 'Person13' AND n.NeighbourEmail = 'neighbourZ@email.com') OR
    (p.Name = 'Person14' AND n.NeighbourEmail = 'neighbourAB@email.com') OR
    (p.Name = 'Person15' AND n.NeighbourEmail = 'neighbourAD@email.com') OR
    (p.Name = 'Person16' AND n.NeighbourEmail = 'neighbourAF@email.com') OR
    (p.Name = 'Person17' AND n.NeighbourEmail = 'neighbourAH@email.com') OR
    (p.Name = 'Person18' AND n.NeighbourEmail = 'neighbourAJ@email.com') OR
    (p.Name = 'Person19' AND n.NeighbourEmail = 'neighbourAL@email.com') OR
    (p.Name = 'Person20' AND n.NeighbourEmail = 'neighbourAN@email.com');
