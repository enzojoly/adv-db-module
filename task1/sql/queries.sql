-- Query 1: Display person's name and age in years
SELECT
    p.Name,
    calculate_age(p.DOB) AS Age
FROM
    Person p
ORDER BY
    p.Name;
/*
Expected Output:
Name        Age
Person1     30
Person2     31
Person3     33
Person4     27
Person5     41
...etc
*/

-- Query 2: Group persons by favorite drink and return average age
SELECT
    f.FavouriteName AS FavouriteDrink,
    ROUND(AVG(calculate_age(p.DOB))::NUMERIC, 2) AS AverageAge
FROM
    Person p
JOIN Person_Favourites pf
    ON p.PersonID = pf.PersonID
JOIN Favourites f
    ON pf.FavouriteID = f.FavouriteID
WHERE
    f.FavouriteType = 2 -- Type 2 for drinks
GROUP BY
    f.FavouriteName
ORDER BY
    AverageAge DESC;
/*
Expected Output:
FavouriteDrink    AverageAge
GreenTea          35.50
HerbalTea         34.50
Coffee            31.00
Water             31.00
...etc
*/

-- Query 3: Display average age of people who like Hiking
SELECT
    ROUND(AVG(calculate_age(p.DOB))::NUMERIC, 2) AS AverageAgeOfHikers
FROM
    Person p
JOIN Person_Favourites pf
    ON p.PersonID = pf.PersonID
JOIN Favourites f
    ON pf.FavouriteID = f.FavouriteID
WHERE
    f.FavouriteType = 3 -- Type 3 for activities
    AND f.FavouriteName = 'Hiking';
/*
Expected Output:
AverageAgeOfHikers
31.83
*/

-- Query 4: Display total number of people from each City
SELECT
    a.City,
    COUNT(DISTINCT p.PersonID) AS TotalPeople
FROM
    Person p
JOIN Person_Addresses pa
    ON p.PersonID = pa.PersonID
JOIN Addresses a
    ON pa.AddressID = a.AddressID
GROUP BY
    a.City
ORDER BY
    TotalPeople ASC;
/*
Expected Output:
City          TotalPeople
Bristol       1
Cambridge     1
Leicester     1
Liverpool     1
Manchester    1
...etc
*/

-- Query 5: Display name of person(s) whose neighbour is neighbour C
SELECT DISTINCT
    p.Name
FROM
    Person p
JOIN Person_Neighbours pn
    ON p.PersonID = pn.PersonID
JOIN Neighbours n
    ON pn.NeighbourID = n.NeighbourID
WHERE
    n.NeighbourName = 'NeighbourC'
ORDER BY
    p.Name;
/*
Expected Output:
Name
Person2
*/
