# Unity Coding challenge - Rest Web Service

# Setting up the project in Linux Ubuntu
- cd to unity-coding-challenge directoryy
- we need to install Virtual Env: $ sudo apt-get install python-virtualenv
- $ virtualenv flaskenv
- $ source flaskenv/bin/activate
- we need to install flask: $ pip install flask flask-restful
- $ python app.py
- The server runs on port 5000 

# logging

- Python logger is used to store logs
- Filename for the log file is restWebService.log
- It logs every request and response that is handled by the application
- Any errors occured will also be logged in the same file

# Testing the Rest Web Service

- Testing is done using a bash script which has Curl requests
- I had also used postman to test the web service, but I thought it is convenient to present the test cases as a bash script.

- All the test cases have explanation is in the form of comments above them.
- The output for each request is stored in one of the two files - projects.txt, expiredProjects.txt
- Also reponse for each curl request will be displayed in the terminal. 


# Some Ambigious cases
- When projectID is not present and there are two or more projects with the same project cost which match with the given parameters.
  The first project which is found in database collection is returned.

# Some Assumptions for which error handling is not performed
- Input parameter expriedDate is expected to be in a certain format. Code is written only to handle that format.
-
   

