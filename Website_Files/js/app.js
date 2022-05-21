function init() {
    // Grab a reference to the dropdown select element
    var selector = d3.select("#selDataset");
  
    // Use the list of sample names to populate the select options
    d3.json("web_facility_data.json").then((data) => {
      var facNames = data.names

      facNames.forEach((facility) => {
        selector
          .append("option")
          .text(facility)
          .property("value", facility);
      });
  
      // Use the first sample from the list to build the initial plots
      var firstFacility = facNames[0];
    //   buildCharts(firstSample);
      buildMetadata(firstFacility);
    });
  }
  
  // Initialize the dashboard
  init();
  
  function optionChanged(newFacility) {
    // Fetch new data each time a new sample is selected
    buildMetadata(newFacility);
    // buildCharts(newSample);
    
  }
  
  // Facility Data Panel 
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
  
      // Use `Object.entries` to add each key and value pair to the panel
      // Hint: Inside the loop, you will need to use d3 to append new
      // tags for each key-value in the metadata.
      // Object.entries(result).forEach(([key, value]) => {
      //   PANEL.append("h6").text(`${key.toUpperCase()}: ${value.to}`);
      // });

      PANEL.append("h3").text(result.facility_name);
      PANEL.append("h3").append("em").text(" in " + result.city);
      PANEL.append("h6").text("Facility ID: ").append("infodisplay").text(result.facility_id);
      // PANEL.append("small").text(result.facility_id);
      PANEL.append("h6").text("Google Rating: " +result.rating);
      PANEL.append("h6").text("Total Google Ratings: " +result.total_ratings)
      PANEL.append("h6").text("Average Inspection Score: " +result.avg_inspection_score);
      PANEL.append("h6").text("Average Count of Violations: " +result.avg_violations_count);
  
  
    
    // Use d3 to select the panel with id of `#fac-violation data`
    var PANEL = d3.select("#fac-violation-data");
  
    // Use `.html("") to clear any existing metadata
    PANEL.html("");

    PANEL.append("h3").text("Recieved Violations");
    PANEL.append("h6").text("stuff goes here");


  });

  }


    
