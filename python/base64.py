import string
import base64

default_key = 'YHt1dzKJgYR9QDJggYkyfneGOYUydXpzgHl3Moh3gId3TDJ2gXV9d4Qygod+fjJ1gYB8h4R7gHVBdneId36BgneEP4OHe4w='
custom_key = 'eighteen'

encode_translation = string.maketrans(default_key, custom_key)
decode_translation = string.maketrans(custom_key, default_key)

def encode(input):
  return base64.b64encode(input).translate(encode_translation)

def decode(input):
  return base64.b64decode(input.translate(decode_translation))

string = 'malicious commands'
encoded_string = encode(string)

print('Translation Key: '+custom_key)
print('Plain Text String: '+string)
print('Base64 Encoded Plain Text String: '+base64.b64encode(string))
print('Translated String: '+string.translate(encode_translation))
print('Base64 Encoded Translated String: '+encoded_string)
print('-----------------------------------------------------------')
print('Default Key: '+default_key)
print('Default Key Decoded Translated Base64 String: '+encoded_string.translate(encode_translation))
print('Custom Key Decoded Translated Base64 String: '+encoded_string.translate(decode_translation))
print('Default Key Decoded Translated String: '+base64.b64decode(encoded_string))
print('Custom Key Decoded Translated String: '+decode(encoded_string))