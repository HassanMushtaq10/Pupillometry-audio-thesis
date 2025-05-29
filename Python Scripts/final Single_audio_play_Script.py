import os
import numpy as np
from tobiiglassesctrl import TobiiGlassesController
import datetime
import keyboard
import glob
import time

def main():
    update_rate = 60
    pd_size_left = np.zeros((update_rate * 10,), dtype='float32')
    pd_size_right = np.zeros((update_rate * 10,), dtype='float32')

    pd_size_left_means = np.zeros((7,), dtype='float32')
    pd_size_right_means = np.zeros((10,), dtype='float32')

    response_time = np.zeros(2,)
    response_time_per_trial = np.zeros(shape=[1, 2], dtype='object')

    tobiiglasses = TobiiGlassesController("192.168.0.2")
    print("Battery Status: {}".format(tobiiglasses.get_battery_status()))

    tobiiglasses.set_et_freq_100()
    print("Eye Tracker Frequency: {}".format(tobiiglasses.get_et_freq()))
    print("Available Frequencies: {}".format(tobiiglasses.get_et_frequencies()))

    if tobiiglasses.is_recording():
        rec_id = tobiiglasses.get_current_recording_id()
        tobiiglasses.stop_recording(rec_id)

    project_name = 'Pre_Test'
    project_id = tobiiglasses.create_project(project_name)
    participant_name = input("Please insert the participant's name: ")
    participant_id = tobiiglasses.create_participant(project_id, participant_name)

    calibration_id = tobiiglasses.create_calibration(project_id, participant_id)
    input("Put the calibration marker in front of the user, then press enter to calibrate")
    tobiiglasses.start_calibration(calibration_id)

    res = tobiiglasses.wait_until_calibration_is_done(calibration_id)
    if not res:
        print("Calibration failed!")
        exit(1)

    print("Press spacebar to continue")
    keyboard.wait('space')
    print("Spacebar pressed, continuing...")

    tobiiglasses.start_streaming()
    print("Please wait ...")
    time.sleep(3.0)

    #audio_folder = 'D:\Tobii Audio\Pupillometry_MA_Thesis_Hassan\Final Test\Sync\Playlist 1'
    #audio_folder = 'D:\Tobii Audio\Pupillometry_MA_Thesis_Hassan\Final Test\Sync\Playlist 2'
    #audio_folder = 'D:\Tobii Audio\Pupillometry_MA_Thesis_Hassan\Final Test\onSync\Playlist 1'
    audio_folder = 'D:\Tobii Audio\Pupillometry_MA_Thesis_Hassan\Final Test\onSync\Playlist 2'
    audio_files = glob.glob(os.path.join(audio_folder, '*.mp4'))
    output_folder = participant_name

    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    print("Saving files to: {}".format(output_folder))

    for i, audio_file in enumerate(audio_files):
        print("\n--- Trial {}/{} ---".format(i + 1, len(audio_files)))
        print("Start Video: {}".format(audio_file))
        np_2d_arr = np.zeros(shape=[1, 17])

        os.startfile(audio_file)

        last_time = datetime.datetime.utcnow()
        recording_duration = 37
        elapsed_time = 0

        while elapsed_time < recording_duration:
            time.sleep(0.001)

            try:
                data = tobiiglasses.get_data()
                data_left = data['left_eye']
                data_right = data['right_eye']
                data_gaze_left = data_left['gd']['gd']
                data_gaze_right = data_right['gd']['gd']
                gaze_point = data['gp']['gp']
            except Exception as e:
                print("Error fetching eye-tracker data: {}".format(e))
                continue

            pd_size_left[0] = data_left['pd']['pd']
            pd_size_right[0] = data_right['pd']['pd']
            pd_size_left = np.roll(pd_size_left, 1)
            pd_size_right = np.roll(pd_size_right, 1)

            timeline_left = data_left['pd']['ts']
            timeline_right = data_right['pd']['ts']

            gaze_left_x, gaze_left_y, gaze_left_z = data_gaze_left
            gaze_right_x, gaze_right_y, gaze_right_z = data_gaze_right
            gaze_point_x, gaze_point_y = gaze_point

            pd_size_left_means[0] = pd_size_left[0]
            pd_size_left_means[1] = np.round(np.mean(pd_size_left[:int(round(update_rate * 0.1))]), 2)
            pd_size_left_means[2] = np.round(np.mean(pd_size_left[:int(round(update_rate * 1))]), 2)
            pd_size_left_means[3:6+1] = [gaze_left_x, gaze_left_y, gaze_left_z, timeline_left]

            pd_size_right_means[0] = pd_size_right[0]
            pd_size_right_means[1] = np.round(np.mean(pd_size_right[:int(round(update_rate * 0.1))]), 2)
            pd_size_right_means[2] = np.round(np.mean(pd_size_right[:int(round(update_rate * 1))]), 2)
            pd_size_right_means[3:6+1] = [gaze_right_x, gaze_right_y, gaze_right_z, timeline_right]
            pd_size_right_means[7:9+1] = [gaze_point_x, gaze_point_y, (datetime.datetime.utcnow() - last_time).total_seconds()]

            pd_size_l_and_r_means = np.concatenate((pd_size_left_means, pd_size_right_means))
            np_2d_arr = np.append(np_2d_arr, [pd_size_l_and_r_means], axis=0)

            elapsed_time = (datetime.datetime.utcnow() - last_time).total_seconds()

        np_2d_arr = np.delete(np_2d_arr, 0, axis=0)

        base_filename = os.path.splitext(os.path.basename(audio_file))[0]
        csv_path = os.path.join(output_folder, base_filename + '.csv')

        try:
            np.savetxt(csv_path, np_2d_arr, delimiter=',',
                       header='L_current,L_100ms,L_1s,Gaze_L_x,Gaze_L_y,Gaze_L_z,Timeline_L,'
                              'R_current,R_100ms,R_1s,Gaze_R_x,Gaze_R_y,Gaze_R_z,Timeline_R,'
                              'Gaze_point_x,Gaze_point_y,Loop_duration[s]',
                       comments='')
            print("Data saved to: {}".format(csv_path))
        except Exception as e:
            print("Failed to save file {}: {}".format(csv_path, e))

        time.sleep(7)

    tobiiglasses.stop_streaming()
    tobiiglasses.close()
    print("\nAll trials completed. Eye tracker stopped.")

if __name__ == '__main__':
    main()
