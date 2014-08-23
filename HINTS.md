Bulk Data Testing - Hints
--

### Writing the test
* Create a loop that executes 200 times and adds a new Lead to a list of leads
* Insert that list
* Loop over the _fetched_ leads and verify they are converted

### Too many SOQL queries
* Does the data returned from the SOQL query change with every query? Can this be moved elsewhere and only called once?

### Too many DML statements
* Is there a way to bulk convert leads? [Read more](https://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_convertlead.htm) on the convert lead method

### Bonus test
* Don't forget to keep track of which leads are suppose to be converted and which are not
* Keep track of these in separate maps/lists
* Combine them before inserting them
* Make sure you get back all the results you expect