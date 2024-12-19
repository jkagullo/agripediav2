class FuzzyLogic {

  static String getSoilMoistureRecommendation(int rawSoilMoisture) {

    if (rawSoilMoisture < 30) {
      return "Crop needs water";
    } else if (rawSoilMoisture >= 30 && rawSoilMoisture < 40) {
      return "Water crop moderately";
    } else if (rawSoilMoisture >= 50 && rawSoilMoisture <= 70) {
      return "Maintain current watering habit";
    } else if (rawSoilMoisture >= 50 && rawSoilMoisture <= 80) {
      return "Reduce watering frequency";
    } else if (rawSoilMoisture > 80) {
      return "Stop watering to avoid waterlogging";
    } else {
      return "Moisture level unknown";
    }
  }

  static String getSoilMoistureStatus(int rawSoilMoisture) {

    if (rawSoilMoisture < 30) {
      return "Soil moisture is below (30%)";
    } else if (rawSoilMoisture >= 30 && rawSoilMoisture < 40) {
      return "Soil moisture is low (30% - 40%)";
    } else if (rawSoilMoisture >= 50 && rawSoilMoisture <= 70) {
      return "Soil moisture is optimal (50% - 70%)";
    } else if (rawSoilMoisture >= 70 && rawSoilMoisture <= 80) {
      return "Soil moisture is high (70% - 80%)";
    } else if (rawSoilMoisture > 80) {
      return "Soil moisture is very high (above 80%)";
    } else {
      return "Moisture level unknown";
    }
  }

  static String getHumidityRecommendation(int rawhHumidity) {

    if (rawhHumidity < 50) {
      return "Crop needs humidity, mist or spray water";
    } else if (rawhHumidity >= 50 && rawhHumidity <= 70) {
      return "Crop's humidity is good";
    } else {
      return "Reduce misting or spraying to lower humidity";
    }
  }

  static String getHumidityStatus(int rawHumidity) {

    if (rawHumidity < 50) {
      return "Humidity is below 50%";
    } else if (rawHumidity >= 50 && rawHumidity <= 70) {
      return "Humidity is in its optimal range (50% - 70%)";
    } else {
      return "Humidity is above 70%";
    }
  }

  static String getLightRecommendation(int rawLight) {

    if (rawLight <= 150) {
      return "Expose crop to more light";
    } else if (rawLight <= 200) {
      return "Maintain current light exposure";
    } else if (rawLight >= 280 && rawLight <= 350) {
      return "No adjustments needed";
    } else if (rawLight >= 350 && rawLight <= 450) {
      return "Reduce exposure to direct sunlight";
    }  else {
      return "Move crops to shaded area";
    }
  }

  static String getLightStatus(int rawLight) {

    if (rawLight <= 150) {
      return "Light intensity is low";
    } else if (rawLight <= 200) {
      return "Light intensity is moderate";
    } else if (rawLight >= 280 && rawLight <= 350) {
      return "Light intensity is optimal";
    } else if (rawLight >= 350 && rawLight <= 450) {
      return "Light intensity is high";
    }  else {
      return "Light intensity is very high";
    }
  }

  static String getTemperatureRecommendation(int rawTemperature){

    if (rawTemperature <= 10) {
      return "Move the crop to a warmer location";
    } else if (rawTemperature >= 10 && rawTemperature < 18) {
      return "Ensure the plant is in a draft-free location";
    } else if (rawTemperature >= 18 && rawTemperature <= 26) {
      return "Temperature is optimal";
    } else if (rawTemperature >= 26 && rawTemperature <= 35) {
      return "Provide shade or move the crop to a cooler spot";
    }  else {
      return "Move the crop into a cooler area";
    }
  }

  static getTemperatureStatus(int rawTemperature) {

    if (rawTemperature < 10) {
      return "Temperature is below 10%";
    } else if (rawTemperature >= 10 && rawTemperature < 18) {
      return "Temperature is low (10°C - 17°C).";
    } else if (rawTemperature >= 18 && rawTemperature <= 26) {
      return "Temperature is optimal (18°C - 26°C).";
    } else if (rawTemperature > 26 && rawTemperature <= 35) {
      return "Temperature is high (27°C - 35°C).";
    } else {
      return "Temperature is above 35°C.";
    }
  }

  static String getPlantCondition({
    required int rawSoilMoisture,
    required int rawTemperature,
    required int rawHumidity,
    required int rawLight,
  }) {
    String soilMoistureStatus = getSoilMoistureStatus(rawSoilMoisture);
    String tempStatus = getTemperatureStatus(rawTemperature);
    String humidityStatus = getHumidityStatus(rawHumidity);
    String lightStatus = getLightStatus(rawLight);

    if (soilMoistureStatus.contains('very low') &&
        tempStatus.contains('below 10') &&
        humidityStatus.contains('below 50') &&
        lightStatus.contains('low')) {
      return 'VeryBad';
    }

    if ((soilMoistureStatus.contains('very low') &&
        tempStatus.contains('low') &&
        (humidityStatus.contains('below 50') || lightStatus.contains('low'))) ||
        soilMoistureStatus.contains('very low')) {
      return 'Bad';
    }

    if ((soilMoistureStatus.contains('optimal') &&
        tempStatus.contains('high') &&
        (humidityStatus.contains('below 50') || lightStatus.contains('low'))) ||
        soilMoistureStatus.contains('optimal')) {
      return 'Fair';
    }

    if ((soilMoistureStatus.contains('high') && tempStatus.contains('high') &&
        humidityStatus.contains('high') && lightStatus.contains('high')) ||
        soilMoistureStatus.contains('high')) {
      return 'Excellent';
    }

    if ((soilMoistureStatus.contains('optimal') &&
        tempStatus.contains('optimal') &&
        humidityStatus.contains('optimal') &&
        lightStatus.contains('optimal')) ||
        soilMoistureStatus.contains('optimal')) {
      return 'Excellent';
    }

    return 'Unknown';
  }
}