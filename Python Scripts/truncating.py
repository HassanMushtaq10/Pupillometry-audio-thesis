import soundfile as sf
import numpy as np

# Load the audio file
audio_data, sample_rate = sf.read("Mreged_mono_audio.wav")

# Calculate the number of samples for 1 minute
num_samples = int(sample_rate * 3)

# Truncate the audio data to 1 minute
audio_data = audio_data[:num_samples]

# Save the truncated audio file
sf.write("3S_mono.wav", audio_data, sample_rate)
