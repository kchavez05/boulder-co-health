# Boulder County Health Scores and Reviews

## Background

Members of the group have worked in the restaurant industry and have experience with the inspection process and that database. 

Additionally, all members of the group have at one time or another provided a review of a restaurant. We started to wonder if there is a correlation.


## Objective / hypothesis
Our group selected the topic of health inspection scores from Boulder Country, Colorado restaurants and the cooresponding reviews provided to those establishments on Yelp and Google.

Can we predict a restaurants health inspection score based on the Yelp or Google reviews?
## Questions to answer with the data
    - Can we predict the star rating of a restaurant based on their health inspection scores?
    - Is there a particular category of health violations that cause lower ratings?

Steps of process
1. find data sources 
2. clean the data
3. create a database
4. create a machine learning model
5. Analyze results
6. Create a dashboard 
7. Build an interactive website to display findings 

## (1) Data Sources and Resources

#### Boulder County Health Inspection Data 
    - (https://www.bouldercounty.org/families/food/restaurant-inspection-data/)
    - This dataset includes public state data for each restautant in boulder county

#### Rating and Location Data
    - lattitude and longitude and google restaurant rating  

#### Tools
    -     


## (2) Scrubbing the data

1. Filtering the health inspection data to look at only restaurants and only routine/regular restaurants inspections
filtered typeOfFacility, typeOfInspection

2. Using google geocode API, pulled the google coordinates for the restaurants into the data set. Used the address provided in the inspection data as the key for matching the google coordinates 
    note for future: just pull the enitre geometry

3. Using google Places API




## (3) Database Assembly



## (4) Deployed Machine Learning Models
#### Decision Tree 

    The Boulder County Health Inspections Scores were obtained. The features selected for the first analysis were the Health Inspection Score, Facility Type and Facility Category. These features were used to train the model in trying to predict the Yelp Rating per facility.

The first step in engineering the features for the machine learning model used the filtered dataset to:

 - Eliminate all location data so as not to overburden the model
 - Average the inspection scores for all routine and regular health inspections by facility
    - This was difficult to eliminate the duplicate rows without losing details (pivot table and merge)
 - Bin the averaged health inspection scores to match the Health Department ratings
 - Create randomized Yelp Ratings to test the model
 - Use Random Forest model as it is fast, simple and flexible
 - Easy to use during the initial model development process, to see how it performs
 - Provides a good indicator of the importance it assigns to features
 - Limitations include: fast to train, but quite slow to create predictions once they are trained
 - May need to switch to a neural network, for the second phase which has a lot of different feature types



potential features:
type of facility
category of facility


## Summary

## Results

## Reccomendations?
