import numpy as np
import soundfile as sf

audio, sr = sf.read('Ms_Pride_and_Xavier48kHz_lang.wav')

# Check if the audio file is mono
if len(audio.shape) == 1:
    # The audio file is mono, so we don't need to separate channels
    left_channel = audio
    right_channel = audio
else:
    # Separate the channels
    left_channel = audio[:, 0]
    right_channel = audio[:, 1]

# Save the separated channels (optional)
sf.write('left_channel.wav', left_channel, sr)
sf.write('right_channel.wav', right_channel, sr)
