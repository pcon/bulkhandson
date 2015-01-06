Bulk Data Testing - Hands On Training
--

1. [Signup](http://bit.ly/bulkhandson) for Developer Edition Org
  * __Email:__ Any email address you can currently reach
  * __Username:__ Anything in the form of an email _(Example: bob+bulkhandson@example.com)_
2. Add a custom field to your Lead object
  1. Navigate to setup → Customize → Leads → Fields → New
  2. Select Text
  3. Enter data and click Next
     * __Field Label:__ Web Form
     * __Length:__ 255
     * __Field Name:__ WebForm
  4. Click Next
  5. Click Save
3. Copy the [trigger](src/triggers/AutoConverter.trigger)
4. Copy the [test](src/classes/AutoConverter_Test.cls)
5. Review the trigger and test code.
  * Note the following methods
     * __createLead:__ This methods generates a test lead
     * __makeFreeTrial:__ This methods makes a lead a 'Free Trial' lead
     * __fetchLeads:__ Queries all of your leads
6. Create a new test that inserts 200 leads at one time that are all 'Not Free Trail' leads
7. Create a new test that inserts 200 leads at one time that are all 'Free Trail' leads
8. Run that tests and note the errors
9. Update the trigger to not error when you insert your list of leads
10. Compare your [solution](solution)

_Need help? Checkout some [hints](HINTS.md)_

Bonus
--
* Write a bulk test that creates 200 leads. Half are 'Free Trial' half not. Assert in your test that all 'Free Trial' leads have been auto converted while your 'Not Free Trial' leads are not.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/pcon/bulkhandson/trend.png)](https://bitdeli.com/free "Bitdeli Badge")