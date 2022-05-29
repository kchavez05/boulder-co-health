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
      buildMetadata(firstFacility);
      buildViolations(firstFacility);
    });
  }
  
  // Initialize the dashboard
  init();
  
  function optionChanged(newFacility) {
    // Fetch new data each time a new facility is selected
    buildMetadata(newFacility);
    buildViolations(newFacility);
    
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

      PANEL.append("h3").text(result.facility_name);
      PANEL.append("h4").append("em").text(" in " + result.city);
      PANEL.append("h6").text("Facility ID: ").append("infodisplay").text(result.facility_id);
      // PANEL.append("small").text(result.facility_id);
      PANEL.append("h6").text("Google Rating: ").append("infodisplay").text(result.rating);
      PANEL.append("h6").text("Total Google Ratings: ").append("infodisplay").text(result.total_ratings)
      PANEL.append("h6").text("Average Inspection Score: ").append("infodisplay").text(result.avg_inspection_score);
      PANEL.append("h6").text("Average Count of Violations: ").append("infodisplay").text(result.avg_violations_count);
  
    }
  )}
    // Use d3 to select the panel with id of `#fac-violation data`
  function buildViolations(facility) {
    d3.json("web_facility_data.json").then((data) => {
      var violations = data.violations;
      // Filter the data for the object with the desired facility name
      var resultArray = violations.filter(facObj => facObj.facility_name_plus == facility);
      var result = resultArray[0];
      console.log(result)
      // Use d3 to select the panel with id of `#fac-metadata`
      var PANEL = d3.select("#fac-violation-data");
  
      // Use `.html("") to clear any existing metadata
      PANEL.html("");

      // PANEL.append("h3").text("Recieved Violations");
      // PANEL.append("infodisplay").text(result.violations);
      // Object.entries(result.violations).forEach((value) => {
        let availableData = result.violations;
        console.log(availableData)
        replaceCommaLine(availableData);
        function replaceCommaLine(data) {
            //convert string to array and remove whitespace
            let dataToArray = data.split('_').map(item => item.trim());
            console.log(dataToArray)
            // let manipData = dataToArray[dataToArray.length - 1]
            // console.log(manipData)
            // let lineBreak = "<br>"
            //convert array to string replacing comma with new line
            // return dataToArray.join(`${lineBreak}`)
            return Object.values(dataToArray).forEach(val => {PANEL.append("violationsdis").text(`${val}`)})
        }

        
        // PANEL.append("infodisplay").text(`${desiredData}`);
      });
    // });
      // PANEL.append("h3").text(result.facility_name);
      // PANEL.append("h4").append("em").text(" in " + result.city);
      // PANEL.append("h6").text("Facility ID: ").append("infodisplay").text(result.facility_id);
      // // PANEL.append("small").text(result.facility_id);
      // PANEL.append("h6").text("Google Rating: ").append("infodisplay").text(result.rating);
      // PANEL.append("h6").text("Total Google Ratings: ").append("infodisplay").text(result.total_ratings)
      // PANEL.append("h6").text("Average Inspection Score: ").append("infodisplay").text(result.avg_inspection_score);
      // PANEL.append("h6").text("Average Count of Violations: ").append("infodisplay").text(result.avg_violations_count);

    
    // var PANEL = d3.select("#fac-violation-data");
  
    // // Use `.html("") to clear any existing metadata
    // PANEL.html("");

    // PANEL.append("h3").text("Recieved Violations");
    // PANEL.append("infodisplay").text(result.violations[""]);
    //  console.log(result.violations[""]);
    // // let availableData = result.violations;
    // // let desiredData = replaceCommaLine(availableData);
    // // function replaceCommaLine(data) {
    // //     //convert string to array and remove whitespace
    // //     let dataToArray = data.split(',').map(item => item.trim());
      
    // //     //convert array to string replacing comma with new line
    // //     return dataToArray.join("\n");

    // // }
    // // Object.values(result.violations).forEach(([key, value]) => {
    // //   PANEL.append("h6").text(`${key.append("br")} ${value}`);

    // // });
    // // console.log(result.violations[0]);


    // // PANEL.append("h6").append("infodisplay").text(desiredData);


  }


    
