import soundfile as sf
import numpy as np

# Load the two mono audio files
audio_data1, sample_rate1 = sf.read("left_channel.wav")
audio_data2, sample_rate2 = sf.read("right_channel.wav")


# Check if the sample rates are the same
if sample_rate1 != sample_rate2:
    raise ValueError("Sample rates must be the same")

# Fuse the two audio files into a single mono file
merged_data = audio_data1 + audio_data2

# Clip the merged data to prevent clipping
merged_data = np.clip(merged_data, -32768, 32767)

# Save the merged audio file
sf.write("output.wav", merged_data, sample_rate1)
