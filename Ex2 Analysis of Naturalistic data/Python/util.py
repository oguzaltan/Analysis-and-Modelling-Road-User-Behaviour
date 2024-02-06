#   Author: Alexander Rasch - alexander.rasch@chalmers.se
#           Pierluigi Olleja - pierluigi.olleja@chalmers.se
#   Institution: Chalmers University of Technology
#   Date: September 2022
#   Course: IDEA League summer school (Analysis and modelling road user behaviour)

import numpy as np
from scipy.io import loadmat
import matplotlib.pyplot as plt
from datetime import datetime, date, time
import pandas as pd
import sys

class Sensor:
    r"""
    Sensor data.
    This class contains attributes containing sensor data
    for a specific event.

    Parameters
    ----------
    start, stop, speed, long_accel, accel_gyro, 
        brake_pedal, left_turn_signal, right_turn_signal, 
        throttle, front_radar, rear_radar, light : float
    """

    def __init__(
        self, start, stop, speed, long_accel, accel_gyro, 
        brake_pedal, left_turn_signal, right_turn_signal, 
        throttle, front_radar, rear_radar, light
    ):
        self.start = start
        self.stop = stop
        self.speed = speed
        self.long_accel = long_accel
        self.accel_gyro = accel_gyro
        self.brake_pedal = brake_pedal
        self.left_turn_signal = left_turn_signal
        self.right_turn_signal = right_turn_signal
        self.throttle = throttle
        self.front_radar = front_radar
        self.rear_radar = rear_radar
        self.light = light

class Video():
    r"""
    Sensor data.
    This class contains attributes containing sensor data
    for a specific event.

    Parameters
    ----------
    ID, vehicle_webid, start, end, severity, subject_ID, age, gender, 
        nature, incident_type, pre_incident_maneuver, maneuver_judgment, 
        precipitating_event, driver_reaction, post_maneuver_control, 
        driver_behaviour_1, driver_behaviour_2, driver_behaviour_3, 
        driver_impairments, infrastructure, 
        distraction_1, distraction_1_start_sync, distraction_1_end_sync, distraction_1_outcome, 
        distraction_2, distraction_2_start_sync, distraction_2_end_sync, distraction_2_ouctome, 
        distraction_3, distraction_3_start_sync, distraction_3_end_sync, distraction_3_outcome, 
        hands_on_wheel, vehicle_contributing_factors, visual_obstructions, surface_condition, 
        traffic_flow, travel_lanes, traffic_density, relation_to_junction, alignment, locality, 
        lighting, weather, driver_seatbelt_use, number_of_other_vehicles, fault, 
        vehicle_2_location, vehicle_2_type, vehicle_2_maneuver, vehicle_2_driver_reaction, 
        vehicle_3_location, vehicle_3_type, vehicle_3_maneuver, vehicle_3_driver_reaction, traffic_control : float
    """
    
    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)

class Glances:
    r"""
    Glance data.
    This class contains a pandas dataframe that stores the
    sequence of glances with start, stop, duration and location 

    Parameters
    ----------
    glances : pandas DataFrame
        Contains all glances that were annotated for the event,
        with columns "start", "stop", "duration" and "location"
    """

    def __init__(self):
        self.glances = pd.DataFrame(columns=["start", "stop", "duration", "location"])
        

