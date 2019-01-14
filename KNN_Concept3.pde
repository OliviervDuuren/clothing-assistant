PImage img;

Table csvData;
Table wardrobe;
Table outfits;
Table favoriteColor;
Table favoriteStyle;
Table newprofile;
Table genderExclusionData;
Table occassionExclusionData;
Table outfitData1;
Table outfitData2;
Table outfitData3;
Table combinedProfiles;
String fileName = "data/distanceCalculated.csv";
String fileNameGender = "data/genderExcluded.csv";
String fileNameoutfitData4 = "data/profiles/4.csv";

int k = 3;
int tableLength = 0;

//colors
int black = 0;
int grey = 0;
int white = 0;
int yellow = 0;
int red = 0;
int blue = 0;
int rowCount = 0;

//styles
int one = 0;
int two = 0;
int three = 0;
int four = 0;
int five = 0;
int rowCount1 = 0;

//newprofile
int rowCount2 = 0;
int Amount1 = 0;
int Amount2 = 0;
int Amount3 = 0;


//style, profession, color, gender
float [] dataPoint = { 3, 2, 3, 0};

//temperature, occasion, ranking
float [] dataPoint2 = {29, 1, 5};

void setup() {
  size(1280, 720);

  //Initiate the dataList and set the header of table
  csvData = loadTable("profiles.csv", "header");
  wardrobe = loadTable("data/wardrobe/9.csv", "header");
  outfits = loadTable("data/profiles/3.csv", "header");
  newprofile = loadTable("data/profiles/new.csv", "header");
  combinedProfiles = loadTable("data/profiles/combinedProfiles.csv", "header");
  
  genderExclusionData = new Table();
  genderExclusionData.addColumn("Index");
  genderExclusionData.addColumn("Style");
  genderExclusionData.addColumn("Profession");
  genderExclusionData.addColumn("Color");
  genderExclusionData.addColumn("distance");
  genderExclusionData.addColumn("DataBase");
  genderExclusionData.clearRows();
  
  occassionExclusionData = new Table();
  occassionExclusionData.addColumn("Index");
  occassionExclusionData.addColumn("Style");
  occassionExclusionData.addColumn("Profession");
  occassionExclusionData.addColumn("Color");
  occassionExclusionData.addColumn("distance");
  occassionExclusionData.addColumn("DataBase");
  occassionExclusionData.clearRows();
  
  favoriteColor = new Table();
  favoriteColor.addColumn("Color");
  favoriteColor.addColumn("Amount");
  favoriteColor.addColumn("ColorIndex");
  
  favoriteStyle = new Table();
  favoriteStyle.addColumn("Style");
  favoriteStyle.addColumn("Amount");
  favoriteStyle.addColumn("StyleIndex");
}

