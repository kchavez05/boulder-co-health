function init() {
    // Grab a reference to the dropdown select element
    var selector = d3.select("#selDataset");
    // Use the list of Facility names to populate the select options
    d3.json("web_facility_data.json").then((data) => {
      var facNames = data.names
      facNames.forEach((facility) => {
        selector
          .append("option")
          .text(facility)
          .property("value", facility);
      });
      // Use the first facility from the list to build the initial data read-outs
      var firstFacility = facNames[0];
      buildMetadata(firstFacility);
      buildViolations(firstFacility);
    });
  };

  // Initialize the dashboard
  init();
  
function optionChanged(newFacility) {
  // Fetch new data each time a new facility is selected
  buildMetadata(newFacility);
  buildViolations(newFacility);
  
};
  
// Facility MetaData Panel 
function buildMetadata(facility) {
  d3.json("web_facility_data.json").then((data) => {
    var metadata = data.metadata;
    // Filter the data for the object with the desired facility name
    var resultArray = metadata.filter(facObj => facObj.facility_name_plus == facility);
    var result = resultArray[0];
    // Use d3 to select the panel with id of `#fac-metadata`
    var PANEL = d3.select("#fac-metadata");
    // Use `.html("") to clear any existing metadata
    PANEL.html("");
    // Format the display of the data from the JSON
    PANEL.append("h2").text(result.facility_name);
    PANEL.append("h4").append("em").text(" in " + result.city);
    PANEL.append("h6").text("Facility ID: ").append("infodisplay").text(result.facility_id);
    PANEL.append("h6").text("Google Rating: ").append("infodisplay").text(result.rating);
    PANEL.append("h6").text("Total Google Ratings: ").append("infodisplay").text(result.total_ratings)
    PANEL.append("h6").text("Average Inspection Score: ").append("infodisplay").text(result.avg_inspection_score);
    PANEL.append("h6").text("Average Count of Violations: ").append("infodisplay").text(result.avg_violations_count);

  }
)};

// Facility Violation Data
function buildViolations(facility) {
  d3.json("web_facility_data.json").then((data) => {
    var violations = data.violations;
    // Filter the data for the object with the desired facility name
    var resultArray = violations.filter(facObj => facObj.facility_name_plus == facility);
    var result = resultArray[0];
    // Use d3 to select the panel with id of `#fac-metadata`
    var PANEL = d3.select("#fac-violation-data");
    // Use `.html("") to clear any existing metadata
    PANEL.html("");
    // function to split the underscore-sep values of the violations from their place in the Json 
    // and populate them on different lines for easy reading
    let availableData = result.violations;
    replaceCommaLine(availableData);
    function replaceCommaLine(data) {
        //convert string to array and remove whitespace
        let dataToArray = data.split('_').map(item => item.trim());
        // loop over the values in the array and add each to to the correctly formatted element
        return Object.values(dataToArray).forEach(val => {PANEL.append("violationsdis").text(`${val}`)})
    }
    });
};


    
