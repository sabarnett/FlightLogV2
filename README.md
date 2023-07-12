# RC Flight Log Version 2
Anyone flying a remote control aircraft is supposed to keep a flight log showing
basic details of the flight. These details can be a paper log or can be an electronic
log, as the user prefers. The main requirement is to be able to show these details for
all flights in the pre virus two years.

This app is intended to fill the bulk of the requirements. 

It is also my first significant app built for the Apple platform, so the code may well be
overly complex or badly formed. Who knows... I'm just trying to learn.

## Dependencies

Note that this project has dependencies on my UtilityViews and UtilityClasses repos for various 
views and for my developer log.

### Reporting

As of July 12, the app now includes rudimentary reporting. This is PDF based, the PDF being generated using
a new framework library called PDFTools. So, the project now has a third project dependency on the PDFTools 
framework in my repos.

Reporting is evolving slowly, but the pilot, aircraft and flight reports are complete and contain all the
specific details found on the detail screens. I do have plans for extending the reporting and fiddling
with the styles I have defined, but these are not priority tasks at this time.
