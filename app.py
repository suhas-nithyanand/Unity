#!flask/bin/python
from flask import Flask, jsonify
from flask import request
import json
import datetime


app = Flask(__name__)

''' Standard error messages used in the program'''
project_created = {"message":"campaign is successfully created"}
project_expired = {"message":"Project has already expired, hence storing it in expiredProjects.txt"}
project_notFound = {"message":"no project found"}
projectid_notPresent = {"message":"projectid is not present"}
parameters_missing = {"message":"One or more of input parameters is missing for create Project"}

filename = "projects.txt"
expFilename = "expiredProjects.txt"

''' Will return True if the eDate is older than todays date (i.e it has expired)'''
def checkExpiredDate(eDate):
    #Sample of incoming expired date: 05202017 00:00:00
    expDate = datetime.datetime(int(eDate[4:8]),int(eDate[0:2]),int(eDate[2:4]),int(eDate[9:11]),int(eDate[12:14]),int(eDate[15:17]))
    today = datetime.datetime.today()
    return expDate < today


def highestPricedProject():
    maxProjectCost = 0
    project = {}
    pricedProject = {"message":"return highest priced project"}
    
    with open('projects.txt') as fp:
        for line in fp:
            data = json.loads(line)
            '''Service should never return a project if projectUrl is null'''
            if data['projectUrl'] == None:
                continue
            #'''Service should never return a project if enabled is False'''
            elif data['enabled'] == str(False):
                continue
            if maxProjectCost < data['projectCost']:
                maxProjectCost = data['projectCost']
                project = data      
    if (bool(project)): 
        return jsonify(project)
    else:
        return jsonify(project_notFound)

''' Function is called when one of the parametrs(county,number,keyword) is not None'''
def matchParams(country,number,keyword):

    maxProjectCost = 0
    project = {}
    with open('projects.txt') as fp:
        for line in fp:
            numFlag = False
            kwFlag = False
            
            data = json.loads(line)
            '''Service should never return a project if projectUrl is null'''
            if data['projectUrl'] == None:
                continue
            #'''Service should never return a project if enabled is False'''
            elif data['enabled'] == str(False):
                continue
            '''number,country and keyword exists'''
            if (number != None) and (country != None) and (keyword != None):
                for kwords in data['targetKeys']:
                    if kwords['number'] == int(number):
                        numFlag = True
                    if kwords['keyword'] == keyword:
                        kwFlag = True
                    if (kwFlag and numFlag):            
                        for targetCountry in data['targetCountries']:
                            if country == targetCountry:
                                if maxProjectCost < data['projectCost']:
                                    maxProjectCost = data['projectCost']
                                    project = data                                  
            else:
                '''number and keyword exists'''
                if (number != None) and (country == None) and (keyword != None):
                    for kwords in data['targetKeys']:
                        if kwords['number'] == int(number):
                            numFlag = True
                        if kwords['keyword'] == keyword:
                            kwFlag = True
                        if (kwFlag and numFlag):            
                            if maxProjectCost < data['projectCost']:
                                maxProjectCost = data['projectCost']
                                project = data
                #'''number and country exists'''
                elif (number != None) and (country != None) and (keyword == None ):
                    for kwords in data['targetKeys']:
                        if kwords['number'] == int(number):         
                            for targetCountry in data['targetCountries']:
                                if country == targetCountry:
                                    if maxProjectCost < data['projectCost']:
                                        maxProjectCost = data['projectCost']
                                        project = data
                
                #'''Keyword and country exists'''
                elif (number == None) and (country != None) and (keyword != None):
                    for kwords in data['targetKeys']:
                        if kwords['keyword'] == keyword:         
                            for targetCountry in data['targetCountries']:
                                if country == targetCountry:
                                    if maxProjectCost < data['projectCost']:
                                        maxProjectCost = data['projectCost']
                                        project = data   
                else:
                    if (country != None):
                        '''only country exists'''
                        for targetCountry in data['targetCountries']:
                            if country == targetCountry:
                                if maxProjectCost < data['projectCost']:
                                    maxProjectCost = data['projectCost']
                                    project = data
                    elif (keyword != None):
                        '''only number exists'''
                        for kwords in data['targetKeys']:
                            if kwords['number'] == int(number):         
                                if maxProjectCost < data['projectCost']:
                                    maxProjectCost = data['projectCost']
                                    project = data
                    elif (number != None):
                        '''only keyword exists'''
                        for kwords in data['targetKeys']:
                            if kwords['keyword'] == keyword:         
                                if maxProjectCost < data['projectCost']:
                                    maxProjectCost = data['projectCost']
                                    project = data
    if (bool(project)): 
        return jsonify(project)
    else:
        return jsonify(project_notFound)

''' Rest end point createproject '''
@app.route('/createproject', methods=['POST'])
def create_project():
    if( ('id' in request.json) and ('projectName' in request.json) and ('creationDate' in request.json) and ('expiryDate' in request.json) and ('enabled' in request.json) and ('projectCost' in request.json) and ('projectUrl'in request.json) and ('targetKeys' in request.json) and ('targetCountries' in request.json)):
        project = {
            'id': request.json['id'],
            'projectName': request.json['projectName'],
            'creationDate': request.json.get('creationDate'),
            'expiryDate': request.json.get('expiryDate'),
            'enabled': request.json.get('enabled'),
            'projectCost': request.json.get('projectCost'),
            'projectUrl': request.json.get('projectUrl'),
            'targetKeys': request.json.get('targetKeys'),
            'targetCountries': request.json.get('targetCountries')
        }
    else: return jsonify(parameters_missing),200
        
    checkValue = checkExpiredDate(project['expiryDate'])
    
    #if the project is already expired, it is stored in expired.txt
    if (checkValue):
        target = open(expFilename, 'a')
        target.write(json.dumps(project))
        target.write("\n")
        return jsonify(project_expired), 200
         
    target = open(filename, 'a')
    target.write(json.dumps(project))
    target.write("\n")
    return jsonify(project_created), 200

''' Rest end point requestproject '''
@app.route('/requestproject', methods=['GET'])
def request_project():
    rval = {}
    dataList = []
    numFlag = False
    kwFlag = False
    projectid = request.args.get('projectid')
    country = request.args.get('country')
    number = request.args.get('number')
    keyword = request.args.get('keyword')
    
    '''Service should return a project with highest price if no url parameter is sent in request'''
    if (projectid == None and country == None and number == None and keyword == None):
        rval = highestPricedProject()
        return rval,200
        
    #'''Service should return a project with highest price when multiple projects with same parameters are found'''
    elif (projectid == None) and (country != None or number != None or keyword != None):
        rval = matchParams(country,number,keyword)
        return rval,200
          
    with open('projects.txt') as fp:
        for line in fp: 
            data = json.loads(line)
            '''Service should never return a project if projectUrl is null'''
            if data['projectUrl'] == None or data['projectUrl'] == "":
                continue
            elif data['enabled'] == str(False):
                continue
            #'''Service should never return a project if project is expired'''
            elif checkExpiredDate(data['expiryDate']):
                continue
            if data['id'] == int(projectid):
                return jsonify(data),200  
        
    return jsonify(project_notFound)

@app.route('/')
def mainDomain():
    welcome = {"message": "Unity Coding challenge. Please call the required rest endpoint."}
    return jsonify(welcome),200
    
if __name__ == '__main__':
    import logging
    logging.basicConfig(filename='restWebService.log',level=logging.DEBUG)
    app.run(debug=True)
