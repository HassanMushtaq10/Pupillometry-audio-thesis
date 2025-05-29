# This script applies sound level changes to specific chunks of an audio file
# and exports each variant as a separate audio file with the specified sound level changes.

import numpy as np
import soundfile as sf

# Define the audio data and sample rate
audio_data, sample_rate = sf.read('37S_mono.wav')

# Define the variants with sound level changes
variants = [
    {"start": 5, "end": 10, "db": 3},  # increase level by 6 dB from 10-15 seconds
    {"start": 15, "end": 20, "db": -3},  # decrease level by 3 dB from 30-35 seconds
    {"start": 10, "end": 15, "db": 12},  # increase level by 9 dB from 50-55 seconds
    {"start": 26, "end": 31, "db": -12},  # increase level by 4.5 dB from 10-15 seconds
    {"start": 8, "end": 13, "db": 8},  # decrease level by 9 dB from 40-45 seconds
    {"start": 9, "end": 14, "db": -8}  # increase level by 12 dB from 5-10 seconds
]

# Loop through each variant and apply the sound level change
for i, variant in enumerate(variants):
    # Create a copy of the original audio data
    audio_data_variant = audio_data.copy()

    # Calculate the start and end samples
    start_sample = int(variant["start"] * sample_rate)
    end_sample = int(variant["end"] * sample_rate)

    # Convert dB to gain
    gain = 10 ** (variant["db"] / 20)

    # Apply the level change directly to the specified chunk of audio
    audio_data_variant[start_sample:end_sample] *= gain

    # Clip the audio data to prevent clipping
    audio_data_variant = np.clip(audio_data_variant, -32768, 32767)

    # Export the variant audio file
    x = variant["db"]
    y = variant["start"]
    z = variant["end"]
    sf.write(f"Sound_level_{x}dB_{y}_to_{z}_sec.wav", audio_data_variant, sample_rate)

    print(f"Variant {i+1} exported: Sound_level_{x}dB_{y}_to_{z}_sec.wav")