void draw() {
  background(255);
  if (wardrobe != null){
    int i = 0;
    checkColor (black, "black");
    checkColor (grey, "grey");
    checkColor (white, "white");
    checkColor (yellow, "yellow");
    checkColor (red, "red");
    checkColor (blue, "blue");
    
    favoriteColor.sortReverse("Amount");
    saveTable(favoriteColor, "data/favoriteColor.csv");
    
    TableRow row = favoriteColor.getRow(0);
    String favoriteColor = row.getString("Color");
    int ColorIndex = row.getInt("ColorIndex");
    
    dataPoint[2] = ColorIndex;
    
    
    checkStyle (one, "1");
    checkStyle (two, "2");
    checkStyle (three, "3");
    checkStyle (four, "4");
    checkStyle (five, "5");
    
    favoriteStyle.sortReverse("Amount");
    saveTable(favoriteStyle, "data/favoriteStyle.csv");
    
    TableRow row1 = newprofile.getRow(rowCount2);
    int favoriteStyle = row1.getInt("Style");
    int StyleIndex = row1.getInt("day");
    
    println("favorite style =" + favoriteStyle);
    println();

  }
  
  if (csvData != null) {
    //exclude other gender
    for (int i = 0; i < csvData.getRowCount(); i++) {
      TableRow row = csvData.getRow(i);
      int index = row.getInt("Index");
      int styleGender = row.getInt("Style");
      int professionGender = row.getInt("Profession");
      int ColorGender = row.getInt("Color");
      int gender = row.getInt("Gender");
      String fileLocation = row.getString("Database");
      if (gender == dataPoint[3]) {
        TableRow row2 = genderExclusionData.addRow();
        row2.setInt("Index", index);
        row2.setInt("Style", styleGender);
        row2.setInt("Profession", professionGender);
        row2.setFloat("Color", ColorGender);
        row2.setString("Database", fileLocation);
      }
    }
    saveTable(genderExclusionData, fileNameGender); //save table as CSV file
    
    //calculate distance
    for (int i = 0; i < genderExclusionData.getRowCount(); i++) { 
      //read the values from the file
      TableRow row = genderExclusionData.getRow(i);
      int style = row.getInt("Style");
      int profession = row.getInt("Profession");
      int Color = row.getInt("Color");

      //form a feature array
      float[] features = { style, profession, Color };

      //calculate the distance
      float distance = getDistanceBetween(dataPoint, features);
      //add distance to csv
      row.setFloat("distance", distance);
    }
    //Save the table to the file folder
    saveTable(genderExclusionData, fileName); //save table as CSV file
    println("Saved as: ", fileName);
  }

  //sort distance
  genderExclusionData.setColumnType("distance", Table.FLOAT); //THIS FIXED IT
  genderExclusionData.sort("distance");
  println("Nearest Profiles Are:");
  for (int i = 0; i < k; i++) {
    TableRow row = genderExclusionData.getRow(i);
    int index = row.getInt("Index");
    int style = row.getInt("Style");
    int profession = row.getInt("Profession");
    int Color = row.getInt("Color");
    String fileLocation = row.getString("Database");
    float distanceTable = row.getFloat("distance");
    println("Index= " + index + " style= " + style + " profession= " + profession + " Color = " + Color + " distance = " + distanceTable + " fileLocation = " + fileLocation  );

    //check profiles
    if (i == 0) {
      outfitData1 = loadTable(fileLocation, "header");
      outfitData1.addColumn("distance");
    }
    if (i == 1) {
      outfitData2 = loadTable(fileLocation, "header");
      outfitData2.addColumn("distance");
    }
    if (i == 2) {
      outfitData3 = loadTable(fileLocation, "header");
      outfitData3.addColumn("distance");
    }
  }
  //KNN weather and outfits
  //Neares neighbor 1 
  for (int i = 0; i < outfitData1.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = outfitData1.getRow(i);
    int temperature = row.getInt("Temperature");
    int occasion = row.getInt("Occasion");
    int style = row.getInt("Style");
    int ranking = row.getInt("Ranking");

    //form a feature array
    float[] features = { temperature, occasion, style, ranking };
    
    //calculate the distance
    float distance = getDistanceBetween(dataPoint2, features);
    //add distance to csv
    row.setFloat("distance", distance);
  }
  for (int i = 0; i < outfitData2.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = outfitData2.getRow(i);
    int temperature = row.getInt("Temperature");
    int occasion = row.getInt("Occasion");
    int style = row.getInt("Style");
    int ranking = row.getInt("Ranking");

    //form a feature array
    float[] features = { temperature, occasion, style, ranking };

    //calculate the distance
    float distance = getDistanceBetween(dataPoint2, features);
    //add distance to csv
    row.setFloat("distance", distance);
  }
  for (int i = 0; i < outfitData3.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = outfitData3.getRow(i);
    int temperature = row.getInt("Temperature");
    int occasion = row.getInt("Occasion");
    int style = row.getInt("Style");
    int ranking = row.getInt("Ranking");

    //form a feature array
    float[] features = { temperature, occasion, style, ranking };

    //calculate the distance
    float distance = getDistanceBetween(dataPoint2, features);
    //add distance to csv
    row.setFloat("distance", distance);
  }

  outfitData1.setColumnType("distance", Table.FLOAT); //THIS FIXED IT
  outfitData2.setColumnType("distance", Table.FLOAT); //THIS FIXED IT
  outfitData3.setColumnType("distance", Table.FLOAT); //THIS FIXED IT
  outfitData1.sort("distance");
  outfitData2.sort("distance");
  outfitData3.sort("distance");

  println();
  saveTable(outfitData1, "data/profiles/sorted1.csv" ); //save table as CSV file
  println("Saved as: data/profiles/sorted1.csv");
  saveTable(outfitData2, "data/profiles/sorted2.csv"); //save table as CSV file
  println("Saved as: data/profiles/sorted2.csv");
  saveTable(outfitData3, "data/profiles/sorted3.csv"); //save table as CSV file
  println("Saved as: data/profiles/sorted3.csv");

  combineProfile(outfitData1, 3);
  combineProfile(outfitData2, 6);
  combineProfile(outfitData3, 9);
  
  sortTable(combinedProfiles);
  println();
  saveTable(combinedProfiles, "data/profiles/combinedProfiles.csv"); //save table as CSV file
  println("Saved as: data/profiles/combinedProfiles.csv");
  println();
  
  println("Nearest Outfits Are:");
  
  //Print out nearest neighbors
  for (int i = 0; i < k; i++){
    TableRow rowIn = combinedProfiles.getRow(i);
    
    int day = rowIn.getInt("day");
    int temperature = rowIn.getInt("Temperature");
    int occasion = rowIn.getInt("Occasion");
    int style = rowIn.getInt("Style");
    int ranking = rowIn.getInt("Ranking");
    float distance = rowIn.getFloat("distance");
    int itemId1 = rowIn.getInt("item id 1");
    int itemId2 = rowIn.getInt("item id 2");
    int itemId3 = rowIn.getInt("item id 3");
    
    if (i == 0) {
      String itemPath1 = rowIn.getString("item path 1");
        drawImage(itemPath1,0,0);
      String itemPath2 = rowIn.getString("item path 2");
        drawImage(itemPath2,(width/5)-100,0);
      String itemPath3 = rowIn.getString("item path 3");
        drawImage(itemPath3,(width/5)*2-200,0);
      String itemPath4 = rowIn.getString("item path 4");
        drawImage(itemPath4,(width/5)*3-300,0);
      String itemPath5 = rowIn.getString("item path 5");
        drawImage(itemPath5,(width/5)*4-400,0);
           
    }
    
    if (i == 1) {
      String itemPath1 = rowIn.getString("item path 1");
        drawImage(itemPath1,0,height/3+10);
      String itemPath2 = rowIn.getString("item path 2");
        drawImage(itemPath2,(width/5)-100,height/3+10);
      String itemPath3 = rowIn.getString("item path 3");
        drawImage(itemPath3,(width/5)*2-200,height/3+10);
      String itemPath4 = rowIn.getString("item path 4");
        drawImage(itemPath4,(width/5)*3-300,height/3+10);
      String itemPath5 = rowIn.getString("item path 5");
        drawImage(itemPath5,(width/5)*4-400,height/3+10);
    }
    
    if (i == 2) {
      String itemPath1 = rowIn.getString("item path 1");
        drawImage(itemPath1,0,(height/3)*2+20);
      String itemPath2 = rowIn.getString("item path 2");
        drawImage(itemPath2,(width/5)-100,(height/3)*2+20);
      String itemPath3 = rowIn.getString("item path 3");
        drawImage(itemPath3,(width/5)*2-200,(height/3)*2+20);
      String itemPath4 = rowIn.getString("item path 4");
        drawImage(itemPath4,(width/5)*3-300,(height/3)*2+20);
      String itemPath5 = rowIn.getString("item path 5");
        drawImage(itemPath5,(width/5)*4-400,(height/3)*2+20);
    }
    
    
    println("Day = " + day + " Temperature = " + temperature + " Occasion = " + occasion + " Style = " + style + " Ranking = " + ranking + " item id 1 = " + itemId1 + " item id 2 = " + itemId2 + " item id 3 = " + itemId3 + " Distance = " + distance);

  }
 
  noLoop();
}

