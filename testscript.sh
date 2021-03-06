#!/bin/bash
#Unity Coding Challenge
#Testing the Rest Webservice

# Adding different types of data to the projects.txt using createProject function

# The data object has all the parameters
curl -X POST -H "Content-Type: application/json" \--data '{"id":20,"projectName":"test-project-1","creationDate":"05112017 00:00:00","expiryDate":"05202018 00:00:00","enabled": "True","targetCountries":["China"],"projectCost":3500,"projectUrl":"http://www.unity3d.com","targetKeys":[{"number":25,"keyword":"movie"},{"number":30,"keyword":"sports"}]}' \http://localhost:5000/createproject

# Enabled is false in the data object
curl -X POST -H "Content-Type: application/json" \--data '{"id": 1, "projectName": "test project number 1","creationDate": "05112017 00:00:00","expiryDate": "05202018 00:00:00", "enabled": "True","targetCountries": ["USA", "CANADA", "MEXICO", "BRAZIL"],"projectCost": 5.5,"projectUrl": "http://www.unity3d.com","targetKeys": [{"number": 25,"keyword": "movie"},{ "number": 30,"keyword": "sports"}]}' \http://localhost:5000/createproject 

# Project URL is empty
curl -X POST -H "Content-Type: application/json" \--data '{"id": 2, "projectName": "test project number 2","creationDate": "05112017 00:00:00","expiryDate": "05202018 00:00:00", "enabled": "True","targetCountries": ["USA", "CANADA", "MEXICO", "BRAZIL"],"projectCost": 5.5,"projectUrl": "","targetKeys": [{"number": 25,"keyword": "movie"},{ "number": 30,"keyword": "sports"}]}' \http://localhost:5000/createproject

# same project details with a larger project cost
curl -X POST -H "Content-Type: application/json" \--data '{"id": 3, "projectName": "test project number 3","creationDate": "05112017 00:00:00","expiryDate": "05202018 00:00:00", "enabled": "True","targetCountries": ["USA", "CANADA", "MEXICO", "BRAZIL"],"projectCost": 500.5,"projectUrl": "","targetKeys": [{"number": 25,"keyword": "movie"},{ "number": 30,"keyword": "sports"}]}' \http://localhost:5000/createproject  

# The project has expired 
curl -X POST -H "Content-Type: application/json" \--data '{"id": 4, "projectName": "test project number 4","creationDate": "05112018 00:00:00","expiryDate": "05202016 00:00:00", "enabled": "True","targetCountries": ["USA", "CANADA", "MEXICO", "BRAZIL"],"projectCost": 500.5,"projectUrl": "","targetKeys": [{"number": 25,"keyword": "movie"},{ "number": 30,"keyword": "sports"}]}' \http://localhost:5000/createproject

# The project has expired
curl -X POST -H "Content-Type: application/json" \--data '{"id": 5, "projectName": "test project number 5","creationDate": "05112018 00:00:00","expiryDate": "05202016 00:00:00", "enabled": "True","targetCountries": ["USA", "CANADA", "MEXICO", "BRAZIL"],"projectCost": 500.5,"projectUrl": "","targetKeys": [{"number": 25,"keyword": "movie"},{ "number": 30,"keyword": "sports"}]}' \http://localhost:5000/createproject

# Project with new details
curl -X POST -H "Content-Type: application/json" \--data '{"id": 6, "projectName": "test project number 6","creationDate": "05112017 00:00:00","expiryDate": "05202018 00:00:00", "enabled": "True","targetCountries": ["USA", "UK", "ITALY", "RUSSIA"],"projectCost": 350.5,"projectUrl": "http://suhasn.com","targetKeys": [{"number": 2,"keyword": "movie"},{ "number": 3,"keyword": "sports"}]}' \http://localhost:5000/createproject

# Project which has enabled as False
curl -X POST -H "Content-Type: application/json" \--data '{"id": 7, "projectName": "test project number 7","creationDate": "05112017 00:00:00","expiryDate": "05202018 00:00:00", "enabled": "False","targetCountries": ["USA", "INDIA", "ITALY", "RUSSIA"],"projectCost": 3500000.5,"projectUrl": "http://suhasn.com","targetKeys": [{"number": 222,"keyword": "movie"},{ "number": 3,"keyword": "sports"}]}' \http://localhost:5000/createproject

# Project URL is empty
curl -X POST -H "Content-Type: application/json" \--data '{"id": 8, "projectName": "test project number 7","creationDate": "05112017 00:00:00","expiryDate": "05202018 00:00:00", "enabled": "False","targetCountries": ["USA", "INDIA", "ITALY", "RUSSIA"],"projectCost": 3500000.5,"projectUrl": "","targetKeys": [{"number": 222,"keyword": "movie"},{ "number": 3,"keyword": "sports"}]}' \http://localhost:5000/createproject

# Testing Request project Rest Web Service

#Retrieve a single project from the database [Case1: all parameters present].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?projectid=2\&country=USA\&number=25\&keyword=sports

# Retrieve a single project from the database [Case2: projectid not present].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?country=USA\&number=25\&keyword=sports

# Retrieve a single project from the database [Case3: projectid and keyword not present].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?country=USA\&number=25

# Retrieve a single project from the database [Case4: projectid and country not present].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?number=25\&keyword=sports

# Retrieve a single project from the database [Case5: projectid,number and keyword not present].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?country=USA

# Retrieve a single project from the database [Case6: all parameters absent].corressponding projectid not present
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject

# Retrieve a single project from the database [Case7: corressponding projectid not present]
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?projectid=20000

#Retrieve a single project from the database [Case8: all parameters match but enabled is False].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?projectid=7\&country=INDIA\&number=222\&keyword=sports

#Retrieve a single project from the database [Case9: projectid and country not present, but enabled is False].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?number=222\&keyword=sports

#Retrieve a single project from the database [Case9: projectid and country not present, but projectUrl is null].
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/requestproject?number=222\&keyword=sports

# Additional cases which break the Rest web service, which is handled

# Project ID not present
curl -X POST -H "Content-Type: application/json" \--data '{"projectName": "test project number 7","creationDate": "05112017 00:00:00","expiryDate": "05202018 00:00:00", "enabled": "True","targetCountries": ["USA", "UK", "ITALY", "RUSSIA"],"projectCost": 350.5,"projectUrl": "http://suhasn.com","targetKeys": [{"number": 2,"keyword": "movie"},{ "number": 3,"keyword": "sports"}]}' \http://localhost:5000/createproject

# Hitting the base domain gives an pleasant error message
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/