def get_data(path):
    R"""
    Returns a 100-car data object, converted from MATLAB.

    Parameters
    ----------
    path: string
        Path to Event.mat
    """

    data_mat = loadmat(path)  # load mat-file

    data_mat = data_mat["Event"]

    # Data frame to build
    data = pd.DataFrame(columns=["ID", "Narratives", "Sensor", "Video", "Glance"])


    for idx_event in range(data_mat["Sensor"].shape[1]):
        # ID
        ID = data_mat["ID"][0, idx_event][0, 0]
        
        # Narratives
        narratives = data_mat["Narratives"][0, idx_event][0, 0][0]

        # Sensor
        sensor_data = \
            data_mat["Sensor"][0, idx_event][[
                "start", "stop", "speed", "long_accel", 
                "accel_gyro", "brake_pedal", "left_turn_signal", "right_turn_signal", 
                "throttle", "front_radar", "rear_radar", "light"]][0,0]
        sensor_data = np.asarray(sensor_data.item(), dtype=object)
        sensor_data_format = np.zeros((1, sensor_data.shape[0]))
        
        # Replace empty entries with NaN
        for idx in range(len(sensor_data)):
            if len(sensor_data[idx]) == 0:
                sensor_data_format[0, idx] = np.nan
            else:
                sensor_data_format[0, idx] = sensor_data[idx][0,0]
        
        sensor = Sensor(
            sensor_data_format[0, 0], sensor_data_format[0, 1], sensor_data_format[0, 2],
            sensor_data_format[0, 3], sensor_data_format[0, 4], sensor_data_format[0, 5],
            sensor_data_format[0, 6], sensor_data_format[0, 7], sensor_data_format[0, 8],
            sensor_data_format[0, 9], sensor_data_format[0, 10], sensor_data_format[0, 11]
        )

        # Video
        video_dict = {}
        keys = ['ID', 'vehicle_webid', 'start', 'end', 'severity', 'subject_ID', 'age', 'gender', 
            'nature', 'incident_type', 'pre_incident_maneuver', 'maneuver_judgment', 
            'precipitating_event', 'driver_reaction', 'post_maneuver_control', 
            'driver_behaviour_1', 'driver_behaviour_2', 'driver_behaviour_3', 
            'driver_impairments', 'infrastructure', 
            'distraction_1', 'distraction_1_start_sync', 'distraction_1_end_sync', 'distraction_1_outcome', 
            'distraction_2', 'distraction_2_start_sync', 'distraction_2_end_sync', 'distraction_2_ouctome', 
            'distraction_3', 'distraction_3_start_sync', 'distraction_3_end_sync', 'distraction_3_outcome', 
            'hands_on_wheel', 'vehicle_contributing_factors', 'visual_obstructions', 'surface_condition', 
            'traffic_flow', 'travel_lanes', 'traffic_density', 'relation_to_junction', 'alignment', 'locality', 
            'lighting', 'weather', 'driver_seatbelt_use', 'number_of_other_vehicles', 'fault', 
            'vehicle_2_location', 'vehicle_2_type', 'vehicle_2_maneuver', 'vehicle_2_driver_reaction', 
            'vehicle_3_location', 'vehicle_3_type', 'vehicle_3_maneuver', 'vehicle_3_driver_reaction', 'traffic_control']

        # Extract raw numbers from arrays    
        for idx_key in range(len(keys)):
            video_entry = data_mat["Video"][0, idx_event][0][0][idx_key]
            if video_entry.shape == (1,):
                video_dict[keys[idx_key]] = video_entry[0]
            else:
                video_dict[keys[idx_key]] = video_entry[0][0]

        video = Video(**video_dict)

        # Glances
        glance_row = lambda row : (row[0][0][0], row[1][0][0], row[2][0][0], row[3][0][0][0])
        
        glances = Glances()
        for idx_glance in range(data_mat[0, idx_event]["Glance"].shape[1]):
            glances.glances.loc[idx_glance] = glance_row(data_mat[0, idx_event]["Glance"][0, idx_glance])

        data.loc[idx_event, ["ID", "Narratives", "Sensor", "Video", "Glance"]] = \
            [ID, narratives, sensor, video, glances]

        # Status messages
        sys.stdout.write("\r")
        j = (idx_event + 1) / data_mat["Sensor"].shape[1]
        sys.stdout.write("[%-20s] %d%%" % ('='*int(20*j), 100*j))
        sys.stdout.flush()


    return data

def get_odds_ratio_ci(contingency_table):
    R"""
    Returns the odds ratio (OR) and 95% confidence interval (CI)
    for a given contingency table.

    Parameters
    ----------
    contingency_table: 2D numpy-array
        Contingency table [[], []], i.e., shape (2, 2)
    """

    n11 = contingency_table.iloc[0][0]
    n12 = contingency_table.iloc[0][1]
    n21 = contingency_table.iloc[1][0]
    n22 = contingency_table.iloc[1][1]

    # Odds ratio
    OR = (n11*n22) / (n12*n21)
 
    # Standard error for logs odds ratio
    SE = (1/n11 + 1/n22 + 1/n12 + 1/n21)**0.5

    CI95 = np.array([np.exp(np.log(OR) - 1.96 * SE), np.exp(np.log(OR) + 1.96 * SE)])
    #CI90 = np.array([np.exp(np.log(OR) - 1.645 * SE), np.exp(np.log(OR) + 1.645 * SE)])

    return (OR, CI95)