public Float getDistanceBetween(float[] dataElement1, float[] dataElement2) {

  
  int x1 =  Math.round(dataElement1[0]*1.2   ) ;
  int y1 =  Math.round(dataElement1[1]*0.9   ) ;
  int z1 =  Math.round(dataElement1[2] ) ;
  int x2 =   Math.round(dataElement2[0]*0.9   ) ;
  int y2 =  Math.round(dataElement2[1]*1.2   ) ;
  int z2 =  Math.round(dataElement2[2]*0.8   ) ;
  int term1 = (x2 - x1) * (x2 - x1);
  int term2 = (y2 - y1) * (y2 - y1);
  int term3 = (z2 - z1) * (z2 - z1);
  int sum = term1 + term2 + term3;
  String convertedSum = Integer.toString(sum);
  double convertedToDoubleSum = Double.parseDouble(convertedSum);
  double distance = Math.abs (Math.sqrt (convertedToDoubleSum ) );
  String convertedDistance = Double.toString(distance);
  return Float.parseFloat(convertedDistance);
}

public void combineProfile(Table tableInput, int x) {
  int i = 0;
  while (tableLength < x) {
    TableRow rowIn = tableInput.getRow(i);
    TableRow row = combinedProfiles.getRow(tableLength);

    int day = rowIn.getInt("day");
    int temperature = rowIn.getInt("Temperature");
    int occasion = rowIn.getInt("Occasion");
    int style = rowIn.getInt("Style");
    int ranking = rowIn.getInt("Ranking");
    float distance = rowIn.getFloat("distance");
    int itemId1 = rowIn.getInt("item id 1");
    int itemId2 = rowIn.getInt("item id 2");
    int itemId3 = rowIn.getInt("item id 3");
    int itemId4 = rowIn.getInt("item id 4");
    int itemId5 = rowIn.getInt("item id 5");
    String itemPath1 = rowIn.getString("item path 1");
    String itemPath2 = rowIn.getString("item path 2");
    String itemPath3 = rowIn.getString("item path 3");
    String itemPath4 = rowIn.getString("item path 4");
    String itemPath5 = rowIn.getString("item path 5");

    row.setInt("day", day);
    row.setInt("Temperature", temperature);
    row.setInt("Occasion", occasion);
    row.setInt("Ranking", ranking);
    row.setInt("Style", style);
    row.setFloat("distance", distance);
    row.setInt("item id 1", itemId1);
    row.setInt("item id 2", itemId2);
    row.setInt("item id 3", itemId3);
    row.setInt("item id 3", itemId4);
    row.setInt("item id 3", itemId5);
    row.setString("item path 1", itemPath1);
    row.setString("item path 2", itemPath2);
    row.setString("item path 3", itemPath3);
    row.setString("item path 4", itemPath4);
    row.setString("item path 5", itemPath5);
    
    
    i++;
    tableLength++;
  }
}

void drawImage(String imageLocation, int x, int y){
  img = loadImage(imageLocation);
  img.resize(0,height/3);
  image(img, x, y);
}

void sortTable(Table table) {
  table.setColumnType("distance", Table.FLOAT); //THIS FIXED IT
  table.sort("distance");
}

void checkColor (int colorName, String colorClothing){
    for (TableRow row : wardrobe.matchRows(colorClothing, "Color")) {
      colorName++;
    }
    TableRow rows = favoriteColor.getRow(rowCount);
    rows.setString("Color",colorClothing);
    rows.setInt("Amount",colorName);
    rows.setInt("ColorIndex",rowCount);
    rowCount++;
}

void checkStyle (int styleName, String styleClothing){
    for (TableRow row1 : newprofile.matchRows(styleClothing, "Style")) {
      styleName++;
    }
    TableRow rows = favoriteStyle.getRow(rowCount1);
    rows.setString("Style", styleClothing);
    rows.setInt("Amount", styleName);
    rows.setInt("StyleIndex", rowCount1);
    rowCount1++;
}

//void avgStyle (int style) {
//  int sum = style;

//   for (int i = 0; i < rowCount2; i++){
//    TableRow avgrow = newprofile.getRow(i);
//    int avg = avgrow.getInt("Style");
//    int totalsum = i*avg+sum;
    
//    println(totalsum);
//   }
   
//}

void keyPressed() {
  float stylefactor = 1.1;
  
  
  if (key == CODED) {
    if (keyCode == UP) {
   
    TableRow row = combinedProfiles.getRow(0);
    int style = row.getInt("Style");    
    TableRow rows = newprofile.getRow(rowCount2);
    rows.setInt("Style", style);
    
    saveTable(newprofile, "data/profiles/new.csv");
    rowCount2++;
    //Amount1++;
    println(favoriteColor + " : " + style);
    println();
    
    //avgStyle(style);
    
    } else if (keyCode == LEFT) {
    TableRow row = combinedProfiles.getRow(1);
    int style = row.getInt("Style");
    TableRow rows = newprofile.getRow(rowCount2);
    rows.setInt("Style", style);
    saveTable(newprofile, "data/profiles/new.csv");
    rowCount2++;
    //Amount2++;
    
    println(favoriteColor + " : " + style);
    println();
      
    } else if (keyCode == DOWN) {
    TableRow row = combinedProfiles.getRow(2);
    int style = row.getInt("Style");
    TableRow rows = newprofile.getRow(rowCount2);
    rows.setInt("Style", style);
    saveTable(newprofile, "data/profiles/new.csv");
    rowCount2++;
    //Amount3++;
    
    println(favoriteColor + " : " + style);
    println();
      
    }
  } else {
    println("nope");
  }
   
  
}
